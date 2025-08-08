const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const UserRepository = require('../repositories/user-repository');
const { CreateUserDTO, UpdateUserDTO, UserResponseDTO } = require('../dto/user-dto');
const { ValidationException, UnauthorizedException, NotFoundException } = require('../exceptions/app-exception');

/**
 * UserService - Lógica de negócio para usuários
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class UserService {
  constructor() {
    this.repository = new UserRepository();
    // Configurações de segurança
    this.BCRYPT_ROUNDS = parseInt(process.env.BCRYPT_ROUNDS) || 14; // Mais seguro que 12
    this.PASSWORD_PEPPER = process.env.PASSWORD_PEPPER || 'medical-consultation-pepper-2025-secure';
    this.MAX_LOGIN_ATTEMPTS = parseInt(process.env.MAX_LOGIN_ATTEMPTS) || 5;
    this.LOCKOUT_DURATION = parseInt(process.env.LOCKOUT_DURATION) || 15; // minutos
  }

  async updateFcmToken(userId, fcmToken) {
    // Atualiza o campo fcmToken do usuário
    return this.repository.update(userId, { fcmToken });
  }

  async register(userData) {
    // Validação com DTO
    const createUserDTO = new CreateUserDTO(userData);
    const validationErrors = createUserDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se email já existe
    try {
      await this.repository.findByEmail(userData.email);
      throw new ValidationException('Email already exists');
    } catch (error) {
      if (error instanceof NotFoundException) {
        // Email não existe, pode continuar
      } else {
        throw error;
      }
    }

    // Hash da senha com salt + pepper
    const hashedPassword = await this.hashPassword(userData.password);

    // Preparar dados para criação
    const userEntity = createUserDTO.toEntity();
    userEntity.password = hashedPassword;

    let user;
    if (userEntity.userType === 'DOCTOR') {
      // Remover campos que pertencem ao DoctorProfile
      const { specialty, crm, bio, hourlyRate, ...userFields } = userEntity;
      user = await this.repository.prisma.$transaction(async (tx) => {
        const createdUser = await tx.user.create({
          data: {
            ...userFields,
            doctorProfile: {
              create: {
                crm: crm,
                specialty: specialty,
                bio: bio,
                consultationFee: hourlyRate || 100,
                experience: userData.experience || 1,
                education: userData.education || [],
                certifications: userData.certifications || [],
                isAvailable: true,
                availability: userData.availability || {},
              }
            }
          }
        });
        return createdUser;
      });
    } else {
      user = await this.repository.create(userEntity);
    }

    // Gerar token JWT e refresh token
    const token = this.generateToken(user);
    const refreshToken = this.generateRefreshToken(user);

    return {
      user: UserResponseDTO.fromEntity(user),
      token,
      refreshToken
    };
  }

  async login(email, password) {
    // Buscar usuário por email
    const user = await this.repository.findByEmail(email);

    // Verificar se conta está bloqueada
    if (user.isLocked && user.lockoutUntil && new Date() < user.lockoutUntil) {
      const remainingMinutes = Math.ceil((user.lockoutUntil - new Date()) / (1000 * 60));
      throw new UnauthorizedException(`Account is locked. Try again in ${remainingMinutes} minutes.`);
    }

    // Verificar senha com salt + pepper
    const isPasswordValid = await this.verifyPassword(password, user.password);

    if (!isPasswordValid) {
      // Incrementar tentativas de login
      await this.handleFailedLogin(user);
      throw new UnauthorizedException('Invalid credentials');
    }

    // Reset de tentativas de login em caso de sucesso
    if (user.loginAttempts > 0) {
      await this.resetLoginAttempts(user.id);
    }

    // Gerar token JWT e refresh token
    const token = this.generateToken(user);
    const refreshToken = this.generateRefreshToken(user);

    return {
      user: UserResponseDTO.fromEntity(user),
      token,
      refreshToken
    };
  }

  async refreshToken(refreshToken) {
    try {
      // Verificar se o refresh token é válido
      const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);

      // Buscar usuário pelo ID do token
      const user = await this.repository.findById(decoded.id);

      if (!user) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      // Gerar novo token JWT
      const newToken = this.generateToken(user);

      return {
        token: newToken,
        refreshToken: refreshToken // Manter o mesmo refresh token
      };
    } catch (error) {
      if (error.name === 'TokenExpiredError') {
        throw new UnauthorizedException('Refresh token expired');
      } else if (error.name === 'JsonWebTokenError') {
        throw new UnauthorizedException('Invalid refresh token');
      }
      throw error;
    }
  }

  async findById(id) {
    const user = await this.repository.findById(id);
    return UserResponseDTO.fromEntity(user);
  }

  async findAll(filters = {}) {
    const result = await this.repository.findAll(filters);
    return {
      users: UserResponseDTO.fromEntities(result.users),
      pagination: result.pagination
    };
  }

  async update(id, userData) {
    // Validação com DTO
    const updateUserDTO = new UpdateUserDTO(userData);
    const validationErrors = updateUserDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Preparar dados para atualização
    const userEntity = updateUserDTO.toEntity();

    // Atualizar usuário
    const user = await this.repository.update(id, userEntity);
    return UserResponseDTO.fromEntity(user);
  }

  async delete(id) {
    return await this.repository.delete(id);
  }

  async findBySpecialty(specialty) {
    const doctors = await this.repository.findBySpecialty(specialty);
    return UserResponseDTO.fromEntities(doctors);
  }

  async getDoctorsWithStats() {
    const doctors = await this.repository.getDoctorsWithStats();
    return doctors.map(doctor => {
      const avgRating = doctor.receivedRatings.length > 0
        ? doctor.receivedRatings.reduce((sum, r) => sum + r.rating, 0) / doctor.receivedRatings.length
        : 0;

      return {
        ...UserResponseDTO.fromEntity(doctor),
        stats: {
          totalConsultations: doctor._count.doctorConsultations,
          totalRatings: doctor._count.ratings,
          averageRating: avgRating
        }
      };
    });
  }

  async changePassword(id, currentPassword, newPassword) {
    const user = await this.repository.findById(id);

    // Verificar senha atual
    const isCurrentPasswordValid = await this.verifyPassword(currentPassword, user.password);
    if (!isCurrentPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Validar nova senha
    if (!newPassword || newPassword.length < 8) {
      throw new ValidationException('New password must be at least 8 characters long');
    }

    // Verificar se nova senha é diferente da atual
    if (await this.verifyPassword(newPassword, user.password)) {
      throw new ValidationException('New password must be different from current password');
    }

    // Hash da nova senha com salt + pepper
    const hashedNewPassword = await this.hashPassword(newPassword);

    // Atualizar senha
    await this.repository.updatePassword(id, hashedNewPassword);

    return { message: 'Password updated successfully' };
  }

  async verifyUser(id) {
    const user = await this.repository.verifyUser(id);
    return UserResponseDTO.fromEntity(user);
  }

  generateToken(user) {
    const payload = {
      id: user.id,
      email: user.email,
      userType: user.userType,
    };

    return jwt.sign(
      payload,
      process.env.JWT_SECRET,
      {
        expiresIn: process.env.JWT_EXPIRES_IN || '2h',
        algorithm: 'HS256'
      }
    );
  }

  generateRefreshToken(user) {
    const payload = {
      id: user.id,
      type: 'refresh'
    };

    return jwt.sign(
      payload,
      process.env.JWT_REFRESH_SECRET,
      {
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
        algorithm: 'HS256'
      }
    );
  }

  verifyToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET, { algorithms: ['HS256'] });
    } catch (error) {
      throw new UnauthorizedException('Invalid token');
    }
  }

  async validate(data) {
    const createUserDTO = new CreateUserDTO(data);
    return createUserDTO.validate();
  }

  /**
   * Hash de senha com salt + pepper
   * Segurança máxima contra ataques de rainbow table
   */
  async hashPassword(password) {
    // Pepper (chave secreta adicional)
    const pepper = this.PASSWORD_PEPPER;

    // Combinar senha + pepper
    const passwordWithPepper = password + pepper;

    // Hash com bcrypt (já inclui salt automático)
    // Rounds = 14 (muito mais seguro que 12)
    return await bcrypt.hash(passwordWithPepper, this.BCRYPT_ROUNDS);
  }

  /**
   * Verificar senha com salt + pepper
   */
  async verifyPassword(password, hashedPassword) {
    // Pepper (mesmo usado no hash)
    const pepper = this.PASSWORD_PEPPER;

    // Combinar senha + pepper
    const passwordWithPepper = password + pepper;

    // Verificar com bcrypt
    return await bcrypt.compare(passwordWithPepper, hashedPassword);
  }

  /**
   * Lidar com tentativa de login falhada
   */
  async handleFailedLogin(user) {
    const loginAttempts = (user.loginAttempts || 0) + 1;
    const isLocked = loginAttempts >= this.MAX_LOGIN_ATTEMPTS;
    const lockoutUntil = isLocked ? new Date(Date.now() + (this.LOCKOUT_DURATION * 60 * 1000)) : null;

    await this.repository.update(user.id, {
      loginAttempts,
      isLocked,
      lockoutUntil
    });
  }

  /**
   * Reset de tentativas de login
   */
  async resetLoginAttempts(userId) {
    await this.repository.update(userId, {
      loginAttempts: 0,
      isLocked: false,
      lockoutUntil: null
    });
  }

  /**
   * Gerar senha temporária segura
   */
  generateSecurePassword() {
    const length = 16;
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
    let password = '';

    for (let i = 0; i < length; i++) {
      password += charset.charAt(crypto.randomInt(charset.length));
    }

    return password;
  }

  // Buscar especialidades
  async getSpecialties() {
    const specialties = await this.repository.getSpecialties();
    return specialties;
  }

  // Buscar médicos online
  async getOnlineDoctors() {
    const doctors = await this.repository.getOnlineDoctors();
    return UserResponseDTO.fromEntities(doctors);
  }

  // Buscar médicos favoritos
  async getFavoriteDoctors(userId) {
    const favorites = await this.repository.getFavoriteDoctors(userId);
    return UserResponseDTO.fromEntities(favorites);
  }

  // Adicionar/remover médico dos favoritos
  async toggleFavorite(userId, doctorId) {
    const result = await this.repository.toggleFavorite(userId, doctorId);
    return result;
  }

  // Dashboard do médico
  async getDoctorDashboard(doctorId) {
    const dashboard = await this.repository.getDoctorDashboard(doctorId);
    return dashboard;
  }

  // Dashboard do paciente
  async getPatientDashboard(patientId) {
    const dashboard = await this.repository.getPatientDashboard(patientId);
    return dashboard;
  }

  // Estatísticas do médico
  async getDoctorStats(doctorId) {
    const stats = await this.repository.getDoctorStats(doctorId);
    return stats;
  }

  // Pacientes recentes do médico
  async getRecentPatients(doctorId) {
    const patients = await this.repository.getRecentPatients(doctorId);
    return patients;
  }

  // Receita do médico
  async getDoctorRevenue(doctorId) {
    const revenue = await this.repository.getDoctorRevenue(doctorId);
    return revenue;
  }

  // Médicos favoritos do paciente
  async getPatientFavoriteDoctors(patientId) {
    const doctors = await this.repository.getPatientFavoriteDoctors(patientId);
    return doctors;
  }

  // Histórico médico do paciente
  async getPatientMedicalHistory(patientId) {
    const history = await this.repository.getPatientMedicalHistory(patientId);
    return history;
  }

  // Gastos médicos do paciente
  async getPatientExpenses(patientId) {
    const expenses = await this.repository.getPatientExpenses(patientId);
    return expenses;
  }
}

module.exports = UserService;
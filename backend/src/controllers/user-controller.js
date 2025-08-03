const UserService = require('../services/user-service');
const BaseController = require('../interfaces/base-controller');

/**
 * UserController - Controlador para operações de usuário
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class UserController extends BaseController {
  constructor() {
    const userService = new UserService();
    super(userService);
    this.userService = userService;
  }

  // Registro de usuário
  register = this.handleAsync(async (req, res) => {
    try {
      const { name, email, phone, password, userType, specialty, crm, bio, hourlyRate } = req.body;

      const result = await this.userService.register({
        name,
        email,
        phone,
        password,
        userType,
        specialty,
        crm,
        bio,
        hourlyRate
      });

      return this.sendSuccess(res, result, 'User registered successfully', 201);
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Login de usuário
  login = this.handleAsync(async (req, res) => {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return this.sendError(res, new Error('Email and password are required'), 400);
      }

      const result = await this.userService.login(email, password);

      return this.sendSuccess(res, result, 'Login successful');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Renovar token
  refreshToken = this.handleAsync(async (req, res) => {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken) {
        return this.sendError(res, new Error('Refresh token is required'), 400);
      }

      const result = await this.userService.refreshToken(refreshToken);

      return this.sendSuccess(res, result, 'Token refreshed successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar usuário por ID
  findById = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const user = await this.userService.findById(id);

      return this.sendSuccess(res, user, 'User found successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Listar todos os usuários com filtros
  findAll = this.handleAsync(async (req, res) => {
    try {
      const {
        userType,
        specialty,
        search,
        page,
        limit,
        orderBy,
        order
      } = req.query;

      const filters = {
        userType,
        specialty,
        search,
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 10,
        orderBy,
        order
      };

      const result = await this.userService.findAll(filters);

      return this.sendSuccess(res, result, 'Users retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Atualizar usuário
  update = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const updateData = req.body;

      const user = await this.userService.update(id, updateData);

      return this.sendSuccess(res, user, 'User updated successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Deletar usuário
  delete = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;

      await this.userService.delete(id);

      return this.sendSuccess(res, null, 'User deleted successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar médicos por especialidade
  findBySpecialty = this.handleAsync(async (req, res) => {
    try {
      const { specialty } = req.params;

      const doctors = await this.userService.findBySpecialty(specialty);

      return this.sendSuccess(res, doctors, 'Doctors found successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar médicos com estatísticas
  getDoctorsWithStats = this.handleAsync(async (req, res) => {
    try {
      const doctors = await this.userService.getDoctorsWithStats();

      return this.sendSuccess(res, doctors, 'Doctors with stats retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Alterar senha
  changePassword = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const { currentPassword, newPassword } = req.body;

      if (!currentPassword || !newPassword) {
        return this.sendError(res, new Error('Current password and new password are required'), 400);
      }

      const result = await this.userService.changePassword(id, currentPassword, newPassword);

      return this.sendSuccess(res, result, 'Password changed successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Verificar usuário
  verifyUser = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;

      const user = await this.userService.verifyUser(id);

      return this.sendSuccess(res, user, 'User verified successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Validar dados de usuário
  validate = this.handleAsync(async (req, res) => {
    try {
      const userData = req.body;
      const errors = await this.userService.validate(userData);

      if (errors.length > 0) {
        return this.sendError(res, new Error(errors.join(', ')), 400);
      }

      return this.sendSuccess(res, { valid: true }, 'Data is valid');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Verificar token
  verifyToken = this.handleAsync(async (req, res) => {
    try {
      const { token } = req.body;

      if (!token) {
        return this.sendError(res, new Error('Token is required'), 400);
      }

      const decoded = this.userService.verifyToken(token);

      return this.sendSuccess(res, { valid: true, user: decoded }, 'Token is valid');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar especialidades
  getSpecialties = this.handleAsync(async (req, res) => {
    try {
      const specialties = await this.userService.getSpecialties();
      return this.sendSuccess(res, specialties, 'Specialties retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar médicos online
  getOnlineDoctors = this.handleAsync(async (req, res) => {
    try {
      const doctors = await this.userService.getOnlineDoctors();
      return this.sendSuccess(res, doctors, 'Online doctors retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar médicos favoritos
  getFavoriteDoctors = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;
      const favorites = await this.userService.getFavoriteDoctors(userId);
      return this.sendSuccess(res, favorites, 'Favorite doctors retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Adicionar/remover médico dos favoritos
  toggleFavorite = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const userId = req.user.id;
      const result = await this.userService.toggleFavorite(userId, doctorId);
      return this.sendSuccess(res, result, 'Favorite toggled successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Dashboard do médico
  getDoctorDashboard = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'DOCTOR' && doctorId !== userId) {
        return this.sendError(res, new Error('You can only view your own dashboard'), 403);
      }

      const dashboard = await this.userService.getDoctorDashboard(doctorId);
      return this.sendSuccess(res, dashboard, 'Doctor dashboard retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Dashboard do paciente
  getPatientDashboard = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      console.log('🔍 getPatientDashboard - patientId:', patientId);
      console.log('🔍 getPatientDashboard - userId:', userId);
      console.log('🔍 getPatientDashboard - userType:', userType);

      // Verificar permissões
      if (userType === 'PATIENT' && patientId !== userId) {
        return this.sendError(res, new Error('You can only view your own dashboard'), 403);
      }

      const dashboard = await this.userService.getPatientDashboard(patientId);
      console.log('🔍 getPatientDashboard - dashboard:', dashboard);
      return this.sendSuccess(res, dashboard, 'Patient dashboard retrieved successfully');
    } catch (error) {
      console.error('❌ getPatientDashboard - error:', error);
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Estatísticas do médico
  getDoctorStats = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'DOCTOR' && doctorId !== userId) {
        return this.sendError(res, new Error('You can only view your own stats'), 403);
      }

      const stats = await this.userService.getDoctorStats(doctorId);
      return this.sendSuccess(res, stats, 'Doctor stats retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Pacientes recentes do médico
  getRecentPatients = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'DOCTOR' && doctorId !== userId) {
        return this.sendError(res, new Error('You can only view your own patients'), 403);
      }

      const patients = await this.userService.getRecentPatients(doctorId);
      return this.sendSuccess(res, patients, 'Recent patients retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Receita do médico
  getDoctorRevenue = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'DOCTOR' && doctorId !== userId) {
        return this.sendError(res, new Error('You can only view your own revenue'), 403);
      }

      const revenue = await this.userService.getDoctorRevenue(doctorId);
      return this.sendSuccess(res, revenue, 'Doctor revenue retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Médicos favoritos do paciente
  getPatientFavoriteDoctors = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'PATIENT' && patientId !== userId) {
        return this.sendError(res, new Error('You can only view your own favorites'), 403);
      }

      const doctors = await this.userService.getPatientFavoriteDoctors(patientId);
      return this.sendSuccess(res, doctors, 'Favorite doctors retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Histórico médico do paciente
  getPatientMedicalHistory = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'PATIENT' && patientId !== userId) {
        return this.sendError(res, new Error('You can only view your own medical history'), 403);
      }

      const history = await this.userService.getPatientMedicalHistory(patientId);
      return this.sendSuccess(res, history, 'Medical history retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Gastos médicos do paciente
  getPatientExpenses = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'PATIENT' && patientId !== userId) {
        return this.sendError(res, new Error('You can only view your own expenses'), 403);
      }

      const expenses = await this.userService.getPatientExpenses(patientId);
      return this.sendSuccess(res, expenses, 'Patient expenses retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = UserController;
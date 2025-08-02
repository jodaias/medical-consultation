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
}

module.exports = UserController;
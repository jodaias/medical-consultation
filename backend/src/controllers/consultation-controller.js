const ConsultationService = require('../services/consultation-service');
const BaseController = require('../interfaces/base-controller');

/**
 * ConsultationController - Controlador para operações de consultas médicas
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ConsultationController extends BaseController {
  constructor() {
    const consultationService = new ConsultationService();
    super(consultationService);
    this.consultationService = consultationService;
  }

  // Criar consulta
  create = this.handleAsync(async (req, res) => {
    try {
      const consultationData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultation = await this.consultationService.create(consultationData, userId);

      return this.sendSuccess(res, consultation, 'Consultation created successfully', 201);
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar consulta por ID
  findById = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultation = await this.consultationService.findById(id, userId, userType);

      return this.sendSuccess(res, consultation, 'Consultation found successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Listar todas as consultas com filtros
  findAll = this.handleAsync(async (req, res) => {
    try {
      const {
        patientId,
        doctorId,
        status,
        dateFrom,
        dateTo,
        page,
        limit,
        orderBy,
        order
      } = req.query;

      const filters = {
        patientId,
        doctorId,
        status,
        dateFrom,
        dateTo,
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 10,
        orderBy,
        order
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.consultationService.findAll(filters, userId, userType);

      return this.sendSuccess(res, result, 'Consultations retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Atualizar consulta
  update = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultation = await this.consultationService.update(id, updateData, userId, userType);

      return this.sendSuccess(res, consultation, 'Consultation updated successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Deletar consulta
  delete = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      await this.consultationService.delete(id, userId, userType);

      return this.sendSuccess(res, null, 'Consultation deleted successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Iniciar consulta
  startConsultation = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultation = await this.consultationService.startConsultation(id, userId, userType);

      return this.sendSuccess(res, consultation, 'Consultation started successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Finalizar consulta
  endConsultation = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultation = await this.consultationService.endConsultation(id, userId, userType);

      return this.sendSuccess(res, consultation, 'Consultation ended successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Cancelar consulta
  cancelConsultation = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultation = await this.consultationService.cancelConsultation(id, userId, userType);

      return this.sendSuccess(res, consultation, 'Consultation cancelled successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar consultas por paciente
  findByPatient = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const {
        status,
        dateFrom,
        dateTo,
        page,
        limit
      } = req.query;

      const filters = {
        status,
        dateFrom,
        dateTo,
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.consultationService.findByPatient(patientId, filters, userId, userType);

      return this.sendSuccess(res, result, 'Patient consultations retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar consultas por médico
  findByDoctor = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const {
        status,
        dateFrom,
        dateTo,
        page,
        limit
      } = req.query;

      const filters = {
        status,
        dateFrom,
        dateTo,
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.consultationService.findByDoctor(doctorId, filters, userId, userType);

      return this.sendSuccess(res, result, 'Doctor consultations retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Obter estatísticas de consultas
  getStats = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;
      const userType = req.user.userType;

      const stats = await this.consultationService.getConsultationStats(userId, userType);

      return this.sendSuccess(res, stats, 'Consultation statistics retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Obter próximas consultas
  getUpcoming = this.handleAsync(async (req, res) => {
    try {
      const { limit } = req.query;
      const userId = req.user.id;
      const userType = req.user.userType;

      const consultations = await this.consultationService.getUpcomingConsultations(
        userId,
        userType,
        parseInt(limit) || 5
      );

      return this.sendSuccess(res, consultations, 'Upcoming consultations retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Validar dados de consulta
  validate = this.handleAsync(async (req, res) => {
    try {
      const consultationData = req.body;
      const errors = await this.consultationService.validate(consultationData);

      if (errors.length > 0) {
        return this.sendError(res, new Error(errors.join(', ')), 400);
      }

      return this.sendSuccess(res, { valid: true }, 'Consultation data is valid');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = ConsultationController;
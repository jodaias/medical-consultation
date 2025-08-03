const PrescriptionService = require('../services/prescription-service');
const BaseController = require('../interfaces/base-controller');

class PrescriptionController extends BaseController {
  constructor() {
    const prescriptionService = new PrescriptionService();
    super(prescriptionService);
    this.prescriptionService = prescriptionService;
  }

  create = this.handleAsync(async (req, res) => {
    try {
      const prescriptionData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;

      const prescription = await this.prescriptionService.create(prescriptionData, userId, userType);
      return this.sendSuccess(res, prescription, 'Prescription created successfully', 201);
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findById = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const prescription = await this.prescriptionService.findById(id, userId, userType);
      return this.sendSuccess(res, prescription, 'Prescription found successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findAll = this.handleAsync(async (req, res) => {
    try {
      const filters = {
        consultationId: req.query.consultationId,
        isActive: req.query.isActive !== undefined ? req.query.isActive === 'true' : undefined,
        validUntil: req.query.validUntil,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.prescriptionService.findAll(filters, userId, userType);
      return this.sendSuccess(res, result, 'Prescriptions retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  update = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;

      const prescription = await this.prescriptionService.update(id, updateData, userId, userType);
      return this.sendSuccess(res, prescription, 'Prescription updated successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  delete = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      await this.prescriptionService.delete(id, userId, userType);
      return this.sendSuccess(res, null, 'Prescription deleted successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByConsultation = this.handleAsync(async (req, res) => {
    try {
      const { consultationId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const prescriptions = await this.prescriptionService.findByConsultation(consultationId, userId, userType);
      return this.sendSuccess(res, prescriptions, 'Prescriptions for consultation retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByDoctor = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const filters = {
        isActive: req.query.isActive !== undefined ? req.query.isActive === 'true' : undefined,
        validUntil: req.query.validUntil,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.prescriptionService.findByDoctor(doctorId, filters, userId, userType);
      return this.sendSuccess(res, result, 'Doctor prescriptions retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByPatient = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const prescriptions = await this.prescriptionService.findByPatient(patientId);
      return this.sendSuccess(res, prescriptions, 'Prescriptions retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Prescrições recentes do paciente
  getPatientRecentPrescriptions = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      // Verificar permissões
      if (userType === 'PATIENT' && patientId !== userId) {
        return this.sendError(res, new Error('You can only view your own prescriptions'), 403);
      }

      const prescriptions = await this.prescriptionService.getPatientRecentPrescriptions(patientId);
      return this.sendSuccess(res, prescriptions, 'Patient recent prescriptions retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  getStats = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;
      const userType = req.user.userType;

      const stats = await this.prescriptionService.getPrescriptionStats(userId, userType);
      return this.sendSuccess(res, stats, 'Prescription statistics retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  deactivateExpired = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;
      const userType = req.user.userType;

      const count = await this.prescriptionService.deactivateExpiredPrescriptions(userId, userType);
      return this.sendSuccess(res, { deactivatedCount: count }, 'Expired prescriptions deactivated successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  validate = this.handleAsync(async (req, res) => {
    try {
      const prescriptionData = req.body;
      const errors = await this.prescriptionService.validate(prescriptionData);

      if (errors.length > 0) {
        return this.sendError(res, new Error(errors.join(', ')), 400);
      }

      return this.sendSuccess(res, { valid: true }, 'Prescription data is valid');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = PrescriptionController;
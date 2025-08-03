const express = require('express');
const ConsultationController = require('../controllers/consultation-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const consultationController = new ConsultationController();

/**
 * Rotas protegidas (requerem autenticação)
 */

// POST /api/consultations - Criar consulta
router.post('/', authenticateToken, apiRateLimiter, consultationController.create);

// GET /api/consultations - Listar todas as consultas
router.get('/', authenticateToken, consultationController.findAll);

// GET /api/consultations/:id - Buscar consulta por ID
router.get('/:id', authenticateToken, consultationController.findById);

// PUT /api/consultations/:id - Atualizar consulta
router.put('/:id', authenticateToken, consultationController.update);

// DELETE /api/consultations/:id - Deletar consulta
router.delete('/:id', authenticateToken, consultationController.delete);

// POST /api/consultations/:id/start - Iniciar consulta
router.post('/:id/start', authenticateToken, consultationController.startConsultation);

// POST /api/consultations/:id/end - Finalizar consulta
router.post('/:id/end', authenticateToken, consultationController.endConsultation);

// POST /api/consultations/:id/cancel - Cancelar consulta
router.put('/:id/cancel', authenticateToken, consultationController.cancelConsultation);

// GET /api/consultations/patient/:patientId - Buscar consultas por paciente
router.get('/patient/:patientId', authenticateToken, consultationController.findByPatient);

// GET /api/consultations/doctors/available - Buscar médicos disponíveis
router.get('/doctors/available', authenticateToken, consultationController.getAvailableDoctors);

// GET /api/consultations/doctors/:doctorId - Buscar consultas por médico
router.get('/doctors/:doctorId', authenticateToken, consultationController.findByDoctor);

// GET /api/consultations/stats - Obter estatísticas de consultas
router.get('/stats', authenticateToken, consultationController.getStats);

// GET /api/consultations/upcoming - Obter próximas consultas
router.get('/upcoming', authenticateToken, consultationController.getUpcoming);

// POST /api/consultations/validate - Validar dados de consulta
router.post('/validate', authenticateToken, consultationController.validate);

// POST /api/consultations/:id/rate - Avaliar consulta
router.post('/:id/rate', authenticateToken, consultationController.rateConsultation);

// POST /api/consultations/:id/no-show - Marcar como no-show
router.post('/:id/no-show', authenticateToken, consultationController.markAsNoShow);

// PUT /api/consultations/:id/reschedule - Reagendar consulta
router.put('/:id/reschedule', authenticateToken, consultationController.rescheduleConsultation);

// GET /api/consultations/doctors/:doctorId/upcoming - Consultas próximas do médico
router.get('/doctors/:doctorId/upcoming', authenticateToken, consultationController.getDoctorUpcomingConsultations);

// GET /api/consultations/patients/:patientId/recent - Consultas recentes do paciente
router.get('/patients/:patientId/recent', authenticateToken, consultationController.getPatientRecentConsultations);

// GET /api/consultations/patients/:patientId/upcoming - Próximas consultas do paciente
router.get('/patients/:patientId/upcoming', authenticateToken, consultationController.getPatientUpcomingConsultations);

module.exports = router;
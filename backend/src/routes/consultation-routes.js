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
router.post('/:id/cancel', authenticateToken, consultationController.cancelConsultation);

// GET /api/consultations/patient/:patientId - Buscar consultas por paciente
router.get('/patient/:patientId', authenticateToken, consultationController.findByPatient);

// GET /api/consultations/doctor/:doctorId - Buscar consultas por médico
router.get('/doctor/:doctorId', authenticateToken, consultationController.findByDoctor);

// GET /api/consultations/stats - Obter estatísticas de consultas
router.get('/stats', authenticateToken, consultationController.getStats);

// GET /api/consultations/upcoming - Obter próximas consultas
router.get('/upcoming', authenticateToken, consultationController.getUpcoming);

// POST /api/consultations/validate - Validar dados de consulta
router.post('/validate', authenticateToken, consultationController.validate);

module.exports = router;
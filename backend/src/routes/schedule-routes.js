const express = require('express');
const ScheduleController = require('../controllers/schedule-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const scheduleController = new ScheduleController();

/**
 * Rotas protegidas (requerem autenticação)
 */

// POST /api/schedules - Criar agendamento
router.post('/', authenticateToken, apiRateLimiter, scheduleController.create);

// GET /api/schedules - Listar todos os agendamentos
router.get('/', authenticateToken, scheduleController.findAll);

// GET /api/schedules/:id - Buscar agendamento por ID
router.get('/:id', authenticateToken, scheduleController.findById);

// PUT /api/schedules/:id - Atualizar agendamento
router.put('/:id', authenticateToken, scheduleController.update);

// DELETE /api/schedules/:id - Deletar agendamento
router.delete('/:id', authenticateToken, scheduleController.delete);

// GET /api/schedules/doctor/:doctorId - Buscar agendamentos por médico
router.get('/doctor/:doctorId', authenticateToken, scheduleController.findByDoctor);

// GET /api/schedules/doctor/:doctorId/available-slots - Buscar slots disponíveis
router.get('/doctor/:doctorId/available-slots', authenticateToken, scheduleController.findAvailableSlots);

// POST /api/schedules/doctor/:doctorId/check-availability - Verificar disponibilidade
router.post('/doctor/:doctorId/check-availability', authenticateToken, scheduleController.checkAvailability);

// GET /api/schedules/stats - Obter estatísticas de agendamento
router.get('/stats', authenticateToken, scheduleController.getStats);

// GET /api/schedules/doctor/:doctorId/weekly - Obter agenda semanal
router.get('/doctor/:doctorId/weekly', authenticateToken, scheduleController.getWeeklySchedule);

// PUT /api/schedules/doctor/:doctorId/bulk - Atualizar agendamentos em lote
router.put('/doctor/:doctorId/bulk', authenticateToken, scheduleController.bulkUpdate);

// POST /api/schedules/validate - Validar dados de agendamento
router.post('/validate', authenticateToken, scheduleController.validate);

module.exports = router;
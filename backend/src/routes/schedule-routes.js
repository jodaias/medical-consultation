const express = require('express');
const ScheduleController = require('../controllers/schedule-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const scheduleController = new ScheduleController();

/**
 * @swagger
 * components:
 *   schemas:
 *     Schedule:
 *       type: object
 *       required:
 *         - doctorId
 *         - date
 *         - startTime
 *         - endTime
 *       properties:
 *         id:
 *           type: string
 *           description: ID único do agendamento
 *         doctorId:
 *           type: string
 *           description: ID do médico
 *         date:
 *           type: string
 *           format: date
 *           description: Data do agendamento (YYYY-MM-DD)
 *         startTime:
 *           type: string
 *           description: Hora de início (HH:MM)
 *         endTime:
 *           type: string
 *           description: Hora de término (HH:MM)
 *         isAvailable:
 *           type: boolean
 *           description: Indica se o horário está disponível
 *         isConfirmed:
 *           type: boolean
 *           description: Indica se o horário foi confirmado pelo médico
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação do agendamento
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização do agendamento
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         doctorId: "5f8d0d55b54764421b7156c6"
 *         date: "2023-01-15"
 *         startTime: "14:00"
 *         endTime: "14:30"
 *         isAvailable: true
 *         isConfirmed: true
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-01T00:00:00.000Z"
 */

/**
 * @swagger
 * tags:
 *   name: Agendamentos
 *   description: API para gerenciamento de agendamentos
 */

/**
 * @swagger
 * /api/schedules:
 *   post:
 *     summary: Cria um novo agendamento
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - doctorId
 *               - date
 *               - startTime
 *               - endTime
 *             properties:
 *               doctorId:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               startTime:
 *                 type: string
 *               endTime:
 *                 type: string
 *               isAvailable:
 *                 type: boolean
 *               isConfirmed:
 *                 type: boolean
 *     responses:
 *       201:
 *         description: Agendamento criado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Schedule'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/', authenticateToken, apiRateLimiter, scheduleController.create);

/**
 * @swagger
 * /api/schedules/available-slots:
 *   get:
 *     summary: Busca horários disponíveis de um médico
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *       - in: query
 *         name: date
 *         schema:
 *           type: string
 *           format: date
 *         required: true
 *         description: Data desejada (YYYY-MM-DD ou ISO)
 *     responses:
 *       200:
 *         description: Lista de horários disponíveis
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Schedule'
 *       400:
 *         description: Parâmetros obrigatórios ausentes ou inválidos
 *       401:
 *         description: Não autorizado
 */
router.get('/available-slots', authenticateToken, scheduleController.findAvailableSlots);

/**
 * @swagger
 * /api/schedules:
 *   get:
 *     summary: Lista todos os agendamentos
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: available
 *         schema:
 *           type: boolean
 *         description: Filtrar por disponibilidade
 *       - in: query
 *         name: confirmed
 *         schema:
 *           type: boolean
 *         description: Filtrar por confirmação
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Data inicial para filtro
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Data final para filtro
 *     responses:
 *       200:
 *         description: Lista de agendamentos
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Schedule'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, scheduleController.findAll);


/**
 * @swagger
 * /api/schedules/check-availability:
 *   post:
 *     summary: Verifica disponibilidade de horário
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - doctorId
 *               - date
 *               - startTime
 *               - endTime
 *             properties:
 *               doctorId:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               startTime:
 *                 type: string
 *               endTime:
 *                 type: string
 *     responses:
 *       200:
 *         description: Resultado da verificação
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 isAvailable:
 *                   type: boolean
 *                 message:
 *                   type: string
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/check-availability', authenticateToken, scheduleController.checkAvailability);

/**
 * @swagger
 * /api/schedules/stats:
 *   get:
 *     summary: Obtém estatísticas de agendamentos
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Estatísticas de agendamentos
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     totalSchedules:
 *                       type: integer
 *                     availableSchedules:
 *                       type: integer
 *                     confirmedSchedules:
 *                       type: integer
 *                     schedulesPerDay:
 *                       type: object
 *       401:
 *         description: Não autorizado
 */
router.get('/stats', authenticateToken, scheduleController.getStats);

/**
 * @swagger
 * /api/schedules/validate:
 *   post:
 *     summary: Validar dados de agendamento
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               doctorId:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date
 *               startTime:
 *                 type: string
 *               endTime:
 *                 type: string
 *     responses:
 *       200:
 *         description: Dados validados
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/validate', authenticateToken, scheduleController.validate);

/**
 * @swagger
 * /api/schedules/{id}:
 *   get:
 *     summary: Busca agendamento por ID
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do agendamento
 *     responses:
 *       200:
 *         description: Dados do agendamento
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Schedule'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Agendamento não encontrado
 */
router.get('/:id', authenticateToken, scheduleController.findById);

/**
 * @swagger
 * /api/schedules/{id}:
 *   put:
 *     summary: Atualiza agendamento
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do agendamento
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               date:
 *                 type: string
 *                 format: date
 *               startTime:
 *                 type: string
 *               endTime:
 *                 type: string
 *               isAvailable:
 *                 type: boolean
 *               isConfirmed:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: Agendamento atualizado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Schedule'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Agendamento não encontrado
 */
router.put('/:id', authenticateToken, scheduleController.update);

/**
 * @swagger
 * /api/schedules/{id}:
 *   delete:
 *     summary: Deleta agendamento
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do agendamento
 *     responses:
 *       200:
 *         description: Agendamento deletado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Agendamento não encontrado
 */
router.delete('/:id', authenticateToken, scheduleController.delete);

/**
 * @swagger
 * /api/schedules/doctor/{doctorId}:
 *   get:
 *     summary: Busca agendamentos por médico
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *       - in: query
 *         name: available
 *         schema:
 *           type: boolean
 *         description: Filtrar por disponibilidade
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Data inicial para filtro
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Data final para filtro
 *     responses:
 *       200:
 *         description: Lista de agendamentos do médico
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Schedule'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctor/:doctorId', authenticateToken, scheduleController.findByDoctor);

/**
 * @swagger
 * /api/schedules/doctors/{doctorId}/weekly:
 *   get:
 *     summary: Obtém agenda semanal do médico
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Data inicial da semana
 *     responses:
 *       200:
 *         description: Agenda semanal do médico
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     doctor:
 *                       type: object
 *                     weeklySchedule:
 *                       type: object
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId/weekly', authenticateToken, scheduleController.getWeeklySchedule);

/**
 * @swagger
 * /api/schedules/doctors/:doctorId/bulk:
 *   put:
 *     summary: Atualiza múltiplos agendamentos
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - schedules
 *             properties:
 *               schedules:
 *                 type: array
 *                 items:
 *                   type: object
 *                   required:
 *                     - id
 *                   properties:
 *                     id:
 *                       type: string
 *                     isAvailable:
 *                       type: boolean
 *                     isConfirmed:
 *                       type: boolean
 *     responses:
 *       200:
 *         description: Agendamentos atualizados
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 count:
 *                   type: integer
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.put('/doctors/:doctorId/bulk', authenticateToken, scheduleController.bulkUpdate);

/**
 * @swagger
 * /api/schedules/{id}/confirm:
 *   put:
 *     summary: Confirma agendamento
 *     tags: [Agendamentos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do agendamento
 *     responses:
 *       200:
 *         description: Agendamento confirmado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Schedule'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Agendamento não encontrado
 */
router.put('/:id/confirm', authenticateToken, scheduleController.confirmSchedule);

module.exports = router;
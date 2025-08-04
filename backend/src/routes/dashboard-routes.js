const express = require('express');
const DashboardController = require('../controllers/dashboard-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const dashboardController = new DashboardController();

/**
 * @swagger
 * tags:
 *   name: Dashboard
 *   description: API para obtenção de dados do dashboard
 */

/**
 * @swagger
 * /api/dashboard/stats:
 *   get:
 *     summary: Obtém estatísticas gerais para o dashboard
 *     tags: [Dashboard]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: ID do usuário (médico ou paciente)
 *       - in: query
 *         name: role
 *         schema:
 *           type: string
 *           enum: [doctor, patient, admin]
 *         description: Função do usuário
 *       - in: query
 *         name: period
 *         schema:
 *           type: string
 *           enum: [day, week, month, year]
 *         description: Período para as estatísticas
 *     responses:
 *       200:
 *         description: Estatísticas do dashboard
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
 *                     consultations:
 *                       type: object
 *                       properties:
 *                         total:
 *                           type: integer
 *                         completed:
 *                           type: integer
 *                         scheduled:
 *                           type: integer
 *                         canceled:
 *                           type: integer
 *                     ratings:
 *                       type: object
 *                       properties:
 *                         average:
 *                           type: number
 *                           format: float
 *                         count:
 *                           type: integer
 *                     revenue:
 *                       type: object
 *                       properties:
 *                         total:
 *                           type: number
 *                           format: float
 *                         thisMonth:
 *                           type: number
 *                           format: float
 *                         lastMonth:
 *                           type: number
 *                           format: float
 *                     patients:
 *                       type: object
 *                       properties:
 *                         total:
 *                           type: integer
 *                         new:
 *                           type: integer
 *                     messages:
 *                       type: object
 *                       properties:
 *                         total:
 *                           type: integer
 *                         unread:
 *                           type: integer
 *       401:
 *         description: Não autorizado
 */
router.get('/stats', authenticateToken, apiRateLimiter, dashboardController.getStats);

/**
 * @swagger
 * /api/dashboard/alerts:
 *   get:
 *     summary: Obtém alertas e insights para o dashboard
 *     tags: [Dashboard]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: ID do usuário (médico ou paciente)
 *       - in: query
 *         name: role
 *         schema:
 *           type: string
 *           enum: [doctor, patient, admin]
 *         description: Função do usuário
 *     responses:
 *       200:
 *         description: Alertas e insights do dashboard
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
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: string
 *                       type:
 *                         type: string
 *                         enum: [alert, insight, notification]
 *                       priority:
 *                         type: string
 *                         enum: [low, medium, high]
 *                       message:
 *                         type: string
 *                       data:
 *                         type: object
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *       401:
 *         description: Não autorizado
 */
router.get('/alerts', authenticateToken, apiRateLimiter, dashboardController.getAlerts);

/**
 * @swagger
 * /api/dashboard/notifications:
 *   get:
 *     summary: Obtém notificações para o usuário
 *     tags: [Dashboard]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *       - in: query
 *         name: read
 *         schema:
 *           type: boolean
 *         description: Filtrar por status de leitura
 *     responses:
 *       200:
 *         description: Notificações do usuário
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
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: string
 *                       userId:
 *                         type: string
 *                       title:
 *                         type: string
 *                       message:
 *                         type: string
 *                       type:
 *                         type: string
 *                         enum: [system, consultation, message, prescription]
 *                       read:
 *                         type: boolean
 *                       data:
 *                         type: object
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *       401:
 *         description: Não autorizado
 */
router.get('/notifications', authenticateToken, apiRateLimiter, dashboardController.getNotifications);

/**
 * @swagger
 * /api/dashboard/notifications/{id}/read:
 *   put:
 *     summary: Marca notificação como lida
 *     tags: [Dashboard]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da notificação
 *     responses:
 *       200:
 *         description: Notificação marcada como lida
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
 *         description: Notificação não encontrada
 */
router.put('/notifications/:id/read', authenticateToken, apiRateLimiter, dashboardController.markNotificationAsRead);

/**
 * @swagger
 * /api/dashboard/notifications/read-all:
 *   put:
 *     summary: Marca todas as notificações do usuário como lidas
 *     tags: [Dashboard]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     responses:
 *       200:
 *         description: Todas as notificações marcadas como lidas
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
 *       401:
 *         description: Não autorizado
 */
router.put('/notifications/read-all', authenticateToken, apiRateLimiter, dashboardController.markAllNotificationsAsRead);

module.exports = router;
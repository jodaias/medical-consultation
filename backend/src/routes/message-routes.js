const express = require('express');
const MessageController = require('../controllers/message-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const messageController = new MessageController();

/**
 * @swagger
 * components:
 *   schemas:
 *     Message:
 *       type: object
 *       required:
 *         - senderId
 *         - receiverId
 *         - consultationId
 *         - content
 *       properties:
 *         id:
 *           type: string
 *           description: ID único da mensagem
 *         senderId:
 *           type: string
 *           description: ID do remetente
 *         receiverId:
 *           type: string
 *           description: ID do destinatário
 *         consultationId:
 *           type: string
 *           description: ID da consulta relacionada
 *         content:
 *           type: string
 *           description: Conteúdo da mensagem
 *         attachments:
 *           type: array
 *           items:
 *             type: string
 *           description: Lista de anexos
 *         isRead:
 *           type: boolean
 *           description: Indica se a mensagem foi lida
 *         readAt:
 *           type: string
 *           format: date-time
 *           description: Data e hora em que a mensagem foi lida
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação da mensagem
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização da mensagem
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         senderId: "5f8d0d55b54764421b7156c6"
 *         receiverId: "5f8d0d55b54764421b7156c7"
 *         consultationId: "5f8d0d55b54764421b7156c8"
 *         content: "Olá, como está se sentindo hoje?"
 *         attachments: []
 *         isRead: false
 *         readAt: null
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-01T00:00:00.000Z"
 */

/**
 * @swagger
 * tags:
 *   name: Mensagens
 *   description: API para gerenciamento de mensagens entre médicos e pacientes
 */

/**
 * @swagger
 * /api/messages:
 *   post:
 *     summary: Envia uma nova mensagem
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - senderId
 *               - receiverId
 *               - consultationId
 *               - content
 *             properties:
 *               senderId:
 *                 type: string
 *               receiverId:
 *                 type: string
 *               consultationId:
 *                 type: string
 *               content:
 *                 type: string
 *               attachments:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       201:
 *         description: Mensagem enviada com sucesso
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
 *                   $ref: '#/components/schemas/Message'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/', authenticateToken, apiRateLimiter, messageController.create);

/**
 * @swagger
 * /api/messages:
 *   get:
 *     summary: Lista todas as mensagens
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de mensagens
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
 *                     $ref: '#/components/schemas/Message'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, messageController.findAll);

/**
 * @swagger
 * /api/messages/{id}:
 *   get:
 *     summary: Busca mensagem por ID
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da mensagem
 *     responses:
 *       200:
 *         description: Dados da mensagem
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Message'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Mensagem não encontrada
 */
router.get('/:id', authenticateToken, messageController.findById);

/**
 * @swagger
 * /api/messages/{id}:
 *   put:
 *     summary: Atualiza mensagem
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da mensagem
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               content:
 *                 type: string
 *               attachments:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       200:
 *         description: Mensagem atualizada
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
 *                   $ref: '#/components/schemas/Message'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Mensagem não encontrada
 */
router.put('/:id', authenticateToken, messageController.update);

/**
 * @swagger
 * /api/messages/{id}:
 *   delete:
 *     summary: Deleta mensagem
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da mensagem
 *     responses:
 *       200:
 *         description: Mensagem deletada
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
 *         description: Mensagem não encontrada
 */
router.delete('/:id', authenticateToken, messageController.delete);

/**
 * @swagger
 * /api/messages/consultation/{consultationId}:
 *   get:
 *     summary: Busca mensagens por consulta
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: consultationId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     responses:
 *       200:
 *         description: Lista de mensagens da consulta
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
 *                     $ref: '#/components/schemas/Message'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.get('/consultation/:consultationId', authenticateToken, messageController.findByConsultation);

/**
 * @swagger
 * /api/messages/{id}/read:
 *   put:
 *     summary: Marca mensagem como lida
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da mensagem
 *     responses:
 *       200:
 *         description: Mensagem marcada como lida
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
 *                   $ref: '#/components/schemas/Message'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Mensagem não encontrada
 */
router.put('/:id/read', authenticateToken, messageController.markAsRead);

/**
 * @swagger
 * /api/messages/consultation/{consultationId}/read-all:
 *   put:
 *     summary: Marca todas as mensagens de uma consulta como lidas
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: consultationId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *             properties:
 *               userId:
 *                 type: string
 *                 description: ID do usuário que está marcando as mensagens como lidas
 *     responses:
 *       200:
 *         description: Mensagens marcadas como lidas
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
 *       404:
 *         description: Consulta não encontrada
 */
router.put('/consultation/:consultationId/read-all', authenticateToken, messageController.markAllAsRead);

/**
 * @swagger
 * /api/messages/unread-count/{userId}:
 *   get:
 *     summary: Obtém contagem de mensagens não lidas
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     responses:
 *       200:
 *         description: Contagem de mensagens não lidas
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 count:
 *                   type: integer
 *       401:
 *         description: Não autorizado
 */
router.get('/unread-count/:userId', authenticateToken, messageController.getUnreadCount);

/**
 * @swagger
 * /api/messages/stats:
 *   get:
 *     summary: Obtém estatísticas de mensagens
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Estatísticas de mensagens
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
 *                     totalMessages:
 *                       type: integer
 *                     totalUnread:
 *                       type: integer
 *                     messagesPerDay:
 *                       type: object
 *       401:
 *         description: Não autorizado
 */
router.get('/stats', authenticateToken, messageController.getStats);

/**
 * @swagger
 * /api/messages/cleanup:
 *   delete:
 *     summary: Deleta mensagens antigas
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: days
 *         description: 'Número de dias para manter mensagens (padrão: 30)'
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Mensagens antigas deletadas
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
router.delete('/cleanup', authenticateToken, messageController.deleteOldMessages);

/**
 * @swagger
 * /api/messages/validate:
 *   post:
 *     summary: Validar dados de mensagem
 *     tags: [Mensagens]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               senderId:
 *                 type: string
 *               receiverId:
 *                 type: string
 *               consultationId:
 *                 type: string
 *               content:
 *                 type: string
 *     responses:
 *       200:
 *         description: Dados validados
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/validate', authenticateToken, messageController.validate);

module.exports = router;
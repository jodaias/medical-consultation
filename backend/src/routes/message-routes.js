const express = require('express');
const MessageController = require('../controllers/message-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const messageController = new MessageController();

/**
 * Rotas protegidas (requerem autenticação)
 */

// POST /api/messages - Enviar mensagem
router.post('/', authenticateToken, apiRateLimiter, messageController.create);

// GET /api/messages - Listar todas as mensagens
router.get('/', authenticateToken, messageController.findAll);

// GET /api/messages/:id - Buscar mensagem por ID
router.get('/:id', authenticateToken, messageController.findById);

// PUT /api/messages/:id - Atualizar mensagem
router.put('/:id', authenticateToken, messageController.update);

// DELETE /api/messages/:id - Deletar mensagem
router.delete('/:id', authenticateToken, messageController.delete);

// GET /api/messages/consultation/:consultationId - Buscar mensagens por consulta
router.get('/consultation/:consultationId', authenticateToken, messageController.findByConsultation);

// POST /api/messages/mark-read - Marcar mensagens como lidas
router.post('/mark-read', authenticateToken, messageController.markAsRead);

// POST /api/messages/consultation/:consultationId/mark-all-read - Marcar todas como lidas
router.post('/consultation/:consultationId/mark-all-read', authenticateToken, messageController.markAllAsRead);

// GET /api/messages/unread/count - Obter contagem de não lidas
router.get('/unread/count', authenticateToken, messageController.getUnreadCount);

// GET /api/messages/stats - Obter estatísticas de mensagens
router.get('/stats', authenticateToken, messageController.getStats);

// DELETE /api/messages/old - Deletar mensagens antigas (apenas admin)
router.delete('/old', authenticateToken, messageController.deleteOldMessages);

// POST /api/messages/validate - Validar dados de mensagem
router.post('/validate', authenticateToken, messageController.validate);

module.exports = router;
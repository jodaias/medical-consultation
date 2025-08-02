const MessageService = require('../services/message-service');
const BaseController = require('../interfaces/base-controller');

/**
 * MessageController - Controlador para operações de mensagens
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class MessageController extends BaseController {
  constructor() {
    const messageService = new MessageService();
    super(messageService);
    this.messageService = messageService;
  }

  // Criar mensagem
  create = this.handleAsync(async (req, res) => {
    try {
      const messageData = req.body;
      const userId = req.user.id;

      const message = await this.messageService.create(messageData, userId);

      return this.sendSuccess(res, message, 'Message sent successfully', 201);
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar mensagem por ID
  findById = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;

      const message = await this.messageService.findById(id, userId);

      return this.sendSuccess(res, message, 'Message found successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Listar todas as mensagens com filtros
  findAll = this.handleAsync(async (req, res) => {
    try {
      const {
        consultationId,
        senderId,
        receiverId,
        messageType,
        isRead,
        page,
        limit,
        orderBy,
        order
      } = req.query;

      const filters = {
        consultationId,
        senderId,
        receiverId,
        messageType,
        isRead,
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 50,
        orderBy,
        order
      };

      const userId = req.user.id;

      const result = await this.messageService.findAll(filters, userId);

      return this.sendSuccess(res, result, 'Messages retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Atualizar mensagem
  update = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const userId = req.user.id;

      const message = await this.messageService.update(id, updateData, userId);

      return this.sendSuccess(res, message, 'Message updated successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Deletar mensagem
  delete = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;

      await this.messageService.delete(id, userId);

      return this.sendSuccess(res, null, 'Message deleted successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Buscar mensagens por consulta
  findByConsultation = this.handleAsync(async (req, res) => {
    try {
      const { consultationId } = req.params;
      const {
        page,
        limit,
        orderBy,
        order
      } = req.query;

      const filters = {
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 50,
        orderBy,
        order
      };

      const userId = req.user.id;

      const result = await this.messageService.findByConsultation(consultationId, filters, userId);

      return this.sendSuccess(res, result, 'Consultation messages retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Marcar mensagens como lidas
  markAsRead = this.handleAsync(async (req, res) => {
    try {
      const { messageIds } = req.body;
      const userId = req.user.id;

      if (!Array.isArray(messageIds) || messageIds.length === 0) {
        return this.sendError(res, new Error('Message IDs array is required'), 400);
      }

      const result = await this.messageService.markAsRead(messageIds, userId);

      return this.sendSuccess(res, { count: result.count }, 'Messages marked as read successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Marcar todas as mensagens de uma consulta como lidas
  markAllAsRead = this.handleAsync(async (req, res) => {
    try {
      const { consultationId } = req.params;
      const userId = req.user.id;

      const result = await this.messageService.markAllAsRead(consultationId, userId);

      return this.sendSuccess(res, { count: result.count }, 'All messages marked as read successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Obter contagem de mensagens não lidas
  getUnreadCount = this.handleAsync(async (req, res) => {
    try {
      const { consultationId } = req.query;
      const userId = req.user.id;

      const count = await this.messageService.getUnreadCount(userId, consultationId);

      return this.sendSuccess(res, { unreadCount: count }, 'Unread count retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Obter estatísticas de mensagens
  getStats = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;

      const stats = await this.messageService.getMessageStats(userId);

      return this.sendSuccess(res, stats, 'Message statistics retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Deletar mensagens antigas (apenas admin)
  deleteOldMessages = this.handleAsync(async (req, res) => {
    try {
      const { daysOld } = req.query;
      const userId = req.user.id;

      const result = await this.messageService.deleteOldMessages(
        parseInt(daysOld) || 365,
        userId
      );

      return this.sendSuccess(res, { deletedCount: result.count }, 'Old messages deleted successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Validar dados de mensagem
  validate = this.handleAsync(async (req, res) => {
    try {
      const messageData = req.body;
      const errors = await this.messageService.validate(messageData);

      if (errors.length > 0) {
        return this.sendError(res, new Error(errors.join(', ')), 400);
      }

      return this.sendSuccess(res, { valid: true }, 'Message data is valid');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = MessageController;
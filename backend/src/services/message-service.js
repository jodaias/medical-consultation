const MessageRepository = require('../repositories/message-repository');
const ConsultationRepository = require('../repositories/consultation-repository');
const { CreateMessageDTO, UpdateMessageDTO, MessageResponseDTO } = require('../dto/message-dto');
const { ValidationException, NotFoundException, ForbiddenException } = require('../exceptions/app-exception');

const UserRepository = require('../repositories/user-repository');
const { sendFcmNotification } = require('../utils/fcm');

/**
 * MessageService - Lógica de negócio para mensagens
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class MessageService {
  constructor() {
    this.repository = new MessageRepository();
    this.consultationRepository = new ConsultationRepository();
    this.userRepository = new UserRepository();
  }

  async create(messageData, userId) {
    // Validação com DTO
    const createMessageDTO = new CreateMessageDTO(messageData);
    const validationErrors = createMessageDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se consulta existe e usuário tem permissão
    const consultation = await this.consultationRepository.findById(messageData.consultationId);

    if (consultation.patientId !== userId && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only send messages to consultations you are part of');
    }

    // Verificar se consulta está ativa
    if (consultation.status === 'CANCELLED') {
      throw new ValidationException('Cannot send messages to cancelled consultations');
    }

    // Determinar receiver baseado no sender
    const receiverId = consultation.patientId === userId ? consultation.doctorId : consultation.patientId;

    // Preparar dados para criação
    const messageEntity = createMessageDTO.toEntity();
    messageEntity.senderId = userId;
    messageEntity.receiverId = receiverId;

    // Criar mensagem
    const message = await this.repository.create(messageEntity);

    // Enviar notificação push FCM para o destinatário, se houver token
    try {
      const receiver = await this.userRepository.findById(receiverId);
      if (receiver.fcmToken) {
        await sendFcmNotification(
          receiver.fcmToken,
          {
            title: 'Nova mensagem',
            body: `${consultation.patientId === userId ? 'Paciente' : 'Médico'} ${receiver.name} enviou uma nova mensagem.`
          },
          {
            type: 'new_message',
            consultationId: consultation.id,
            senderId: userId
          }
        );
      }
    } catch (err) {
      // Logar erro, mas não impedir fluxo principal
      console.error('Erro ao enviar notificação FCM:', err.message);
    }

    return MessageResponseDTO.fromEntity(message);
  }

  async findById(id, userId) {
    const message = await this.repository.findById(id);

    // Verificar permissões
    if (message.senderId !== userId && message.receiverId !== userId) {
      throw new ForbiddenException('You can only view messages you sent or received');
    }

    return MessageResponseDTO.fromEntity(message);
  }

  async findAll(filters, userId) {
    // Aplicar filtros baseados no usuário
    filters.OR = [
      { senderId: userId },
      { receiverId: userId }
    ];

    const result = await this.repository.findAll(filters);
    return {
      messages: MessageResponseDTO.fromEntities(result.messages),
      pagination: result.pagination
    };
  }

  async update(id, messageData, userId) {
    // Validação com DTO
    const updateMessageDTO = new UpdateMessageDTO(messageData);
    const validationErrors = updateMessageDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se mensagem existe e usuário tem permissão
    const existingMessage = await this.repository.findById(id);

    if (existingMessage.senderId !== userId) {
      throw new ForbiddenException('You can only update messages you sent');
    }

    // Verificar se mensagem pode ser atualizada (apenas conteúdo)
    if (messageData.content && existingMessage.messageType !== 'TEXT') {
      throw new ValidationException('Only text messages can be updated');
    }

    // Preparar dados para atualização
    const messageEntity = updateMessageDTO.toEntity();

    // Atualizar mensagem
    const message = await this.repository.update(id, messageEntity);
    return MessageResponseDTO.fromEntity(message);
  }

  async delete(id, userId) {
    // Verificar se mensagem existe e usuário tem permissão
    const message = await this.repository.findById(id);

    if (message.senderId !== userId) {
      throw new ForbiddenException('You can only delete messages you sent');
    }

    return await this.repository.delete(id);
  }

  async findByConsultation(consultationId, filters, userId) {
    // Verificar se usuário tem permissão para acessar a consulta
    const consultation = await this.consultationRepository.findById(consultationId);

    if (consultation.patientId !== userId && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only view messages from consultations you are part of');
    }

    const result = await this.repository.findByConsultation(consultationId, filters);
    return {
      messages: MessageResponseDTO.fromEntities(result.messages),
      pagination: result.pagination
    };
  }

  async markAsRead(messageIds, userId) {
    // Verificar se usuário tem permissão para marcar as mensagens
    for (const messageId of messageIds) {
      const message = await this.repository.findById(messageId);
      if (message.receiverId !== userId) {
        throw new ForbiddenException('You can only mark messages you received as read');
      }
    }

    return await this.repository.markAsRead(messageIds, userId);
  }

  async markAllAsRead(consultationId, userId) {
    // Verificar se usuário tem permissão para a consulta
    const consultation = await this.consultationRepository.findById(consultationId);

    if (consultation.patientId !== userId && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only mark messages from consultations you are part of as read');
    }

    return await this.repository.markAllAsRead(consultationId, userId);
  }

  async getUnreadCount(userId, consultationId = null) {
    return await this.repository.getUnreadCount(userId, consultationId);
  }

  async getMessageStats(userId) {
    return await this.repository.getMessageStats(userId);
  }

  async deleteOldMessages(daysOld = 365, userId = null) {
    // Apenas administradores podem deletar mensagens antigas
    if (userId) {
      const user = await this.repository.findById(userId);
      if (user.userType !== 'ADMIN') {
        throw new ForbiddenException('Only administrators can delete old messages');
      }
    }

    return await this.repository.deleteOldMessages(daysOld);
  }

  async validate(data) {
    const createMessageDTO = new CreateMessageDTO(data);
    return createMessageDTO.validate();
  }
}

module.exports = MessageService;
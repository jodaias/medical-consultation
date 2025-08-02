/**
 * DTOs para transferência de dados de mensagens
 * Seguindo o princípio de responsabilidade única (SRP)
 */

class CreateMessageDTO {
  constructor(data) {
    this.content = data.content;
    this.senderId = data.senderId;
    this.receiverId = data.receiverId;
    this.consultationId = data.consultationId;
    this.messageType = data.messageType || 'TEXT';
    this.attachmentUrl = data.attachmentUrl;
    this.attachmentName = data.attachmentName;
  }

  validate() {
    const errors = [];

    // Validação de conteúdo
    if (!this.content && !this.attachmentUrl) {
      errors.push('Message content or attachment is required');
    }

    if (this.content && this.content.length > 1000) {
      errors.push('Message content cannot exceed 1000 characters');
    }

    // Validação de IDs
    if (!this.senderId || typeof this.senderId !== 'string') {
      errors.push('Valid sender ID is required');
    }

    if (!this.receiverId || typeof this.receiverId !== 'string') {
      errors.push('Valid receiver ID is required');
    }

    if (this.senderId === this.receiverId) {
      errors.push('Sender and receiver cannot be the same');
    }

    // Validação de tipo de mensagem
    if (this.messageType && !['TEXT', 'IMAGE', 'DOCUMENT', 'AUDIO', 'VIDEO'].includes(this.messageType)) {
      errors.push('Invalid message type');
    }

    // Validação de anexo
    if (this.attachmentUrl && this.attachmentUrl.length > 500) {
      errors.push('Attachment URL is too long');
    }

    if (this.attachmentName && this.attachmentName.length > 100) {
      errors.push('Attachment name is too long');
    }

    return errors;
  }

  toEntity() {
    return {
      content: this.content?.trim(),
      senderId: this.senderId,
      receiverId: this.receiverId,
      consultationId: this.consultationId,
      messageType: this.messageType || 'TEXT',
      attachmentUrl: this.attachmentUrl,
      attachmentName: this.attachmentName
    };
  }
}

class UpdateMessageDTO {
  constructor(data) {
    this.content = data.content;
    this.isRead = data.isRead;
  }

  validate() {
    const errors = [];

    if (this.content && this.content.length > 1000) {
      errors.push('Message content cannot exceed 1000 characters');
    }

    if (this.isRead !== undefined && typeof this.isRead !== 'boolean') {
      errors.push('isRead must be a boolean');
    }

    return errors;
  }

  toEntity() {
    const entity = {};

    if (this.content !== undefined) entity.content = this.content?.trim();
    if (this.isRead !== undefined) entity.isRead = this.isRead;

    return entity;
  }
}

class MessageResponseDTO {
  constructor(message) {
    this.id = message.id;
    this.content = message.content;
    this.senderId = message.senderId;
    this.receiverId = message.receiverId;
    this.consultationId = message.consultationId;
    this.messageType = message.messageType;
    this.attachmentUrl = message.attachmentUrl;
    this.attachmentName = message.attachmentName;
    this.isRead = message.isRead;
    this.createdAt = message.createdAt;
    this.updatedAt = message.updatedAt;

    // Relacionamentos
    this.sender = message.sender ? {
      id: message.sender.id,
      name: message.sender.name,
      email: message.sender.email
    } : null;

    this.receiver = message.receiver ? {
      id: message.receiver.id,
      name: message.receiver.name,
      email: message.receiver.email
    } : null;

    this.consultation = message.consultation ? {
      id: message.consultation.id,
      status: message.consultation.status,
      scheduledAt: message.consultation.scheduledAt
    } : null;
  }

  static fromEntity(message) {
    return new MessageResponseDTO(message);
  }

  static fromEntities(messages) {
    return messages.map(message => MessageResponseDTO.fromEntity(message));
  }
}

module.exports = {
  CreateMessageDTO,
  UpdateMessageDTO,
  MessageResponseDTO
};
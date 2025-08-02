const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

/**
 * MessageRepository - Implementa o padrão Repository
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class MessageRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(messageData) {
    try {
      const message = await this.prisma.message.create({
        data: messageData,
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          receiver: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          consultation: {
            select: {
              id: true,
              status: true,
              scheduledAt: true
            }
          }
        }
      });
      return message;
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Message already exists');
      }
      throw error;
    }
  }

  async findById(id) {
    const message = await this.prisma.message.findUnique({
      where: { id },
      include: {
        sender: {
          select: {
            id: true,
            name: true,
            email: true,
            profileImage: true
          }
        },
        receiver: {
          select: {
            id: true,
            name: true,
            email: true,
            profileImage: true
          }
        },
        consultation: {
          select: {
            id: true,
            status: true,
            scheduledAt: true
          }
        }
      }
    });

    if (!message) {
      throw new NotFoundException('Message not found');
    }

    return message;
  }

  async findAll(filters = {}) {
    const {
      consultationId,
      senderId,
      receiverId,
      messageType,
      isRead,
      page = 1,
      limit = 50,
      orderBy = 'createdAt',
      order = 'desc'
    } = filters;

    const skip = (page - 1) * limit;
    const where = {};

    if (consultationId) {
      where.consultationId = consultationId;
    }

    if (senderId) {
      where.senderId = senderId;
    }

    if (receiverId) {
      where.receiverId = receiverId;
    }

    if (messageType) {
      where.messageType = messageType;
    }

    if (isRead !== undefined) {
      where.isRead = isRead;
    }

    const [messages, total] = await Promise.all([
      this.prisma.message.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [orderBy]: order },
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          receiver: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          consultation: {
            select: {
              id: true,
              status: true,
              scheduledAt: true
            }
          }
        }
      }),
      this.prisma.message.count({ where })
    ]);

    return {
      messages,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async update(id, data) {
    try {
      const message = await this.prisma.message.update({
        where: { id },
        data,
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          receiver: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          consultation: {
            select: {
              id: true,
              status: true,
              scheduledAt: true
            }
          }
        }
      });
      return message;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Message not found');
      }
      throw error;
    }
  }

  async delete(id) {
    try {
      await this.prisma.message.delete({
        where: { id }
      });
      return true;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Message not found');
      }
      throw error;
    }
  }

  async exists(id) {
    const message = await this.prisma.message.findUnique({
      where: { id },
      select: { id: true }
    });
    return !!message;
  }

  async findByConsultation(consultationId, filters = {}) {
    const {
      page = 1,
      limit = 50,
      orderBy = 'createdAt',
      order = 'desc'
    } = filters;

    const skip = (page - 1) * limit;
    const where = { consultationId };

    const [messages, total] = await Promise.all([
      this.prisma.message.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [orderBy]: order },
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          },
          receiver: {
            select: {
              id: true,
              name: true,
              email: true,
              profileImage: true
            }
          }
        }
      }),
      this.prisma.message.count({ where })
    ]);

    return {
      messages,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async markAsRead(messageIds, userId) {
    return await this.prisma.message.updateMany({
      where: {
        id: { in: messageIds },
        receiverId: userId,
        isRead: false
      },
      data: {
        isRead: true
      }
    });
  }

  async markAllAsRead(consultationId, userId) {
    return await this.prisma.message.updateMany({
      where: {
        consultationId,
        receiverId: userId,
        isRead: false
      },
      data: {
        isRead: true
      }
    });
  }

  async getUnreadCount(userId, consultationId = null) {
    const where = {
      receiverId: userId,
      isRead: false
    };

    if (consultationId) {
      where.consultationId = consultationId;
    }

    return await this.prisma.message.count({ where });
  }

  async getMessageStats(userId) {
    const [
      totalSent,
      totalReceived,
      unreadCount,
      totalConsultations
    ] = await Promise.all([
      this.prisma.message.count({ where: { senderId: userId } }),
      this.prisma.message.count({ where: { receiverId: userId } }),
      this.prisma.message.count({
        where: {
          receiverId: userId,
          isRead: false
        }
      }),
      this.prisma.consultation.count({
        where: {
          OR: [
            { patientId: userId },
            { doctorId: userId }
          ]
        }
      })
    ]);

    return {
      totalSent,
      totalReceived,
      unreadCount,
      totalConsultations,
      averageMessagesPerConsultation: totalConsultations > 0
        ? Math.round((totalSent + totalReceived) / totalConsultations)
        : 0
    };
  }

  async deleteOldMessages(daysOld = 365) {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysOld);

    return await this.prisma.message.deleteMany({
      where: {
        createdAt: {
          lt: cutoffDate
        }
      }
    });
  }
}

module.exports = MessageRepository;
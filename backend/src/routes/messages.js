const express = require('express');
const { body, validationResult, query } = require('express-validator');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Get messages for a consultation
router.get('/consultation/:consultationId', authenticateToken, [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 100 })
], async (req, res) => {
  try {
    const { consultationId } = req.params;
    const { page = 1, limit = 50 } = req.query;
    const skip = (page - 1) * limit;

    // Verify user has access to this consultation
    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        OR: [
          { patientId: req.user.id },
          { doctorId: req.user.id }
        ]
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    const [messages, total] = await Promise.all([
      prisma.message.findMany({
        where: { consultationId },
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              profileImage: true
            }
          },
          receiver: {
            select: {
              id: true,
              name: true,
              profileImage: true
            }
          }
        },
        orderBy: {
          createdAt: 'desc'
        },
        skip,
        take: parseInt(limit)
      }),
      prisma.message.count({ where: { consultationId } })
    ]);

    // Mark messages as read for the current user
    await prisma.message.updateMany({
      where: {
        consultationId,
        receiverId: req.user.id,
        isRead: false
      },
      data: {
        isRead: true
      }
    });

    res.json({
      messages: messages.reverse(), // Return in chronological order
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get messages error:', error);
    res.status(500).json({ error: 'Failed to get messages' });
  }
});

// Send a message (legacy endpoint - Socket.io is preferred)
router.post('/consultation/:consultationId', authenticateToken, [
  body('content').notEmpty().withMessage('Message content is required'),
  body('messageType').optional().isIn(['TEXT', 'IMAGE', 'FILE', 'AUDIO'])
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { consultationId } = req.params;
    const { content, messageType = 'TEXT' } = req.body;

    // Verify consultation exists and user has access
    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        OR: [
          { patientId: req.user.id },
          { doctorId: req.user.id }
        ]
      },
      include: {
        patient: true,
        doctor: true
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    // Determine receiver
    const receiverId = consultation.patientId === req.user.id
      ? consultation.doctorId
      : consultation.patientId;

    // Create message
    const message = await prisma.message.create({
      data: {
        consultationId,
        senderId: req.user.id,
        receiverId,
        content,
        messageType
      },
      include: {
        sender: {
          select: {
            id: true,
            name: true,
            profileImage: true
          }
        },
        receiver: {
          select: {
            id: true,
            name: true,
            profileImage: true
          }
        }
      }
    });

    res.status(201).json({
      message: 'Message sent successfully',
      data: message
    });
  } catch (error) {
    console.error('Send message error:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
});

// Mark messages as read
router.patch('/consultation/:consultationId/read', authenticateToken, async (req, res) => {
  try {
    const { consultationId } = req.params;

    // Verify consultation exists and user has access
    const consultation = await prisma.consultation.findFirst({
      where: {
        id: consultationId,
        OR: [
          { patientId: req.user.id },
          { doctorId: req.user.id }
        ]
      }
    });

    if (!consultation) {
      return res.status(404).json({ error: 'Consultation not found' });
    }

    // Mark messages as read
    await prisma.message.updateMany({
      where: {
        consultationId,
        receiverId: req.user.id,
        isRead: false
      },
      data: {
        isRead: true
      }
    });

    res.json({ message: 'Messages marked as read' });
  } catch (error) {
    console.error('Mark messages as read error:', error);
    res.status(500).json({ error: 'Failed to mark messages as read' });
  }
});

// Get unread message count
router.get('/unread/count', authenticateToken, async (req, res) => {
  try {
    const unreadCount = await prisma.message.count({
      where: {
        receiverId: req.user.id,
        isRead: false
      }
    });

    res.json({ unreadCount });
  } catch (error) {
    console.error('Get unread count error:', error);
    res.status(500).json({ error: 'Failed to get unread count' });
  }
});

// Get unread messages by consultation
router.get('/unread/consultations', authenticateToken, async (req, res) => {
  try {
    const unreadByConsultation = await prisma.message.groupBy({
      by: ['consultationId'],
      where: {
        receiverId: req.user.id,
        isRead: false
      },
      _count: {
        id: true
      }
    });

    // Get consultation details for each unread consultation
    const consultationsWithUnread = await Promise.all(
      unreadByConsultation.map(async (item) => {
        const consultation = await prisma.consultation.findUnique({
          where: { id: item.consultationId },
          include: {
            patient: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            },
            doctor: {
              select: {
                id: true,
                name: true,
                profileImage: true
              }
            }
          }
        });

        return {
          consultationId: item.consultationId,
          unreadCount: item._count.id,
          consultation
        };
      })
    );

    res.json({ consultationsWithUnread });
  } catch (error) {
    console.error('Get unread consultations error:', error);
    res.status(500).json({ error: 'Failed to get unread consultations' });
  }
});

// Delete a message (only sender can delete)
router.delete('/:messageId', authenticateToken, async (req, res) => {
  try {
    const { messageId } = req.params;

    const message = await prisma.message.findFirst({
      where: {
        id: messageId,
        senderId: req.user.id
      }
    });

    if (!message) {
      return res.status(404).json({ error: 'Message not found or access denied' });
    }

    await prisma.message.delete({
      where: { id: messageId }
    });

    res.json({ message: 'Message deleted successfully' });
  } catch (error) {
    console.error('Delete message error:', error);
    res.status(500).json({ error: 'Failed to delete message' });
  }
});

// Get message statistics
router.get('/stats', authenticateToken, async (req, res) => {
  try {
    const [
      totalMessages,
      sentMessages,
      receivedMessages,
      unreadMessages
    ] = await Promise.all([
      prisma.message.count({
        where: {
          OR: [
            { senderId: req.user.id },
            { receiverId: req.user.id }
          ]
        }
      }),
      prisma.message.count({
        where: { senderId: req.user.id }
      }),
      prisma.message.count({
        where: { receiverId: req.user.id }
      }),
      prisma.message.count({
        where: {
          receiverId: req.user.id,
          isRead: false
        }
      })
    ]);

    res.json({
      stats: {
        total: totalMessages,
        sent: sentMessages,
        received: receivedMessages,
        unread: unreadMessages
      }
    });
  } catch (error) {
    console.error('Get message stats error:', error);
    res.status(500).json({ error: 'Failed to get message statistics' });
  }
});

module.exports = router;
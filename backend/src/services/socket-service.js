const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Store active connections
const activeConnections = new Map();

const handleSocketConnection = (socket, io) => {
  const userId = socket.user.id;
  const userType = socket.user.userType;

  console.log(`🔌 User connected: ${socket.user.name} (${userType})`);

  // Store connection
  activeConnections.set(userId, {
    socketId: socket.id,
    user: socket.user,
    userType: userType
  });

  // Join user to their personal room
  socket.join(`user_${userId}`);

  // Join consultation rooms if user has active consultations
  joinActiveConsultations(socket, userId);

  // Handle joining consultation room
  socket.on('join_consultation', async (consultationId) => {
    try {
      const consultation = await prisma.consultation.findUnique({
        where: { id: consultationId },
        include: {
          patient: true,
          doctor: true
        }
      });

      if (!consultation) {
        socket.emit('error', { message: 'Consultation not found' });
        return;
      }

      // Check if user is part of this consultation
      if (consultation.patientId !== userId && consultation.doctorId !== userId) {
        socket.emit('error', { message: 'Access denied to this consultation' });
        return;
      }

      socket.join(`consultation_${consultationId}`);
      socket.emit('joined_consultation', { consultationId });

      console.log(`👥 User ${socket.user.name} joined consultation ${consultationId}`);
    } catch (error) {
      console.error('Error joining consultation:', error);
      socket.emit('error', { message: 'Failed to join consultation' });
    }
  });

  // Handle leaving consultation room
  socket.on('leave_consultation', (consultationId) => {
    socket.leave(`consultation_${consultationId}`);
    socket.emit('left_consultation', { consultationId });
    console.log(`👋 User ${socket.user.name} left consultation ${consultationId}`);
  });

  // Handle new message
  socket.on('send_message', async (data) => {
    try {
      const { consultationId, content, messageType = 'TEXT' } = data;

      // Validate consultation
      const consultation = await prisma.consultation.findUnique({
        where: { id: consultationId },
        include: {
          patient: true,
          doctor: true
        }
      });

      if (!consultation) {
        socket.emit('error', { message: 'Consultation not found' });
        return;
      }

      // Check if user is part of this consultation
      if (consultation.patientId !== userId && consultation.doctorId !== userId) {
        socket.emit('error', { message: 'Access denied to this consultation' });
        return;
      }

      // Determine receiver
      const receiverId = consultation.patientId === userId ? consultation.doctorId : consultation.patientId;

      // Save message to database
      const message = await prisma.message.create({
        data: {
          consultationId,
          senderId: userId,
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

      // Emit message to consultation room
      io.to(`consultation_${consultationId}`).emit('new_message', {
        message,
        consultationId
      });

      // Send notification to receiver if not in room
      const receiverConnection = activeConnections.get(receiverId);
      if (receiverConnection && !socket.rooms.has(`consultation_${consultationId}`)) {
        io.to(`user_${receiverId}`).emit('message_notification', {
          consultationId,
          senderName: socket.user.name,
          message: content.substring(0, 50) + (content.length > 50 ? '...' : '')
        });
      }

      console.log(`💬 Message sent in consultation ${consultationId} by ${socket.user.name}`);
    } catch (error) {
      console.error('Error sending message:', error);
      socket.emit('error', { message: 'Failed to send message' });
    }
  });

  // Handle typing indicator
  socket.on('typing', (data) => {
    const { consultationId, isTyping } = data;
    socket.to(`consultation_${consultationId}`).emit('user_typing', {
      userId,
      userName: socket.user.name,
      isTyping
    });
  });

  // Handle read receipts
  socket.on('mark_read', async (data) => {
    try {
      const { consultationId } = data;

      await prisma.message.updateMany({
        where: {
          consultationId,
          receiverId: userId,
          isRead: false
        },
        data: {
          isRead: true
        }
      });

      socket.to(`consultation_${consultationId}`).emit('messages_read', {
        userId,
        consultationId
      });
    } catch (error) {
      console.error('Error marking messages as read:', error);
    }
  });

  // Handle consultation status updates
  socket.on('consultation_status_update', async (data) => {
    try {
      const { consultationId, status } = data;

      const consultation = await prisma.consultation.findUnique({
        where: { id: consultationId }
      });

      if (!consultation || (consultation.doctorId !== userId && consultation.patientId !== userId)) {
        socket.emit('error', { message: 'Access denied' });
        return;
      }

      const updatedConsultation = await prisma.consultation.update({
        where: { id: consultationId },
        data: {
          status,
          ...(status === 'IN_PROGRESS' && { startedAt: new Date() }),
          ...(status === 'COMPLETED' && { endedAt: new Date() })
        },
        include: {
          patient: true,
          doctor: true
        }
      });

      io.to(`consultation_${consultationId}`).emit('consultation_updated', {
        consultation: updatedConsultation
      });
    } catch (error) {
      console.error('Error updating consultation status:', error);
      socket.emit('error', { message: 'Failed to update consultation status' });
    }
  });

  // Handle disconnect
  socket.on('disconnect', () => {
    activeConnections.delete(userId);
    console.log(`🔌 User disconnected: ${socket.user.name}`);
  });
};

// Helper function to join active consultations
const joinActiveConsultations = async (socket, userId) => {
  try {
    const consultations = await prisma.consultation.findMany({
      where: {
        OR: [
          { patientId: userId },
          { doctorId: userId }
        ],
        status: {
          in: ['SCHEDULED', 'IN_PROGRESS']
        }
      }
    });

    consultations.forEach(consultation => {
      socket.join(`consultation_${consultation.id}`);
    });

    if (consultations.length > 0) {
      console.log(`📋 User ${socket.user.name} joined ${consultations.length} active consultations`);
    }
  } catch (error) {
    console.error('Error joining active consultations:', error);
  }
};

// Get active connections (for admin purposes)
const getActiveConnections = () => {
  return Array.from(activeConnections.values());
};

// Get user connection status
const isUserOnline = (userId) => {
  return activeConnections.has(userId);
};

module.exports = {
  handleSocketConnection,
  getActiveConnections,
  isUserOnline
};
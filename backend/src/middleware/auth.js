const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// Middleware for HTTP routes
const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({ error: 'Access token required' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      include: {
        doctorProfile: true,
        patientProfile: true
      }
    });

    if (!user || !user.isActive) {
      return res.status(401).json({ error: 'Invalid or inactive user' });
    }

    req.user = user;
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ error: 'Invalid token' });
    }
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ error: 'Token expired' });
    }
    return res.status(500).json({ error: 'Authentication error' });
  }
};

// Middleware for doctor-only routes
const requireDoctor = (req, res, next) => {
  if (req.user.userType !== 'DOCTOR') {
    return res.status(403).json({ error: 'Doctor access required' });
  }
  next();
};

// Middleware for patient-only routes
const requirePatient = (req, res, next) => {
  if (req.user.userType !== 'PATIENT') {
    return res.status(403).json({ error: 'Patient access required' });
  }
  next();
};

// Socket.io authentication
const authenticateSocket = async (socket, next) => {
  try {
    const token = socket.handshake.auth.token || socket.handshake.headers.authorization?.split(' ')[1];

    if (!token) {
      return next(new Error('Authentication error'));
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      include: {
        doctorProfile: true,
        patientProfile: true
      }
    });

    if (!user || !user.isActive) {
      return next(new Error('Invalid or inactive user'));
    }

    socket.user = user;
    next();
  } catch (error) {
    return next(new Error('Authentication error'));
  }
};

// Optional authentication (for public routes)
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token) {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await prisma.user.findUnique({
        where: { id: decoded.userId },
        include: {
          doctorProfile: true,
          patientProfile: true
        }
      });

      if (user && user.isActive) {
        req.user = user;
      }
    }
    next();
  } catch (error) {
    // Continue without authentication
    next();
  }
};

module.exports = {
  authenticateToken,
  requireDoctor,
  requirePatient,
  authenticateSocket,
  optionalAuth
};
const express = require('express');
const router = express.Router();

// Health check endpoint
router.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Root endpoint
router.get('/', (req, res) => {
  res.status(200).json({
    message: 'Medical Consultation API',
    version: '1.0.0',
    status: 'running',
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
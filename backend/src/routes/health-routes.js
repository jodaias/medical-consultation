const express = require('express');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Saúde
 *   description: API para verificação de saúde do sistema
 */

/**
 * @swagger
 * /health:
 *   get:
 *     summary: Verifica a saúde do sistema
 *     tags: [Saúde]
 *     responses:
 *       200:
 *         description: Sistema funcionando corretamente
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "ok"
 *                 uptime:
 *                   type: number
 *                   example: 1234.56
 *                 timestamp:
 *                   type: string
 *                   format: date-time
 *                   example: "2023-01-01T00:00:00.000Z"
 */
router.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

/**
 * @swagger
 * /:
 *   get:
 *     summary: Informações básicas da API
 *     tags: [Saúde]
 *     responses:
 *       200:
 *         description: Informações básicas da API
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 name:
 *                   type: string
 *                   example: "Medical Consultation Online API"
 *                 version:
 *                   type: string
 *                   example: "1.0.0"
 *                 description:
 *                   type: string
 *                   example: "API para sistema de consultas médicas online"
 *                 documentation:
 *                   type: string
 *                   example: "/api-docs"
 */
router.get('/', (req, res) => {
  res.json({
    name: 'Medical Consultation Online API',
    version: '1.0.0',
    description: 'API para sistema de consultas médicas online',
    documentation: '/api-docs'
  });
});

module.exports = router;
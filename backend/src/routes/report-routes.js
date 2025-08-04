const express = require('express');
const ReportController = require('../controllers/report-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const reportController = new ReportController();

/**
 * @swagger
 * components:
 *   schemas:
 *     Report:
 *       type: object
 *       required:
 *         - type
 *         - userId
 *       properties:
 *         id:
 *           type: string
 *           description: ID único do relatório
 *         type:
 *           type: string
 *           enum: [consultation, financial, patient, rating, prescription]
 *           description: Tipo do relatório
 *         userId:
 *           type: string
 *           description: ID do usuário que gerou o relatório
 *         parameters:
 *           type: object
 *           description: Parâmetros utilizados para gerar o relatório
 *         data:
 *           type: object
 *           description: Dados do relatório
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação do relatório
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização do relatório
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         type: "consultation"
 *         userId: "5f8d0d55b54764421b7156c6"
 *         parameters: {
 *           startDate: "2023-01-01",
 *           endDate: "2023-01-31",
 *           doctorId: "5f8d0d55b54764421b7156c7"
 *         }
 *         data: {
 *           totalConsultations: 25,
 *           completedConsultations: 20,
 *           canceledConsultations: 5
 *         }
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-01T00:00:00.000Z"
 */

/**
 * @swagger
 * tags:
 *   name: Relatórios
 *   description: API para gerenciamento de relatórios
 */

/**
 * @swagger
 * /api/reports:
 *   post:
 *     summary: Cria um novo relatório
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - type
 *               - userId
 *             properties:
 *               type:
 *                 type: string
 *                 enum: [consultation, financial, patient, rating, prescription]
 *               userId:
 *                 type: string
 *               parameters:
 *                 type: object
 *     responses:
 *       201:
 *         description: Relatório criado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/', authenticateToken, apiRateLimiter, reportController.create);

/**
 * @swagger
 * /api/reports:
 *   get:
 *     summary: Lista todos os relatórios
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [consultation, financial, patient, rating, prescription]
 *         description: Filtrar por tipo de relatório
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: Filtrar por usuário
 *     responses:
 *       200:
 *         description: Lista de relatórios
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Report'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, reportController.findAll);

/**
 * @swagger
 * /api/reports/{id}:
 *   get:
 *     summary: Busca relatório por ID
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do relatório
 *     responses:
 *       200:
 *         description: Dados do relatório
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Relatório não encontrado
 */
router.get('/:id', authenticateToken, reportController.findById);

/**
 * @swagger
 * /api/reports/{id}:
 *   delete:
 *     summary: Deleta relatório
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do relatório
 *     responses:
 *       200:
 *         description: Relatório deletado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Relatório não encontrado
 */
router.delete('/:id', authenticateToken, reportController.delete);

/**
 * @swagger
 * /api/reports/generate/consultation:
 *   post:
 *     summary: Gera relatório de consultas
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               startDate:
 *                 type: string
 *                 format: date
 *               endDate:
 *                 type: string
 *                 format: date
 *               doctorId:
 *                 type: string
 *               patientId:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [scheduled, completed, canceled, no_show]
 *     responses:
 *       200:
 *         description: Relatório gerado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/generate/consultation', authenticateToken, reportController.generateConsultationReport);

/**
 * @swagger
 * /api/reports/generate/financial:
 *   post:
 *     summary: Gera relatório financeiro
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               startDate:
 *                 type: string
 *                 format: date
 *               endDate:
 *                 type: string
 *                 format: date
 *               doctorId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Relatório gerado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/generate/financial', authenticateToken, reportController.generateFinancialReport);

/**
 * @swagger
 * /api/reports/generate/patient:
 *   post:
 *     summary: Gera relatório de pacientes
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               startDate:
 *                 type: string
 *                 format: date
 *               endDate:
 *                 type: string
 *                 format: date
 *               doctorId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Relatório gerado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/generate/patient', authenticateToken, reportController.generatePatientReport);

/**
 * @swagger
 * /api/reports/generate/rating:
 *   post:
 *     summary: Gera relatório de avaliações
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               startDate:
 *                 type: string
 *                 format: date
 *               endDate:
 *                 type: string
 *                 format: date
 *               doctorId:
 *                 type: string
 *               minRating:
 *                 type: number
 *                 format: float
 *               maxRating:
 *                 type: number
 *                 format: float
 *     responses:
 *       200:
 *         description: Relatório gerado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/generate/rating', authenticateToken, reportController.generateRatingReport);

/**
 * @swagger
 * /api/reports/generate/prescription:
 *   post:
 *     summary: Gera relatório de prescrições
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               startDate:
 *                 type: string
 *                 format: date
 *               endDate:
 *                 type: string
 *                 format: date
 *               doctorId:
 *                 type: string
 *               patientId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Relatório gerado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Report'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/generate/prescription', authenticateToken, reportController.generatePrescriptionReport);

/**
 * @swagger
 * /api/reports/dashboard/stats:
 *   get:
 *     summary: Obtém estatísticas para o dashboard
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: ID do usuário (médico ou paciente)
 *       - in: query
 *         name: period
 *         schema:
 *           type: string
 *           enum: [day, week, month, year]
 *         description: Período para as estatísticas
 *     responses:
 *       200:
 *         description: Estatísticas do dashboard
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *       401:
 *         description: Não autorizado
 */
router.get('/dashboard/stats', authenticateToken, reportController.generateDashboardStats);

/**
 * @swagger
 * /api/reports/export/{id}:
 *   get:
 *     summary: Exporta relatório em formato específico
 *     tags: [Relatórios]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do relatório
 *       - in: query
 *         name: format
 *         schema:
 *           type: string
 *           enum: [pdf, csv, excel]
 *         required: true
 *         description: Formato de exportação
 *     responses:
 *       200:
 *         description: Relatório exportado com sucesso
 *         content:
 *           application/pdf:
 *             schema:
 *               type: string
 *               format: binary
 *           text/csv:
 *             schema:
 *               type: string
 *               format: binary
 *           application/vnd.openxmlformats-officedocument.spreadsheetml.sheet:
 *             schema:
 *               type: string
 *               format: binary
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Relatório não encontrado
 */
router.get('/export/:id', authenticateToken, reportController.exportReport);

module.exports = router;
const express = require('express');
const router = express.Router();
const ReportController = require('../controllers/report-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const reportController = new ReportController();

// Aplicar rate limiting em todas as rotas
router.use(apiRateLimiter);

// Rotas protegidas - requerem autenticação
router.use(authenticateToken);

// CRUD básico
router.post('/', reportController.create.bind(reportController));
router.get('/', reportController.findAll.bind(reportController));
router.get('/:id', reportController.findById.bind(reportController));
router.put('/:id', reportController.update.bind(reportController));
router.delete('/:id', reportController.delete.bind(reportController));

// Relatórios específicos
router.get('/consultations/stats', reportController.generateConsultationReport.bind(reportController));
router.get('/financial/stats', reportController.generateFinancialReport.bind(reportController));
router.get('/patients/stats', reportController.generatePatientReport.bind(reportController));
router.get('/ratings/stats', reportController.generateRatingReport.bind(reportController));
router.get('/prescriptions/stats', reportController.generatePrescriptionReport.bind(reportController));

// Dashboard stats
router.get('/dashboard/stats', reportController.generateDashboardStats.bind(reportController));

// Exportar relatório
router.get('/:id/export', reportController.exportReport.bind(reportController));

module.exports = router;
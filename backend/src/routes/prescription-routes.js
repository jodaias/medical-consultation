const express = require('express');
const PrescriptionController = require('../controllers/prescription-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const prescriptionController = new PrescriptionController();

// Apply rate limiting to all prescription routes
router.use(apiRateLimiter);

// Apply authentication to all routes
router.use(authenticateToken);

// CRUD operations
router.post('/', prescriptionController.create);
router.get('/', prescriptionController.findAll);
router.get('/:id', prescriptionController.findById);
router.put('/:id', prescriptionController.update);
router.delete('/:id', prescriptionController.delete);

// Specialized routes
router.get('/consultation/:consultationId', prescriptionController.findByConsultation);
router.get('/doctors/:doctorId', prescriptionController.findByDoctor);
router.get('/patient/:patientId', prescriptionController.findByPatient);

// Statistics and utilities
router.get('/stats/overview', prescriptionController.getStats);
router.post('/deactivate-expired', prescriptionController.deactivateExpired);
router.post('/validate', prescriptionController.validate);

module.exports = router;
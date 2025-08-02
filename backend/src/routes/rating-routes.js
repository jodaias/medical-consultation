const express = require('express');
const RatingController = require('../controllers/rating-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const ratingController = new RatingController();

// Apply rate limiting to all rating routes
router.use(apiRateLimiter);

// Apply authentication to all routes
router.use(authenticateToken);

// CRUD operations
router.post('/', ratingController.create);
router.get('/', ratingController.findAll);
router.get('/:id', ratingController.findById);
router.put('/:id', ratingController.update);
router.delete('/:id', ratingController.delete);

// Specialized routes
router.get('/consultation/:consultationId', ratingController.findByConsultation);
router.get('/doctors/:doctorId', ratingController.findByDoctor);
router.get('/patients/:patientId', ratingController.findByPatient);

// Interactive features
router.post('/:id/helpful', ratingController.markAsHelpful);

// Statistics and utilities
router.get('/stats/overview', ratingController.getStats);
router.post('/validate', ratingController.validate);

module.exports = router;
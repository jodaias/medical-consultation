const RatingService = require('../services/rating-service');
const BaseController = require('../interfaces/base-controller');

class RatingController extends BaseController {
  constructor() {
    const ratingService = new RatingService();
    super(ratingService);
    this.ratingService = ratingService;
  }

  create = this.handleAsync(async (req, res) => {
    try {
      const ratingData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;

      const rating = await this.ratingService.create(ratingData, userId, userType);
      return this.sendSuccess(res, rating, 'Rating created successfully', 201);
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findById = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const rating = await this.ratingService.findById(id, userId, userType);
      return this.sendSuccess(res, rating, 'Rating found successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findAll = this.handleAsync(async (req, res) => {
    try {
      const filters = {
        consultationId: req.query.consultationId,
        ratingType: req.query.ratingType,
        minRating: req.query.minRating,
        maxRating: req.query.maxRating,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.ratingService.findAll(filters, userId, userType);
      return this.sendSuccess(res, result, 'Ratings retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  update = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const updateData = req.body;
      const userId = req.user.id;
      const userType = req.user.userType;

      const rating = await this.ratingService.update(id, updateData, userId, userType);
      return this.sendSuccess(res, rating, 'Rating updated successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  delete = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      await this.ratingService.delete(id, userId, userType);
      return this.sendSuccess(res, null, 'Rating deleted successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByConsultation = this.handleAsync(async (req, res) => {
    try {
      const { consultationId } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const ratings = await this.ratingService.findByConsultation(consultationId, userId, userType);
      return this.sendSuccess(res, ratings, 'Ratings for consultation retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByDoctor = this.handleAsync(async (req, res) => {
    try {
      const { doctorId } = req.params;
      const filters = {
        ratingType: req.query.ratingType,
        minRating: req.query.minRating,
        maxRating: req.query.maxRating,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.ratingService.findByDoctor(doctorId, filters, userId, userType);
      return this.sendSuccess(res, result, 'Doctor ratings retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  findByPatient = this.handleAsync(async (req, res) => {
    try {
      const { patientId } = req.params;
      const filters = {
        ratingType: req.query.ratingType,
        minRating: req.query.minRating,
        maxRating: req.query.maxRating,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10
      };

      const userId = req.user.id;
      const userType = req.user.userType;

      const result = await this.ratingService.findByPatient(patientId, filters, userId, userType);
      return this.sendSuccess(res, result, 'Patient ratings retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  markAsHelpful = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      const userId = req.user.id;
      const userType = req.user.userType;

      const rating = await this.ratingService.markAsHelpful(id, userId, userType);
      return this.sendSuccess(res, rating, 'Rating marked as helpful successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  getStats = this.handleAsync(async (req, res) => {
    try {
      const userId = req.user.id;
      const userType = req.user.userType;

      const stats = await this.ratingService.getRatingStats(userId, userType);
      return this.sendSuccess(res, stats, 'Rating statistics retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  validate = this.handleAsync(async (req, res) => {
    try {
      const ratingData = req.body;
      const errors = await this.ratingService.validate(ratingData);

      if (errors.length > 0) {
        return this.sendError(res, new Error(errors.join(', ')), 400);
      }

      return this.sendSuccess(res, { valid: true }, 'Rating data is valid');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = RatingController;
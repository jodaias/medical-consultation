/**
 * Interface base para controllers
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class BaseController {
  constructor(service) {
    if (!service) {
      throw new Error('Service is required');
    }
    this.service = service;
  }

  async create(req, res) {
    throw new Error('Method create() must be implemented');
  }

  async findById(req, res) {
    throw new Error('Method findById() must be implemented');
  }

  async findAll(req, res) {
    throw new Error('Method findAll() must be implemented');
  }

  async update(req, res) {
    throw new Error('Method update() must be implemented');
  }

  async delete(req, res) {
    throw new Error('Method delete() must be implemented');
  }

  // Métodos utilitários
  sendSuccess(res, data, message = 'Success', statusCode = 200) {
    return res.status(statusCode).json({
      success: true,
      message,
      data
    });
  }

  sendError(res, error, statusCode = 400) {
    return res.status(statusCode).json({
      success: false,
      message: error.message || 'An error occurred',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }

  handleAsync(fn) {
    return (req, res, next) => {
      Promise.resolve(fn(req, res, next)).catch(next);
    };
  }
}

module.exports = BaseController;
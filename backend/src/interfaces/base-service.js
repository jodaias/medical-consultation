/**
 * Interface base para services
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class BaseService {
  constructor(repository) {
    if (!repository) {
      throw new Error('Repository is required');
    }
    this.repository = repository;
  }

  async create(data) {
    throw new Error('Method create() must be implemented');
  }

  async findById(id) {
    throw new Error('Method findById() must be implemented');
  }

  async findAll(filters = {}) {
    throw new Error('Method findAll() must be implemented');
  }

  async update(id, data) {
    throw new Error('Method update() must be implemented');
  }

  async delete(id) {
    throw new Error('Method delete() must be implemented');
  }

  async validate(data) {
    throw new Error('Method validate() must be implemented');
  }
}

module.exports = BaseService;
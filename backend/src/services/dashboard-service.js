const DashboardRepository = require('../repositories/dashboard-repository');
const { ValidationException, NotFoundException } = require('../exceptions/app-exception');

/**
 * DashboardService - Lógica de negócio para o dashboard
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class DashboardService {
  constructor() {
    this.repository = new DashboardRepository();
  }

  /**
   * Obtém estatísticas gerais para o dashboard
   * @param {string} userId - ID do usuário (médico ou paciente)
   * @param {string} role - Função do usuário (doctor, patient, admin)
   * @param {string} period - Período para as estatísticas (day, week, month, year)
   * @returns {Object} Estatísticas do dashboard
   */
  async getStats(userId, role, period = 'month') {
    // Validar parâmetros
    if (userId && !this.isValidUUID(userId)) {
      throw new ValidationException('Invalid user ID format');
    }

    if (role && !['doctor', 'patient', 'admin'].includes(role.toLowerCase())) {
      throw new ValidationException('Invalid role. Must be doctor, patient or admin');
    }

    if (!['day', 'week', 'month', 'year'].includes(period.toLowerCase())) {
      throw new ValidationException('Invalid period. Must be day, week, month or year');
    }

    // Obter estatísticas do repositório
    return this.repository.getStats(userId, role, period);
  }

  /**
   * Obtém alertas e insights para o dashboard
   * @param {string} userId - ID do usuário (médico ou paciente)
   * @param {string} role - Função do usuário (doctor, patient, admin)
   * @returns {Array} Alertas e insights do dashboard
   */
  async getAlerts(userId, role) {
    // Validar parâmetros
    if (userId && !this.isValidUUID(userId)) {
      throw new ValidationException('Invalid user ID format');
    }

    if (role && !['doctor', 'patient', 'admin'].includes(role.toLowerCase())) {
      throw new ValidationException('Invalid role. Must be doctor, patient or admin');
    }

    // Obter alertas do repositório
    return this.repository.getAlerts(userId, role);
  }

  /**
   * Obtém notificações para o usuário
   * @param {string} userId - ID do usuário
   * @param {boolean} read - Filtrar por status de leitura
   * @returns {Array} Notificações do usuário
   */
  async getNotifications(userId, read) {
    // Validar parâmetros
    if (!userId) {
      throw new ValidationException('User ID is required');
    }

    if (!this.isValidUUID(userId)) {
      throw new ValidationException('Invalid user ID format');
    }

    // Converter read para booleano se for string
    let readFilter = read;
    if (read !== undefined && typeof read === 'string') {
      readFilter = read.toLowerCase() === 'true';
    }

    // Obter notificações do repositório
    return this.repository.getNotifications(userId, readFilter);
  }

  /**
   * Marca notificação como lida
   * @param {string} id - ID da notificação
   * @returns {Object} Notificação atualizada
   */
  async markNotificationAsRead(id) {
    // Validar parâmetros
    if (!id) {
      throw new ValidationException('Notification ID is required');
    }

    if (!this.isValidUUID(id)) {
      throw new ValidationException('Invalid notification ID format');
    }

    // Verificar se notificação existe
    const notification = await this.repository.findNotificationById(id);
    if (!notification) {
      throw new NotFoundException('Notification not found');
    }

    // Marcar como lida
    return this.repository.markNotificationAsRead(id);
  }

  /**
   * Marca todas as notificações do usuário como lidas
   * @param {string} userId - ID do usuário
   * @returns {number} Número de notificações atualizadas
   */
  async markAllNotificationsAsRead(userId) {
    // Validar parâmetros
    if (!userId) {
      throw new ValidationException('User ID is required');
    }

    if (!this.isValidUUID(userId)) {
      throw new ValidationException('Invalid user ID format');
    }

    // Marcar todas como lidas
    return this.repository.markAllNotificationsAsRead(userId);
  }

  /**
   * Valida se uma string é um UUID válido
   * @param {string} uuid - String a ser validada
   * @returns {boolean} Verdadeiro se for um UUID válido
   */
  isValidUUID(uuid) {
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    return uuidRegex.test(uuid);
  }
}

module.exports = DashboardService;
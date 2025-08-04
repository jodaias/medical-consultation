const DashboardService = require('../services/dashboard-service');
const BaseController = require('../interfaces/base-controller');

/**
 * DashboardController - Controlador para operações do dashboard
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class DashboardController extends BaseController {
  constructor() {
    const dashboardService = new DashboardService();
    super(dashboardService);
    this.dashboardService = dashboardService;
  }

  // Obter estatísticas gerais para o dashboard
  getStats = this.handleAsync(async (req, res) => {
    try {
      const { userId, role, period } = req.query;
      
      const stats = await this.dashboardService.getStats(userId, role, period);

      return this.sendSuccess(res, stats, 'Dashboard statistics retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Obter alertas e insights para o dashboard
  getAlerts = this.handleAsync(async (req, res) => {
    try {
      const { userId, role } = req.query;
      
      const alerts = await this.dashboardService.getAlerts(userId, role);

      return this.sendSuccess(res, alerts, 'Dashboard alerts retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Obter notificações para o usuário
  getNotifications = this.handleAsync(async (req, res) => {
    try {
      const { userId, read } = req.query;
      
      const notifications = await this.dashboardService.getNotifications(userId, read);

      return this.sendSuccess(res, notifications, 'Notifications retrieved successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Marcar notificação como lida
  markNotificationAsRead = this.handleAsync(async (req, res) => {
    try {
      const { id } = req.params;
      
      await this.dashboardService.markNotificationAsRead(id);

      return this.sendSuccess(res, null, 'Notification marked as read successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });

  // Marcar todas as notificações do usuário como lidas
  markAllNotificationsAsRead = this.handleAsync(async (req, res) => {
    try {
      const { userId } = req.query;
      
      const count = await this.dashboardService.markAllNotificationsAsRead(userId);

      return this.sendSuccess(res, { count }, 'All notifications marked as read successfully');
    } catch (error) {
      return this.sendError(res, error, error.statusCode || 400);
    }
  });
}

module.exports = DashboardController;
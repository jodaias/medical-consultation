const express = require('express');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();

/**
 * Rotas do Dashboard
 */

// GET /api/dashboard/stats - Estatísticas do dashboard
router.get('/stats', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.userType;
    const { period } = req.query;

    // Mock data para estatísticas
    const stats = {
      totalConsultations: 25,
      completedConsultations: 20,
      pendingConsultations: 5,
      totalRevenue: 1500.00,
      averageRating: 4.8,
      newPatients: 8,
      period: period || 'month'
    };

    res.json({
      success: true,
      data: stats,
      message: 'Dashboard statistics retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving dashboard statistics',
      error: error.message
    });
  }
});

// GET /api/dashboard/alerts - Alertas e insights
router.get('/alerts', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.userType;

    // Mock data para alertas
    const alerts = [
      {
        id: '1',
        type: 'info',
        title: 'Nova consulta agendada',
        message: 'Você tem uma nova consulta agendada para amanhã às 14:00',
        createdAt: new Date().toISOString(),
        isRead: false
      },
      {
        id: '2',
        type: 'warning',
        title: 'Consulta cancelada',
        message: 'Uma consulta foi cancelada pelo paciente',
        createdAt: new Date().toISOString(),
        isRead: true
      },
      {
        id: '3',
        type: 'success',
        title: 'Avaliação recebida',
        message: 'Você recebeu uma nova avaliação de 5 estrelas',
        createdAt: new Date().toISOString(),
        isRead: false
      }
    ];

    res.json({
      success: true,
      data: alerts,
      message: 'Alerts retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving alerts',
      error: error.message
    });
  }
});

// GET /api/dashboard/notifications - Notificações
router.get('/notifications', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    const { limit = 10, offset = 0 } = req.query;

    // Mock data para notificações
    const notifications = [
      {
        id: '1',
        title: 'Nova mensagem',
        message: 'Você recebeu uma nova mensagem do paciente',
        type: 'message',
        isRead: false,
        createdAt: new Date().toISOString()
      },
      {
        id: '2',
        title: 'Consulta confirmada',
        message: 'Sua consulta foi confirmada pelo médico',
        type: 'consultation',
        isRead: true,
        createdAt: new Date().toISOString()
      }
    ];

    res.json({
      success: true,
      data: notifications.slice(offset, offset + limit),
      message: 'Notifications retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving notifications',
      error: error.message
    });
  }
});

// PUT /api/dashboard/notifications/:id/read - Marcar notificação como lida
router.put('/notifications/:id/read', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    res.json({
      success: true,
      message: 'Notification marked as read'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error marking notification as read',
      error: error.message
    });
  }
});

// PUT /api/dashboard/notifications/read-all - Marcar todas como lidas
router.put('/notifications/read-all', authenticateToken, async (req, res) => {
  try {
    res.json({
      success: true,
      message: 'All notifications marked as read'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error marking all notifications as read',
      error: error.message
    });
  }
});

// DELETE /api/dashboard/notifications/:id - Deletar notificação
router.delete('/notifications/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    res.json({
      success: true,
      message: 'Notification deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting notification',
      error: error.message
    });
  }
});

// GET /api/dashboard/charts - Dados para gráficos
router.get('/charts', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    const { chartType, period } = req.query;

    // Mock data para gráficos
    const chartData = {
      consultations: {
        labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'],
        data: [12, 19, 15, 25, 22, 30]
      },
      revenue: {
        labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'],
        data: [1200, 1900, 1500, 2500, 2200, 3000]
      }
    };

    res.json({
      success: true,
      data: chartData,
      message: 'Chart data retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving chart data',
      error: error.message
    });
  }
});

// GET /api/dashboard/reports - Relatórios
router.get('/reports', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    const { reportType, period } = req.query;

    // Mock data para relatórios
    const reports = {
      consultations: {
        total: 150,
        completed: 120,
        cancelled: 10,
        pending: 20
      },
      revenue: {
        total: 15000.00,
        average: 125.00,
        growth: 15.5
      }
    };

    res.json({
      success: true,
      data: reports,
      message: 'Reports retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving reports',
      error: error.message
    });
  }
});

// GET /api/dashboard/export - Exportar dados
router.get('/export', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    const { format, period } = req.query;

    res.json({
      success: true,
      data: {
        downloadUrl: '/api/dashboard/export/download',
        format: format || 'pdf',
        period: period || 'month'
      },
      message: 'Export data prepared successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error preparing export data',
      error: error.message
    });
  }
});

// GET /api/dashboard/realtime - Métricas em tempo real
router.get('/realtime', authenticateToken, apiRateLimiter, async (req, res) => {
  try {
    // Mock data para métricas em tempo real
    const realtimeData = {
      activeUsers: 45,
      currentConsultations: 8,
      pendingMessages: 12,
      systemStatus: 'online'
    };

    res.json({
      success: true,
      data: realtimeData,
      message: 'Real-time metrics retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving real-time metrics',
      error: error.message
    });
  }
});

module.exports = router;
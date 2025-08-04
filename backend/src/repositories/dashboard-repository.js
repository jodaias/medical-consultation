const { PrismaClient } = require('@prisma/client');
const { NotFoundException } = require('../exceptions/app-exception');

/**
 * DashboardRepository - Implementa o padrão Repository para o dashboard
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class DashboardRepository {
  constructor() {
    this.prisma = new PrismaClient();
    // Dados mockados para desenvolvimento
    this.mockData = this.generateMockData();
  }

  /**
   * Obtém estatísticas gerais para o dashboard
   * @param {string} userId - ID do usuário (médico ou paciente)
   * @param {string} role - Função do usuário (doctor, patient, admin)
   * @param {string} period - Período para as estatísticas (day, week, month, year)
   * @returns {Object} Estatísticas do dashboard
   */
  async getStats(userId, role, period) {
    // TODO: Implementar consulta real ao banco de dados
    // Por enquanto, retorna dados mockados
    const stats = this.mockData.stats;

    // Filtrar dados com base nos parâmetros
    if (userId) {
      // Simular filtragem por usuário
      if (role === 'doctor') {
        stats.patients.total = Math.floor(stats.patients.total * 0.8);
        stats.patients.new = Math.floor(stats.patients.new * 0.8);
      } else if (role === 'patient') {
        stats.consultations.total = Math.floor(stats.consultations.total * 0.3);
        stats.consultations.completed = Math.floor(stats.consultations.completed * 0.3);
        stats.consultations.scheduled = Math.floor(stats.consultations.scheduled * 0.3);
        stats.consultations.canceled = Math.floor(stats.consultations.canceled * 0.3);
      }
    }

    // Simular filtragem por período
    const periodMultiplier = {
      day: 0.1,
      week: 0.3,
      month: 1,
      year: 12
    };

    const multiplier = periodMultiplier[period] || 1;

    if (period !== 'month') {
      stats.consultations.total = Math.floor(stats.consultations.total * multiplier);
      stats.consultations.completed = Math.floor(stats.consultations.completed * multiplier);
      stats.consultations.scheduled = Math.floor(stats.consultations.scheduled * multiplier);
      stats.consultations.canceled = Math.floor(stats.consultations.canceled * multiplier);
      stats.revenue.total = parseFloat((stats.revenue.total * multiplier).toFixed(2));
      stats.patients.new = Math.floor(stats.patients.new * multiplier);
      stats.messages.total = Math.floor(stats.messages.total * multiplier);
      stats.messages.unread = Math.floor(stats.messages.unread * multiplier);
    }

    return stats;
  }

  /**
   * Obtém alertas e insights para o dashboard
   * @param {string} userId - ID do usuário (médico ou paciente)
   * @param {string} role - Função do usuário (doctor, patient, admin)
   * @returns {Array} Alertas e insights do dashboard
   */
  async getAlerts(userId, role) {
    // TODO: Implementar consulta real ao banco de dados
    // Por enquanto, retorna dados mockados
    let alerts = [...this.mockData.alerts];

    // Filtrar alertas com base nos parâmetros
    if (role) {
      if (role.toLowerCase() === 'doctor') {
        alerts = alerts.filter(alert => 
          alert.type === 'alert' || 
          alert.message.includes('paciente') || 
          alert.message.includes('consulta')
        );
      } else if (role.toLowerCase() === 'patient') {
        alerts = alerts.filter(alert => 
          alert.type === 'notification' || 
          alert.message.includes('médico') || 
          alert.message.includes('consulta')
        );
      }
    }

    return alerts;
  }

  /**
   * Obtém notificações para o usuário
   * @param {string} userId - ID do usuário
   * @param {boolean} read - Filtrar por status de leitura
   * @returns {Array} Notificações do usuário
   */
  async getNotifications(userId, read) {
    // TODO: Implementar consulta real ao banco de dados
    // Por enquanto, retorna dados mockados
    let notifications = [...this.mockData.notifications];

    // Filtrar notificações com base nos parâmetros
    if (userId) {
      // Simular filtragem por usuário
      notifications = notifications.filter(notification => 
        notification.userId === userId || notification.userId === 'all'
      );
    }

    if (read !== undefined) {
      // Filtrar por status de leitura
      notifications = notifications.filter(notification => notification.read === read);
    }

    return notifications;
  }

  /**
   * Busca uma notificação pelo ID
   * @param {string} id - ID da notificação
   * @returns {Object} Notificação encontrada ou null
   */
  async findNotificationById(id) {
    // TODO: Implementar consulta real ao banco de dados
    // Por enquanto, busca em dados mockados
    return this.mockData.notifications.find(notification => notification.id === id) || null;
  }

  /**
   * Marca notificação como lida
   * @param {string} id - ID da notificação
   * @returns {Object} Notificação atualizada
   */
  async markNotificationAsRead(id) {
    // TODO: Implementar atualização real no banco de dados
    // Por enquanto, atualiza em dados mockados
    const notificationIndex = this.mockData.notifications.findIndex(notification => notification.id === id);
    
    if (notificationIndex === -1) {
      throw new NotFoundException('Notification not found');
    }

    this.mockData.notifications[notificationIndex].read = true;
    return this.mockData.notifications[notificationIndex];
  }

  /**
   * Marca todas as notificações do usuário como lidas
   * @param {string} userId - ID do usuário
   * @returns {number} Número de notificações atualizadas
   */
  async markAllNotificationsAsRead(userId) {
    // TODO: Implementar atualização real no banco de dados
    // Por enquanto, atualiza em dados mockados
    let count = 0;

    this.mockData.notifications.forEach((notification, index) => {
      if ((notification.userId === userId || notification.userId === 'all') && !notification.read) {
        this.mockData.notifications[index].read = true;
        count++;
      }
    });

    return count;
  }

  /**
   * Gera dados mockados para desenvolvimento
   * @returns {Object} Dados mockados
   */
  generateMockData() {
    return {
      stats: {
        consultations: {
          total: 120,
          completed: 85,
          scheduled: 25,
          canceled: 10
        },
        ratings: {
          average: 4.7,
          count: 78
        },
        revenue: {
          total: 12500.00,
          thisMonth: 3200.00,
          lastMonth: 2800.00
        },
        patients: {
          total: 95,
          new: 12
        },
        messages: {
          total: 350,
          unread: 8
        }
      },
      alerts: [
        {
          id: '1',
          type: 'alert',
          priority: 'high',
          message: 'Você tem 3 consultas agendadas para hoje',
          data: { consultationCount: 3 },
          createdAt: new Date().toISOString()
        },
        {
          id: '2',
          type: 'insight',
          priority: 'medium',
          message: 'Sua taxa de conclusão de consultas aumentou 15% este mês',
          data: { increasePercentage: 15 },
          createdAt: new Date().toISOString()
        },
        {
          id: '3',
          type: 'notification',
          priority: 'low',
          message: 'Você tem 8 mensagens não lidas',
          data: { unreadCount: 8 },
          createdAt: new Date().toISOString()
        },
        {
          id: '4',
          type: 'alert',
          priority: 'medium',
          message: 'Lembre-se de atualizar seu perfil médico',
          data: { lastUpdate: '2023-05-15T10:30:00Z' },
          createdAt: new Date().toISOString()
        },
        {
          id: '5',
          type: 'insight',
          priority: 'low',
          message: 'Pacientes com mais de 60 anos representam 35% das suas consultas',
          data: { percentage: 35, ageGroup: '60+' },
          createdAt: new Date().toISOString()
        }
      ],
      notifications: [
        {
          id: '1',
          userId: 'all',
          title: 'Manutenção Programada',
          message: 'O sistema estará indisponível para manutenção no dia 15/07 das 02:00 às 04:00',
          type: 'system',
          read: false,
          data: { maintenanceDate: '2023-07-15T02:00:00Z', duration: '2h' },
          createdAt: new Date().toISOString()
        },
        {
          id: '2',
          userId: '123e4567-e89b-12d3-a456-426614174000',
          title: 'Nova Consulta',
          message: 'Você tem uma nova consulta agendada para amanhã às 14:00',
          type: 'consultation',
          read: false,
          data: { consultationId: '123', scheduledAt: '2023-07-10T14:00:00Z' },
          createdAt: new Date().toISOString()
        },
        {
          id: '3',
          userId: '123e4567-e89b-12d3-a456-426614174000',
          title: 'Nova Mensagem',
          message: 'Dr. Silva enviou uma nova mensagem',
          type: 'message',
          read: true,
          data: { messageId: '456', senderId: '789' },
          createdAt: new Date().toISOString()
        },
        {
          id: '4',
          userId: '223e4567-e89b-12d3-a456-426614174001',
          title: 'Nova Prescrição',
          message: 'Uma nova prescrição foi adicionada ao seu histórico',
          type: 'prescription',
          read: false,
          data: { prescriptionId: '101' },
          createdAt: new Date().toISOString()
        },
        {
          id: '5',
          userId: '123e4567-e89b-12d3-a456-426614174000',
          title: 'Consulta Cancelada',
          message: 'Sua consulta de 12/07 às 10:00 foi cancelada',
          type: 'consultation',
          read: false,
          data: { consultationId: '102', scheduledAt: '2023-07-12T10:00:00Z' },
          createdAt: new Date().toISOString()
        }
      ]
    };
  }
}

module.exports = DashboardRepository;
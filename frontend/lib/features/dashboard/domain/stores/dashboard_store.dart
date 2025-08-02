import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:medical_consultation_app/features/dashboard/data/models/notification_model.dart';
import 'package:medical_consultation_app/features/dashboard/data/services/dashboard_service.dart';

part 'dashboard_store.g.dart';

@injectable
class DashboardStore = _DashboardStore with _$DashboardStore;

abstract class _DashboardStore with Store {
  final DashboardService _dashboardService = DashboardService();

  @observable
  DashboardStatsModel? stats;

  @observable
  ObservableList<NotificationModel> notifications =
      ObservableList<NotificationModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  Map<String, dynamic> chartData = {};

  @observable
  Map<String, dynamic> reports = {};

  @observable
  Map<String, dynamic> realTimeMetrics = {};

  @observable
  List<Map<String, dynamic>> alertsAndInsights = [];

  @observable
  String selectedPeriod = 'month';

  @observable
  bool isRefreshing = false;

  // Computed
  @computed
  bool get hasStats => stats != null;

  @computed
  bool get hasNotifications => notifications.isNotEmpty;

  @computed
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  @computed
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  @computed
  List<NotificationModel> get recentNotifications =>
      notifications.take(5).toList();

  // Actions
  @action
  Future<void> loadDashboardStats({String? period}) async {
    try {
      isLoading = true;
      errorMessage = null;
      if (period != null) selectedPeriod = period;

      stats = await _dashboardService.getDashboardStats(period: selectedPeriod);
    } catch (e) {
      errorMessage = 'Erro ao carregar estatísticas: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadNotifications({int? limit, int? offset}) async {
    try {
      isLoading = true;
      errorMessage = null;

      final notificationsList = await _dashboardService.getNotifications(
          limit: limit, offset: offset);
      notifications.clear();
      notifications.addAll(notificationsList);
    } catch (e) {
      errorMessage = 'Erro ao carregar notificações: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _dashboardService.markNotificationAsRead(notificationId);

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = notifications[index];
        notifications[index] = notification.copyWith(isRead: true);
      }
    } catch (e) {
      errorMessage = 'Erro ao marcar notificação como lida: $e';
    }
  }

  @action
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _dashboardService.markAllNotificationsAsRead();

      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    } catch (e) {
      errorMessage = 'Erro ao marcar todas as notificações como lidas: $e';
    }
  }

  @action
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _dashboardService.deleteNotification(notificationId);
      notifications.removeWhere((n) => n.id == notificationId);
    } catch (e) {
      errorMessage = 'Erro ao deletar notificação: $e';
    }
  }

  @action
  Future<void> loadChartData({String? chartType}) async {
    try {
      chartData = await _dashboardService.getChartData(
        chartType: chartType,
        period: selectedPeriod,
      );
    } catch (e) {
      errorMessage = 'Erro ao carregar dados dos gráficos: $e';
    }
  }

  @action
  Future<void> loadReports({String? reportType}) async {
    try {
      reports = await _dashboardService.getReports(
        reportType: reportType,
        period: selectedPeriod,
      );
    } catch (e) {
      errorMessage = 'Erro ao carregar relatórios: $e';
    }
  }

  @action
  Future<void> loadRealTimeMetrics() async {
    try {
      realTimeMetrics = await _dashboardService.getRealTimeMetrics();
    } catch (e) {
      errorMessage = 'Erro ao carregar métricas em tempo real: $e';
    }
  }

  @action
  Future<void> loadAlertsAndInsights() async {
    try {
      alertsAndInsights = await _dashboardService.getAlertsAndInsights();
    } catch (e) {
      errorMessage = 'Erro ao carregar alertas e insights: $e';
    }
  }

  @action
  Future<void> exportDashboardData({String? format}) async {
    try {
      await _dashboardService.exportDashboardData(
        format: format,
        period: selectedPeriod,
      );
    } catch (e) {
      errorMessage = 'Erro ao exportar dados: $e';
    }
  }

  @action
  Future<void> refreshDashboard() async {
    try {
      isRefreshing = true;
      await Future.wait([
        loadDashboardStats(),
        loadNotifications(),
        loadChartData(),
        loadRealTimeMetrics(),
        loadAlertsAndInsights(),
      ]);
    } catch (e) {
      errorMessage = 'Erro ao atualizar dashboard: $e';
    } finally {
      isRefreshing = false;
    }
  }

  @action
  void setPeriod(String period) {
    selectedPeriod = period;
    loadDashboardStats();
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void reset() {
    stats = null;
    notifications.clear();
    chartData.clear();
    reports.clear();
    realTimeMetrics.clear();
    alertsAndInsights.clear();
    isLoading = false;
    errorMessage = null;
    selectedPeriod = 'month';
    isRefreshing = false;
  }
}

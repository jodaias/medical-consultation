import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:medical_consultation_app/features/dashboard/data/models/notification_model.dart';

@injectable
class DashboardService {
  final ApiService _apiService = getIt<ApiService>();

  // Buscar estatísticas do dashboard
  Future<DashboardStatsModel> getDashboardStats({String? period}) async {
    final queryParams = <String, dynamic>{};
    if (period != null) queryParams['period'] = period;

    final response =
        await _apiService.get('/dashboard/stats', queryParameters: queryParams);
    return DashboardStatsModel.fromJson(response.data);
  }

  // Buscar notificações
  Future<List<NotificationModel>> getNotifications(
      {int? limit, int? offset}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiService.get('/dashboard/notifications',
        queryParameters: queryParams);
    return (response.data as List)
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  // Marcar notificação como lida
  Future<void> markNotificationAsRead(String notificationId) async {
    await _apiService.put('/dashboard/notifications/$notificationId/read');
  }

  // Marcar todas as notificações como lidas
  Future<void> markAllNotificationsAsRead() async {
    await _apiService.put('/dashboard/notifications/read-all');
  }

  // Deletar notificação
  Future<void> deleteNotification(String notificationId) async {
    await _apiService.delete('/dashboard/notifications/$notificationId');
  }

  // Buscar dados para gráficos
  Future<Map<String, dynamic>> getChartData(
      {String? chartType, String? period}) async {
    final queryParams = <String, dynamic>{};
    if (chartType != null) queryParams['chartType'] = chartType;
    if (period != null) queryParams['period'] = period;

    final response = await _apiService.get('/dashboard/charts',
        queryParameters: queryParams);
    return response.data;
  }

  // Buscar relatórios
  Future<Map<String, dynamic>> getReports(
      {String? reportType, String? period}) async {
    final queryParams = <String, dynamic>{};
    if (reportType != null) queryParams['reportType'] = reportType;
    if (period != null) queryParams['period'] = period;

    final response = await _apiService.get('/dashboard/reports',
        queryParameters: queryParams);
    return response.data;
  }

  // Exportar dados do dashboard
  Future<Map<String, dynamic>> exportDashboardData(
      {String? format, String? period}) async {
    final queryParams = <String, dynamic>{};
    if (format != null) queryParams['format'] = format;
    if (period != null) queryParams['period'] = period;

    final response = await _apiService.get('/dashboard/export',
        queryParameters: queryParams);
    return response.data;
  }

  // Buscar métricas em tempo real
  Future<Map<String, dynamic>> getRealTimeMetrics() async {
    final response = await _apiService.get('/dashboard/realtime');
    return response.data;
  }

  // Buscar alertas e insights
  Future<List<Map<String, dynamic>>> getAlertsAndInsights() async {
    final response = await _apiService.get('/dashboard/alerts');
    return List<Map<String, dynamic>>.from(response.data);
  }
}

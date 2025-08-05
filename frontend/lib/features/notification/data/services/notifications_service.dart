import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/notification/data/models/notification_model.dart';

@injectable
class NotificationsService {
  final ApiService _apiService;

  NotificationsService(this._apiService);

  // Buscar notificações
  Future<List<NotificationModel>> getNotifications(
      {int? limit, int? offset}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiService.get('/dashboard/notifications',
        queryParameters: queryParams);
    final data = response.data['data'] as List;
    return data.map((json) => NotificationModel.fromJson(json)).toList();
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
    return response.data['data'];
  }
}

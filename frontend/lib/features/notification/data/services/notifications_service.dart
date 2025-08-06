import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/notification/data/models/notification_model.dart';

@injectable
class NotificationsService {
  final Rest rest;

  NotificationsService(this.rest);

  // Buscar notificações
  Future<RestResult<List<NotificationModel>>> getNotifications(
      {int? limit, int? offset}) {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    return rest.getModel<List<NotificationModel>>(
      '/dashboard/notifications',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map(
                  (e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Marcar notificação como lida
  Future<RestResult<void>> markNotificationAsRead(String notificationId) {
    return rest.putModel<void>(
      '/dashboard/notifications/$notificationId/read',
    );
  }

  // Marcar todas as notificações como lidas
  Future<RestResult<void>> markAllNotificationsAsRead() {
    return rest.putModel<void>(
      '/dashboard/notifications/read-all',
    );
  }

  // Deletar notificação
  Future<RestResult<void>> deleteNotification(String notificationId) {
    return rest.deleteModel<void>(
      '/dashboard/notifications/$notificationId',
      null,
    );
  }

  // Buscar dados para gráficos
  Future<RestResult<Map<String, dynamic>>> getChartData(
      {String? chartType, String? period}) {
    final queryParams = <String, dynamic>{};
    if (chartType != null) queryParams['chartType'] = chartType;
    if (period != null) queryParams['period'] = period;
    return rest.getModel<Map<String, dynamic>>(
      '/dashboard/charts',
      (json) => Map<String, dynamic>.from(json ?? {}),
      query: queryParams,
    );
  }
}

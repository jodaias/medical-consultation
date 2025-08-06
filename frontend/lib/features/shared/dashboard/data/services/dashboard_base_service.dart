import 'package:medical_consultation_app/core/custom_dio/rest.dart';

abstract class DashboardBaseService {
  final Rest rest;
  DashboardBaseService(this.rest);

  // Métodos comuns para todos os dashboards
  Future<RestResult<Map<String, dynamic>>> getStats({String? period}) async {
    final queryParams = <String, dynamic>{};
    if (period != null) queryParams['period'] = period;
    return await rest.getModel<Map<String, dynamic>>(
      'dashboard/stats',
      (data) => data['data'] as Map<String, dynamic>,
      query: queryParams,
    );
  }

  Future<RestResult<List<Map<String, dynamic>>>> getNotifications(
      {int? limit}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    return await rest.getList<Map<String, dynamic>>(
      'dashboard/notifications',
      (json) => json ?? <String, dynamic>{},
      query: queryParams,
    );
  }

  Future<RestResult> markNotificationAsRead(String notificationId) async {
    return await rest.putModel(
      'dashboard/notifications/$notificationId/read',
    );
  }

  Future<RestResult<Map<String, dynamic>>> getChartData(
      {String? chartType, String? period}) async {
    final queryParams = <String, dynamic>{};
    if (chartType != null) queryParams['chartType'] = chartType;
    if (period != null) queryParams['period'] = period;
    return await rest.getModel<Map<String, dynamic>>(
      'dashboard/charts',
      (data) => data['data'] as Map<String, dynamic>,
      query: queryParams,
    );
  }
}

import 'package:medical_consultation_app/core/services/api_service.dart';

abstract class DashboardBaseService {
  final ApiService _apiService = ApiService();

  // Métodos comuns para todos os dashboards
  Future<Map<String, dynamic>> getStats({String? period}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (period != null) queryParams['period'] = period;

      final response = await _apiService.get('dashboard/stats',
          queryParameters: queryParams);

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar estatísticas');
      }
    } catch (e) {
      throw Exception('Erro ao carregar estatísticas: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications({int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiService.get('dashboard/notifications',
          queryParameters: queryParams);

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar notificações');
      }
    } catch (e) {
      throw Exception('Erro ao carregar notificações: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final response =
          await _apiService.put('dashboard/notifications/$notificationId/read');

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Erro ao marcar notificação como lida');
      }
    } catch (e) {
      throw Exception('Erro ao marcar notificação como lida: $e');
    }
  }

  Future<Map<String, dynamic>> getChartData(
      {String? chartType, String? period}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (chartType != null) queryParams['chartType'] = chartType;
      if (period != null) queryParams['period'] = period;

      final response = await _apiService.get('dashboard/charts',
          queryParameters: queryParams);

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar dados do gráfico');
      }
    } catch (e) {
      throw Exception('Erro ao carregar dados do gráfico: $e');
    }
  }
}

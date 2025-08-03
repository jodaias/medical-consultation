import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

class DashboardService {
  final ApiService _apiService = ApiService();
  final AuthStore _authStore = getIt<AuthStore>();

  // Dashboard unificado baseado no tipo de usuário
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final userType = _authStore.userType;
      final userId = _authStore.userId;

      if (userType == 'DOCTOR') {
        return await _getDoctorDashboard(userId!);
      } else if (userType == 'PATIENT') {
        return await _getPatientDashboard(userId!);
      } else {
        throw Exception('Tipo de usuário não suportado');
      }
    } catch (e) {
      throw Exception('Erro ao carregar dashboard: $e');
    }
  }

  // Dashboard específico para médicos
  Future<Map<String, dynamic>> _getDoctorDashboard(String doctorId) async {
    try {
      final response =
          await _apiService.get('/users/doctors/$doctorId/dashboard');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar dashboard do médico');
      }
    } catch (e) {
      throw Exception('Erro ao carregar dashboard do médico: $e');
    }
  }

  // Dashboard específico para pacientes
  Future<Map<String, dynamic>> _getPatientDashboard(String patientId) async {
    try {
      final response =
          await _apiService.get('/users/patients/$patientId/dashboard');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ??
            'Erro ao carregar dashboard do paciente');
      }
    } catch (e) {
      throw Exception('Erro ao carregar dashboard do paciente: $e');
    }
  }

  // Estatísticas gerais
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

  // Notificações
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

  // Marcar notificação como lida
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

  // Dados para gráficos
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

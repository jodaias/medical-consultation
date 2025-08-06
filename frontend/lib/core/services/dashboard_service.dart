import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

class DashboardService {
  final Rest rest;
  DashboardService(this.rest);

  final AuthStore _authStore = getIt<AuthStore>();

  // Dashboard unificado baseado no tipo de usuário
  Future<RestResult<Map<String, dynamic>>> getDashboardData() async {
    final userType = _authStore.userType;
    final userId = _authStore.userId;
    if (userType == 'DOCTOR') {
      return await _getDoctorDashboard(userId!);
    } else if (userType == 'PATIENT') {
      return await _getPatientDashboard(userId!);
    } else {
      return RestResult<Map<String, dynamic>>()
        ..error = Exception('Tipo de usuário não suportado');
    }
  }

  // Dashboard específico para médicos
  Future<RestResult<Map<String, dynamic>>> _getDoctorDashboard(
      String doctorId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/doctors/$doctorId/dashboard',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Dashboard específico para pacientes
  Future<RestResult<Map<String, dynamic>>> _getPatientDashboard(
      String patientId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/patients/$patientId/dashboard',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Estatísticas gerais
  Future<RestResult<Map<String, dynamic>>> getStats({String? period}) async {
    final queryParams = <String, dynamic>{};
    if (period != null) queryParams['period'] = period;
    return await rest.getModel<Map<String, dynamic>>(
      '/dashboard/stats',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Notificações
  Future<RestResult<List<Map<String, dynamic>>>> getNotifications(
      {int? limit}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/dashboard/notifications',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Marcar notificação como lida
  Future<RestResult<void>> markNotificationAsRead(String notificationId) async {
    return await rest.putModel<void>(
      '/dashboard/notifications/$notificationId/read',
    );
  }

  // Dados para gráficos
  Future<RestResult<Map<String, dynamic>>> getChartData(
      {String? chartType, String? period}) async {
    final queryParams = <String, dynamic>{};
    if (chartType != null) queryParams['chartType'] = chartType;
    if (period != null) queryParams['period'] = period;
    return await rest.getModel<Map<String, dynamic>>(
      '/dashboard/charts',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }
}

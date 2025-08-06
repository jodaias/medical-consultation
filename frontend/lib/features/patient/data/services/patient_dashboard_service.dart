import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/shared/dashboard/data/services/dashboard_base_service.dart';
import 'package:medical_consultation_app/features/shared/dashboard/models/dashboard_stats_model.dart';

class PatientDashboardService extends DashboardBaseService {
  PatientDashboardService(super.rest);

  // Buscar estatísticas do dashboard (novo padrão: retorna RestResult)
  Future<RestResult<DashboardStatsModel>> getDashboardStats(
      {String? period}) async {
    final queryParams = <String, dynamic>{};
    if (period != null) queryParams['period'] = period;
    return await rest.getModel<DashboardStatsModel>(
      '/dashboard/stats',
      (data) => DashboardStatsModel.fromJson(data['data']),
      query: queryParams,
    );
  }

  // Dashboard específico para pacientes
  Future<RestResult<Map<String, dynamic>>> getPatientDashboard(
      String patientId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/patients/$patientId/dashboard',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Consultas recentes do paciente
  Future<RestResult<List<Map<String, dynamic>>>> getRecentConsultations(
      String patientId) async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/consultations/patients/$patientId/recent',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Próximas consultas do paciente
  Future<RestResult<List<Map<String, dynamic>>>> getUpcomingConsultations(
      String patientId) async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/consultations/patients/$patientId/upcoming',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Médicos favoritos
  Future<RestResult<List<Map<String, dynamic>>>> getFavoriteDoctors(
      String patientId) async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/users/patients/$patientId/favorite-doctors',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Histórico médico
  Future<RestResult<Map<String, dynamic>>> getMedicalHistory(
      String patientId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/patients/$patientId/medical-history',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Prescrições recentes
  Future<RestResult<List<Map<String, dynamic>>>> getRecentPrescriptions(
      String patientId) async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      'prescriptions/patients/$patientId/recent',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Gastos médicos
  Future<RestResult<Map<String, dynamic>>> getMedicalExpenses(
      String patientId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/patients/$patientId/expenses',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Buscar métricas em tempo real
  Future<RestResult<Map<String, dynamic>>> getRealTimeMetrics() async {
    return await rest.getModel<Map<String, dynamic>>(
      '/dashboard/realtime',
      (data) => data as Map<String, dynamic>,
    );
  }

  // Buscar alertas e insights
  Future<RestResult<List<Map<String, dynamic>>>> getAlertsAndInsights() async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/dashboard/alerts',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }
}

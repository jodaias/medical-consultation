import 'package:medical_consultation_app/features/shared/dashboard/data/services/dashboard_base_service.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';

class DoctorDashboardService extends DashboardBaseService {
  DoctorDashboardService(super.rest);

  // Dashboard específico para médicos
  Future<RestResult<Map<String, dynamic>>> getDoctorDashboard(
      String doctorId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/doctors/$doctorId/dashboard',
      (data) => data is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }

  // Estatísticas específicas do médico
  Future<RestResult<Map<String, dynamic>>> getDoctorStats(
      String doctorId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/doctors/$doctorId/stats',
      (data) => data is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }

  // Consultas próximas do médico
  Future<RestResult<List<Map<String, dynamic>>>> getUpcomingConsultations(
      String doctorId) async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/consultations/doctors/$doctorId/upcoming',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Pacientes recentes
  Future<RestResult<List<Map<String, dynamic>>>> getRecentPatients(
      String doctorId) async {
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/users/doctors/$doctorId/recent-patients',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Receita mensal
  Future<RestResult<Map<String, dynamic>>> getMonthlyRevenue(
      String doctorId) async {
    return await rest.getModel<Map<String, dynamic>>(
      '/users/doctors/$doctorId/revenue',
      (data) => data is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }

  // Avaliações do médico
  Future<RestResult<Map<String, dynamic>>> getDoctorRatings(
      String doctorId) async {
    return await rest.getModel<Map<String, dynamic>>(
      'ratings/doctors/$doctorId',
      (data) => data is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }
}

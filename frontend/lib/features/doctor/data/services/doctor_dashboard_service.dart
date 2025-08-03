import 'package:medical_consultation_app/features/shared/dashboard/data/services/dashboard_base_service.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';

class DoctorDashboardService extends DashboardBaseService {
  final ApiService _apiService = ApiService();

  // Dashboard específico para médicos
  Future<Map<String, dynamic>> getDoctorDashboard(String doctorId) async {
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

  // Estatísticas específicas do médico
  Future<Map<String, dynamic>> getDoctorStats(String doctorId) async {
    try {
      final response = await _apiService.get('/users/doctors/$doctorId/stats');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ??
            'Erro ao carregar estatísticas do médico');
      }
    } catch (e) {
      throw Exception('Erro ao carregar estatísticas do médico: $e');
    }
  }

  // Consultas próximas do médico
  Future<List<Map<String, dynamic>>> getUpcomingConsultations(
      String doctorId) async {
    try {
      final response =
          await _apiService.get('/consultations/doctors/$doctorId/upcoming');

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar consultas próximas');
      }
    } catch (e) {
      throw Exception('Erro ao carregar consultas próximas: $e');
    }
  }

  // Pacientes recentes
  Future<List<Map<String, dynamic>>> getRecentPatients(String doctorId) async {
    try {
      final response =
          await _apiService.get('/users/doctors/$doctorId/recent-patients');

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar pacientes recentes');
      }
    } catch (e) {
      throw Exception('Erro ao carregar pacientes recentes: $e');
    }
  }

  // Receita mensal
  Future<Map<String, dynamic>> getMonthlyRevenue(String doctorId) async {
    try {
      final response =
          await _apiService.get('/users/doctors/$doctorId/revenue');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao carregar receita');
      }
    } catch (e) {
      throw Exception('Erro ao carregar receita: $e');
    }
  }

  // Avaliações do médico
  Future<Map<String, dynamic>> getDoctorRatings(String doctorId) async {
    try {
      final response = await _apiService.get('ratings/doctors/$doctorId');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar avaliações');
      }
    } catch (e) {
      throw Exception('Erro ao carregar avaliações: $e');
    }
  }
}

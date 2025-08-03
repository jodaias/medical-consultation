import 'package:medical_consultation_app/features/shared/dashboard/data/services/dashboard_base_service.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';

class PatientDashboardService extends DashboardBaseService {
  final ApiService _apiService = ApiService();

  // Dashboard específico para pacientes
  Future<Map<String, dynamic>> getPatientDashboard(String patientId) async {
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

  // Consultas recentes do paciente
  Future<List<Map<String, dynamic>>> getRecentConsultations(
      String patientId) async {
    try {
      final response =
          await _apiService.get('/consultations/patients/$patientId/recent');

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar consultas recentes');
      }
    } catch (e) {
      throw Exception('Erro ao carregar consultas recentes: $e');
    }
  }

  // Próximas consultas do paciente
  Future<List<Map<String, dynamic>>> getUpcomingConsultations(
      String patientId) async {
    try {
      final response =
          await _apiService.get('/consultations/patients/$patientId/upcoming');

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar próximas consultas');
      }
    } catch (e) {
      throw Exception('Erro ao carregar próximas consultas: $e');
    }
  }

  // Médicos favoritos
  Future<List<Map<String, dynamic>>> getFavoriteDoctors(
      String patientId) async {
    try {
      final response =
          await _apiService.get('/users/patients/$patientId/favorite-doctors');

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar médicos favoritos');
      }
    } catch (e) {
      throw Exception('Erro ao carregar médicos favoritos: $e');
    }
  }

  // Histórico médico
  Future<Map<String, dynamic>> getMedicalHistory(String patientId) async {
    try {
      final response =
          await _apiService.get('/users/patients/$patientId/medical-history');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar histórico médico');
      }
    } catch (e) {
      throw Exception('Erro ao carregar histórico médico: $e');
    }
  }

  // Prescrições recentes
  Future<List<Map<String, dynamic>>> getRecentPrescriptions(
      String patientId) async {
    try {
      final response =
          await _apiService.get('prescriptions/patients/$patientId/recent');

      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ??
            'Erro ao carregar prescrições recentes');
      }
    } catch (e) {
      throw Exception('Erro ao carregar prescrições recentes: $e');
    }
  }

  // Gastos médicos
  Future<Map<String, dynamic>> getMedicalExpenses(String patientId) async {
    try {
      final response =
          await _apiService.get('/users/patients/$patientId/expenses');

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao carregar gastos médicos');
      }
    } catch (e) {
      throw Exception('Erro ao carregar gastos médicos: $e');
    }
  }
}

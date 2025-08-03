import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/consultation/data/models/consultation_model.dart';

class ConsultationService {
  final ApiService _apiService = ApiService();

  // Buscar consultas do usuário
  Future<List<ConsultationModel>> getConsultations({
    String? status,
    String? userId,
    String? userType,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (status != null) queryParams['status'] = status;
      if (userId != null) queryParams['userId'] = userId;
      if (userType != null) queryParams['userType'] = userType;

      final response =
          await _apiService.get('/consultations', queryParameters: queryParams);

      if (response.data['success'] == true) {
        final List<dynamic> consultationsData =
            response.data['data']['consultations'];
        return consultationsData
            .map((json) => ConsultationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao buscar consultas');
      }
    } catch (e) {
      throw Exception('Erro ao buscar consultas: $e');
    }
  }

  // Buscar consulta específica
  Future<ConsultationModel> getConsultation(String consultationId) async {
    try {
      final response = await _apiService.get('/consultations/$consultationId');

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao buscar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao buscar consulta: $e');
    }
  }

  // Agendar nova consulta
  Future<ConsultationModel> scheduleConsultation({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    try {
      final response = await _apiService.post('/consultations', data: {
        'doctorId': doctorId,
        'scheduledAt': scheduledAt.toIso8601String(),
        'notes': notes,
        'symptoms': symptoms,
      });

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao agendar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao agendar consulta: $e');
    }
  }

  // Atualizar consulta
  Future<ConsultationModel> updateConsultation({
    required String consultationId,
    DateTime? scheduledAt,
    String? notes,
    String? symptoms,
    String? diagnosis,
    String? prescription,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (scheduledAt != null) {
        data['scheduledAt'] = scheduledAt.toIso8601String();
      }
      if (notes != null) data['notes'] = notes;
      if (symptoms != null) data['symptoms'] = symptoms;
      if (diagnosis != null) data['diagnosis'] = diagnosis;
      if (prescription != null) data['prescription'] = prescription;

      final response =
          await _apiService.put('/consultations/$consultationId', data: data);

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao atualizar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar consulta: $e');
    }
  }

  // Cancelar consulta
  Future<void> cancelConsultation(String consultationId) async {
    try {
      final response =
          await _apiService.put('/consultations/$consultationId/cancel');

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Erro ao cancelar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao cancelar consulta: $e');
    }
  }

  // Iniciar consulta
  Future<ConsultationModel> startConsultation(String consultationId) async {
    try {
      final response =
          await _apiService.post('/consultations/$consultationId/start');

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao iniciar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao iniciar consulta: $e');
    }
  }

  // Finalizar consulta
  Future<ConsultationModel> endConsultation(String consultationId) async {
    try {
      final response =
          await _apiService.post('/consultations/$consultationId/end');

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao finalizar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao finalizar consulta: $e');
    }
  }

  // Avaliar consulta
  Future<void> rateConsultation({
    required String consultationId,
    required double rating,
    String? review,
  }) async {
    try {
      final data = {
        'rating': rating,
        if (review != null) 'review': review,
      };

      final response = await _apiService.post(
        '/consultations/$consultationId/rate',
        data: data,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Erro ao avaliar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao avaliar consulta: $e');
    }
  }

  // Buscar horários disponíveis do médico
  Future<List<DateTime>> getAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    try {
      final response = await _apiService
          .get('/schedules/doctor/$doctorId/available-slots', queryParameters: {
        'date': date.toIso8601String(),
      });

      if (response.data['success'] == true) {
        final List<dynamic> slotsData = response.data['data']['slots'];
        return slotsData.map((slot) => DateTime.parse(slot)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar horários disponíveis');
      }
    } catch (e) {
      throw Exception('Erro ao buscar horários disponíveis: $e');
    }
  }

  // Buscar médicos disponíveis
  Future<List<Map<String, dynamic>>> getAvailableDoctors({
    String? specialty,
    DateTime? date,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (specialty != null) queryParams['specialty'] = specialty;
      if (date != null) queryParams['date'] = date.toIso8601String();

      final response = await _apiService.get(
        '/consultations/doctors/available',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> doctorsData = response.data['data'];
        return doctorsData
            .map((json) => Map<String, dynamic>.from(json))
            .toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar médicos disponíveis');
      }
    } catch (e) {
      throw Exception('Erro ao buscar médicos disponíveis: $e');
    }
  }

  // Buscar estatísticas de consultas
  Future<Map<String, dynamic>> getConsultationStats({
    String? userId,
    String? userType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (userId != null) queryParams['userId'] = userId;
      if (userType != null) queryParams['userType'] = userType;
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/consultations/stats',
          queryParameters: queryParams);

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar estatísticas');
      }
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas: $e');
    }
  }

  // Marcar como não compareceu
  Future<void> markAsNoShow(String consultationId) async {
    try {
      final response =
          await _apiService.post('/consultations/$consultationId/no-show');

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Erro ao marcar como no-show');
      }
    } catch (e) {
      throw Exception('Erro ao marcar como no-show: $e');
    }
  }

  // Reagendar consulta
  Future<ConsultationModel> rescheduleConsultation({
    required String consultationId,
    required DateTime newScheduledAt,
  }) async {
    try {
      final data = {
        'newScheduledAt': newScheduledAt.toIso8601String(),
      };

      final response = await _apiService.put(
        '/consultations/$consultationId/reschedule',
        data: data,
      );

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao reagendar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao reagendar consulta: $e');
    }
  }
}

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

      final List<dynamic> consultationsData = response.data['consultations'];
      return consultationsData
          .map((json) => ConsultationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar consultas: $e');
    }
  }

  // Buscar consulta específica
  Future<ConsultationModel> getConsultation(String consultationId) async {
    try {
      final response = await _apiService.get('/consultations/$consultationId');
      return ConsultationModel.fromJson(response.data);
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

      return ConsultationModel.fromJson(response.data);
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
      if (scheduledAt != null)
        data['scheduledAt'] = scheduledAt.toIso8601String();
      if (notes != null) data['notes'] = notes;
      if (symptoms != null) data['symptoms'] = symptoms;
      if (diagnosis != null) data['diagnosis'] = diagnosis;
      if (prescription != null) data['prescription'] = prescription;

      final response =
          await _apiService.put('/consultations/$consultationId', data: data);
      return ConsultationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar consulta: $e');
    }
  }

  // Cancelar consulta
  Future<void> cancelConsultation(String consultationId) async {
    try {
      await _apiService.put('/consultations/$consultationId/cancel');
    } catch (e) {
      throw Exception('Erro ao cancelar consulta: $e');
    }
  }

  // Iniciar consulta
  Future<ConsultationModel> startConsultation(String consultationId) async {
    try {
      final response =
          await _apiService.put('/consultations/$consultationId/start');
      return ConsultationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao iniciar consulta: $e');
    }
  }

  // Finalizar consulta
  Future<ConsultationModel> endConsultation(String consultationId) async {
    try {
      final response =
          await _apiService.put('/consultations/$consultationId/end');
      return ConsultationModel.fromJson(response.data);
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
      await _apiService.post('/consultations/$consultationId/rate', data: {
        'rating': rating,
        'review': review,
      });
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
          .get('/consultations/available-slots', queryParameters: {
        'doctorId': doctorId,
        'date': date.toIso8601String(),
      });

      final List<dynamic> slotsData = response.data['slots'];
      return slotsData.map((slot) => DateTime.parse(slot)).toList();
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
      final Map<String, dynamic> queryParams = {};
      if (specialty != null) queryParams['specialty'] = specialty;
      if (date != null) queryParams['date'] = date.toIso8601String();

      final response = await _apiService.get('/consultations/available-doctors',
          queryParameters: queryParams);

      final List<dynamic> doctorsData = response.data['doctors'];
      return doctorsData.cast<Map<String, dynamic>>();
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
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/consultations/stats',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas: $e');
    }
  }

  // Marcar como não compareceu
  Future<ConsultationModel> markAsNoShow(String consultationId) async {
    try {
      final response =
          await _apiService.put('/consultations/$consultationId/no-show');
      return ConsultationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao marcar como não compareceu: $e');
    }
  }

  // Reagendar consulta
  Future<ConsultationModel> rescheduleConsultation({
    required String consultationId,
    required DateTime newScheduledAt,
  }) async {
    try {
      final response = await _apiService
          .put('/consultations/$consultationId/reschedule', data: {
        'scheduledAt': newScheduledAt.toIso8601String(),
      });

      return ConsultationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao reagendar consulta: $e');
    }
  }
}

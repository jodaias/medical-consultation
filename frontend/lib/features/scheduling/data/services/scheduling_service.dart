import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/scheduling/data/models/appointment_model.dart';
import 'package:medical_consultation_app/features/scheduling/data/models/time_slot_model.dart';

class SchedulingService {
  final ApiService _apiService;

  SchedulingService(this._apiService);

  // Buscar horários disponíveis de um médico
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String doctorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'doctorId': doctorId,
      };

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get('/scheduling/time-slots',
          queryParameters: queryParams);

      return (response.data as List)
          .map((json) => TimeSlotModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar horários disponíveis: $e');
    }
  }

  // Agendar consulta
  Future<AppointmentModel> scheduleAppointment({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    try {
      final data = {
        'doctorId': doctorId,
        'scheduledAt': scheduledAt.toIso8601String(),
        if (notes != null) 'notes': notes,
        if (symptoms != null) 'symptoms': symptoms,
      };

      final response =
          await _apiService.post('/scheduling/appointments', data: data);
      return AppointmentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao agendar consulta: $e');
    }
  }

  // Confirmar agendamento (médico)
  Future<AppointmentModel> confirmAppointment(String appointmentId) async {
    try {
      final response = await _apiService
          .put('/scheduling/appointments/$appointmentId/confirm');
      return AppointmentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao confirmar agendamento: $e');
    }
  }

  // Cancelar agendamento
  Future<void> cancelAppointment(String appointmentId, {String? reason}) async {
    try {
      final data = <String, dynamic>{};
      if (reason != null) data['reason'] = reason;

      await _apiService.put('/scheduling/appointments/$appointmentId/cancel',
          data: data);
    } catch (e) {
      throw Exception('Erro ao cancelar agendamento: $e');
    }
  }

  // Buscar agendamentos do usuário
  Future<List<AppointmentModel>> getUserAppointments({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/scheduling/appointments',
          queryParameters: queryParams);

      return (response.data as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar agendamentos: $e');
    }
  }

  // Buscar agendamentos de um médico
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'doctorId': doctorId,
      };
      if (status != null) queryParams['status'] = status;
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/scheduling/doctor/appointments',
          queryParameters: queryParams);

      return (response.data as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar agendamentos do médico: $e');
    }
  }

  // Buscar detalhes de um agendamento
  Future<AppointmentModel> getAppointmentDetails(String appointmentId) async {
    try {
      final response =
          await _apiService.get('/scheduling/appointments/$appointmentId');
      return AppointmentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar detalhes do agendamento: $e');
    }
  }

  // Atualizar agendamento
  Future<AppointmentModel> updateAppointment(
    String appointmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService
          .put('/scheduling/appointments/$appointmentId', data: data);
      return AppointmentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar agendamento: $e');
    }
  }

  // Verificar disponibilidade de horário
  Future<bool> checkTimeSlotAvailability({
    required String doctorId,
    required DateTime scheduledAt,
  }) async {
    try {
      final queryParams = {
        'doctorId': doctorId,
        'scheduledAt': scheduledAt.toIso8601String(),
      };

      final response = await _apiService.get('/scheduling/check-availability',
          queryParameters: queryParams);

      return response.data['available'] ?? false;
    } catch (e) {
      throw Exception('Erro ao verificar disponibilidade: $e');
    }
  }

  // Buscar estatísticas de agendamento
  Future<Map<String, dynamic>> getSchedulingStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/scheduling/stats',
          queryParameters: queryParams);

      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas: $e');
    }
  }
}

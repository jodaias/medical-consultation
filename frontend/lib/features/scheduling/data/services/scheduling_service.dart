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
      final queryParams = <String, dynamic>{};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
          '/schedules/doctors/$doctorId/available-slots',
          queryParameters: queryParams);

      if (response.data['success'] == true) {
        final List<dynamic> slotsData = response.data['data']['slots'];
        return slotsData.map((json) => TimeSlotModel.fromJson(json)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar horários disponíveis');
      }
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

      // Usar consultations para agendar consulta, não schedules
      final response = await _apiService.post('/consultations', data: data);

      if (response.data['success'] == true) {
        return AppointmentModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao agendar consulta');
      }
    } catch (e) {
      throw Exception('Erro ao agendar consulta: $e');
    }
  }

  // Confirmar agendamento (médico)
  Future<AppointmentModel> confirmAppointment(String appointmentId) async {
    try {
      final response =
          await _apiService.put('/schedules/$appointmentId/confirm');

      if (response.data['success'] == true) {
        return AppointmentModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao confirmar agendamento');
      }
    } catch (e) {
      throw Exception('Erro ao confirmar agendamento: $e');
    }
  }

  // Cancelar agendamento
  Future<void> cancelAppointment(String appointmentId, {String? reason}) async {
    try {
      final data = <String, dynamic>{};
      if (reason != null) data['reason'] = reason;

      final response = await _apiService
          .put('/consultations/$appointmentId/cancel', data: data);

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Erro ao cancelar agendamento');
      }
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
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response =
          await _apiService.get('/schedules', queryParameters: queryParams);

      if (response.data['success'] == true) {
        final List<dynamic> appointmentsData =
            response.data['data']['schedules'];
        return appointmentsData
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao buscar agendamentos');
      }
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
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/schedules/doctors/$doctorId',
          queryParameters: queryParams);

      if (response.data['success'] == true) {
        final List<dynamic> appointmentsData =
            response.data['data']['schedules'];
        return appointmentsData
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['message'] ??
            'Erro ao buscar agendamentos do médico');
      }
    } catch (e) {
      throw Exception('Erro ao buscar agendamentos do médico: $e');
    }
  }

  // Buscar detalhes de um agendamento
  Future<AppointmentModel> getAppointmentDetails(String appointmentId) async {
    try {
      final response = await _apiService.get('/schedules/$appointmentId');

      if (response.data['success'] == true) {
        return AppointmentModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ??
            'Erro ao buscar detalhes do agendamento');
      }
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
      final response =
          await _apiService.put('/schedules/$appointmentId', data: data);

      if (response.data['success'] == true) {
        return AppointmentModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao atualizar agendamento');
      }
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
      final data = {
        'scheduledAt': scheduledAt.toIso8601String(),
      };

      final response = await _apiService
          .post('/schedules/doctors/$doctorId/check-availability', data: data);

      if (response.data['success'] == true) {
        return response.data['data']['available'] ?? false;
      } else {
        throw Exception(
            response.data['message'] ?? 'Erro ao verificar disponibilidade');
      }
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
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _apiService.get('/schedules/stats',
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
}

import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/appointment/data/models/appointment_model.dart';
import 'package:medical_consultation_app/features/appointment/data/models/time_slot_model.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';

class DoctorAppointmentService {
  final Rest rest;
  DoctorAppointmentService(this.rest);

  // Buscar horários disponíveis de um médico (novo padrão)
  Future<RestResult<List<TimeSlotModel>>> getAvailableTimeSlots({
    required String doctorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }
    return await rest.getModel<List<TimeSlotModel>>(
      '/schedules/doctors/$doctorId/available-slots',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Agendar consulta (novo padrão)
  Future<RestResult<AppointmentModel>> scheduleAppointment({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    final data = {
      'doctorId': doctorId,
      'scheduledAt': scheduledAt.toIso8601String(),
      if (notes != null) 'notes': notes,
      if (symptoms != null) 'symptoms': symptoms,
    };
    return await rest.postModel<AppointmentModel>(
      '/consultations',
      data,
      parse: (data) => AppointmentModel.fromJson(data['data']),
    );
  }

  // Salvar agenda do médico (novo padrão)
  Future<RestResult> saveDoctorSchedule({
    required String doctorId,
    required List<Map<String, dynamic>> schedulePayload,
  }) async {
    return await rest.putModel(
      '/schedules/doctors/$doctorId/bulk',
      body: schedulePayload,
    );
  }

  // Confirmar agendamento (médico) (novo padrão)
  Future<RestResult<AppointmentModel>> confirmAppointment(
      String appointmentId) async {
    return await rest.putModel<AppointmentModel>(
      '/schedules/$appointmentId/confirm',
      parse: (data) => AppointmentModel.fromJson(data['data']),
    );
  }

  // Cancelar agendamento (novo padrão)
  Future<RestResult> cancelAppointment(String appointmentId,
      {String? reason}) async {
    final data = <String, dynamic>{};
    if (reason != null) data['reason'] = reason;
    return await rest.putModel(
      '/consultations/$appointmentId/cancel',
      body: data,
    );
  }

  // Buscar agendamentos do usuário (novo padrão)
  Future<RestResult<List<AppointmentModel>>> getUserAppointments({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    return await rest.getModel<List<AppointmentModel>>(
      '/appointments',
      (json) =>
          (json?['data']?['appointments'] as List<dynamic>?)
              ?.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Buscar detalhes de um agendamento (novo padrão)
  Future<RestResult<AppointmentModel>> getAppointmentDetails(
      String appointmentId) async {
    return await rest.getModel<AppointmentModel>(
      '/schedules/$appointmentId',
      (data) => AppointmentModel.fromJson(data['data']),
    );
  }

  // Atualizar agendamento (novo padrão)
  Future<RestResult<AppointmentModel>> updateAppointment(
    String appointmentId,
    Map<String, dynamic> data,
  ) async {
    return await rest.putModel<AppointmentModel>(
      '/schedules/$appointmentId',
      body: data,
      parse: (data) => AppointmentModel.fromJson(data['data']),
    );
  }

  // Verificar disponibilidade de horário (novo padrão)
  Future<RestResult<bool>> checkTimeSlotAvailability({
    required String doctorId,
    required DateTime scheduledAt,
  }) async {
    final data = {
      'scheduledAt': scheduledAt.toIso8601String(),
    };
    return await rest.postModel<bool>(
      '/schedules/doctors/$doctorId/check-availability',
      data,
      parse: (data) => data['data']['available'] ?? false,
    );
  }

  // Buscar estatísticas de agendamento (novo padrão)
  Future<RestResult<Map<String, dynamic>>> getSchedulingStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    return await rest.getModel<Map<String, dynamic>>(
      '/schedules/stats',
      (data) => data['data'] as Map<String, dynamic>,
      query: queryParams,
    );
  }
}

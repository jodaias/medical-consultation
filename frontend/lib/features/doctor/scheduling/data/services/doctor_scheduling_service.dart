import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';

class DoctorSchedulingService {
  final Rest rest;
  DoctorSchedulingService(this.rest);

  // Salvar agenda do médico (novo padrão)
  Future<RestResult<DoctorScheduleModel>> updateSchedule({
    required String doctorId,
    required DoctorScheduleModel schedulePayload,
  }) async {
    return await rest.putModel(
      '/schedules/${schedulePayload.id}',
      body: schedulePayload,
      parse: (json) =>
          DoctorScheduleModel.fromJson(json?['data'] as Map<String, dynamic>),
    );
  }

  // Salvar agenda do médico (novo padrão)
  Future<RestResult<List<DoctorScheduleModel>>> saveSchedules({
    required String doctorId,
    required List<DoctorScheduleModel> schedulesPayload,
  }) async {
    return await rest.putModel(
      '/schedules/doctors/$doctorId/bulk',
      body: schedulesPayload,
      parse: (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) =>
                  DoctorScheduleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Buscar agendamentos de um médico (novo padrão)
  Future<RestResult<List<DoctorScheduleModel>>> getSchedules({
    required String doctorId,
  }) async {
    final queryParams = <String, dynamic>{'doctorId': doctorId};

    return await rest.getModel<List<DoctorScheduleModel>>(
      '/schedules',
      (json) =>
          (json?['data']?['schedules'] as List<dynamic>?)
              ?.map((e) =>
                  DoctorScheduleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }
}

import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/consultation/data/models/consultation_model.dart';

class ConsultationService {
  final Rest rest;
  ConsultationService(this.rest);

  // Buscar consultas do usuário
  Future<RestResult<List<ConsultationModel>>> getConsultations({
    String? status,
    String? userId,
    String? userType,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (status != null) queryParams['status'] = status;
    if (userId != null) queryParams['userId'] = userId;
    if (userType != null) queryParams['userType'] = userType;
    return await rest.getModel<List<ConsultationModel>>(
      '/consultations',
      (json) =>
          (json?['data']?['consultations'] as List<dynamic>?)
              ?.map(
                  (e) => ConsultationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Buscar consulta específica
  Future<RestResult<ConsultationModel>> getConsultation(
      String consultationId) async {
    return await rest.getModel<ConsultationModel>(
      '/consultations/$consultationId',
      (data) => ConsultationModel.fromJson(data['data']),
    );
  }

  // Agendar nova consulta
  Future<RestResult<ConsultationModel>> scheduleConsultation({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    return await rest.postModel<ConsultationModel>(
      '/consultations',
      {
        'doctorId': doctorId,
        'scheduledAt': scheduledAt.toIso8601String(),
        'notes': notes,
        'symptoms': symptoms,
      },
      parse: (data) => ConsultationModel.fromJson(data['data']),
    );
  }

  // Atualizar consulta
  Future<RestResult<ConsultationModel>> updateConsultation({
    required String consultationId,
    DateTime? scheduledAt,
    String? notes,
    String? symptoms,
    String? diagnosis,
    String? prescription,
  }) async {
    final Map<String, dynamic> data = {};
    if (scheduledAt != null) {
      data['scheduledAt'] = scheduledAt.toIso8601String();
    }
    if (notes != null) data['notes'] = notes;
    if (symptoms != null) data['symptoms'] = symptoms;
    if (diagnosis != null) data['diagnosis'] = diagnosis;
    if (prescription != null) data['prescription'] = prescription;
    return await rest.putModel<ConsultationModel>(
      '/consultations/$consultationId',
      body: data,
      parse: (data) => ConsultationModel.fromJson(data['data']),
    );
  }

  // Cancelar consulta
  Future<RestResult> cancelConsultation(String consultationId) async {
    return await rest.putModel(
      '/consultations/$consultationId/cancel',
      body: {},
    );
  }

  // Iniciar consulta
  Future<RestResult<ConsultationModel>> startConsultation(
      String consultationId) async {
    return await rest.postModel<ConsultationModel>(
      '/consultations/$consultationId/start',
      {},
      parse: (data) => ConsultationModel.fromJson(data['data']),
    );
  }

  // Finalizar consulta
  Future<RestResult<ConsultationModel>> endConsultation(
      String consultationId) async {
    return await rest.postModel<ConsultationModel>(
      '/consultations/$consultationId/end',
      {},
      parse: (data) => ConsultationModel.fromJson(data['data']),
    );
  }

  // Avaliar consulta
  Future<RestResult> rateConsultation({
    required String consultationId,
    required double rating,
    String? review,
  }) async {
    final data = {
      'rating': rating,
      if (review != null) 'review': review,
    };
    return await rest.postModel(
      '/consultations/$consultationId/rate',
      data,
    );
  }

  // Buscar horários disponíveis do médico
  Future<RestResult<List<DateTime>>> getAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    return await rest.getModel<List<DateTime>>(
      '/schedules/doctor/$doctorId/available-slots',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((slot) => DateTime.parse(slot as String))
              .toList() ??
          [],
    );
  }

  // Buscar médicos disponíveis
  Future<RestResult<List<Map<String, dynamic>>>> getAvailableDoctors({
    String? specialty,
    DateTime? date,
  }) async {
    final queryParams = <String, dynamic>{};
    if (specialty != null) queryParams['specialty'] = specialty;
    if (date != null) queryParams['date'] = date.toIso8601String();
    return await rest.getModel<List<Map<String, dynamic>>>(
      '/consultations/doctors/available',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Buscar estatísticas de consultas
  Future<RestResult<Map<String, dynamic>>> getConsultationStats({
    String? userId,
    String? userType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (userId != null) queryParams['userId'] = userId;
    if (userType != null) queryParams['userType'] = userType;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    return await rest.getModel<Map<String, dynamic>>(
      '/consultations/stats',
      (data) => data['data'] as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Marcar como não compareceu
  Future<RestResult> markAsNoShow(String consultationId) async {
    return await rest.postModel(
      '/consultations/$consultationId/no-show',
      {},
    );
  }

  // Reagendar consulta
  Future<RestResult<ConsultationModel>> rescheduleConsultation({
    required String consultationId,
    required DateTime newScheduledAt,
  }) async {
    final data = {
      'newScheduledAt': newScheduledAt.toIso8601String(),
    };
    return await rest.putModel<ConsultationModel>(
      '/consultations/$consultationId/reschedule',
      body: data,
      parse: (data) => ConsultationModel.fromJson(data['data']),
    );
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/doctor/data/models/doctor_model.dart';
import 'package:medical_consultation_app/features/patient/data/models/patient_model.dart';

part 'consultation_model.g.dart';

@JsonSerializable()
class ConsultationModel {
  static const Object _undefined = Object();

  final String id;
  final String patientId;
  final String doctorId;
  final String status;
  final DateTime scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? notes;
  final String? symptoms;
  final String? diagnosis;
  final String? prescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? duration;

  final double? rating;
  final String? review;
  final PatientModel patient;
  final DoctorModel doctor;

  ConsultationModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.scheduledAt,
    this.startedAt,
    this.endedAt,
    this.notes,
    this.symptoms,
    this.diagnosis,
    this.prescription,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.rating,
    this.review,
    required this.patient,
    required this.doctor,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);

  ConsultationModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? status,
    DateTime? scheduledAt,
    Object? startedAt = _undefined, // use null to set to null explicitly
    Object? endedAt = _undefined,
    Object? notes = _undefined,
    Object? symptoms = _undefined,
    Object? diagnosis = _undefined,
    Object? prescription = _undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    Object? review = _undefined,
    Object? duration = _undefined,
    PatientModel? patient,
    DoctorModel? doctor,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: identical(startedAt, _undefined)
          ? this.startedAt
          : startedAt as DateTime?,
      endedAt:
          identical(endedAt, _undefined) ? this.endedAt : endedAt as DateTime?,
      notes: identical(notes, _undefined) ? this.notes : notes as String?,
      symptoms:
          identical(symptoms, _undefined) ? this.symptoms : symptoms as String?,
      rating: identical(rating, _undefined) ? this.rating : rating,
      review: identical(review, _undefined) ? this.review : review as String?,
      diagnosis: identical(diagnosis, _undefined)
          ? this.diagnosis
          : diagnosis as String?,
      prescription: identical(prescription, _undefined)
          ? this.prescription
          : prescription as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      duration:
          identical(duration, _undefined) ? this.duration : duration as int?,
      patient: patient ?? this.patient,
      doctor: doctor ?? this.doctor,
    );
  }

  /// Getters
  bool get isScheduled => status == AppConstants.scheduledStatus;
  bool get isInProgress => status == AppConstants.inProgressStatus;
  bool get isCompleted => status == AppConstants.completedStatus;
  bool get isCancelled => status == AppConstants.cancelledStatus;

  bool get canStart =>
      isScheduled &&
      DateTime.now().isAfter(scheduledAt.subtract(const Duration(minutes: 5)));
  bool get canCancel =>
      isScheduled &&
      DateTime.now().isBefore(scheduledAt.subtract(const Duration(hours: 1)));
  bool get canRate => isCompleted;

  bool get isPatient => patientId == getIt<AuthStore>().userId;
  bool get isDoctor => doctorId == getIt<AuthStore>().userId;

  String get statusText {
    switch (status) {
      case AppConstants.scheduledStatus:
        return 'Agendada';
      case AppConstants.inProgressStatus:
        return 'Em andamento';
      case AppConstants.completedStatus:
        return 'Concluída';
      case AppConstants.cancelledStatus:
        return 'Cancelada';
      case AppConstants.noShowStatus:
        return 'Não compareceu';
      default:
        return 'Desconhecido';
    }
  }

  String get formattedScheduledTime =>
      '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';

  String get formattedScheduledDate =>
      '${scheduledAt.day.toString().padLeft(2, '0')}/${scheduledAt.month.toString().padLeft(2, '0')}/${scheduledAt.year}';

  String get timeUntilConsultation {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);

    if (difference.isNegative) return 'Já passou';

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) return '$days dia${days > 1 ? 's' : ''}';
    if (hours > 0) return '$hours hora${hours > 1 ? 's' : ''}';
    return '$minutes minuto${minutes > 1 ? 's' : ''}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ConsultationModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ConsultationModel(id: $id, patient: ${patient.name}, doctor: ${doctor.name}, scheduledAt: $scheduledAt, status: $status)';
  }
}

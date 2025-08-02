import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

part 'consultation_model.g.dart';

@JsonSerializable()
class ConsultationModel {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime scheduledAt;
  final String status;
  final String? notes;
  final String? symptoms;
  final String? diagnosis;
  final String? prescription;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final double? rating;
  final String? review;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConsultationModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.scheduledAt,
    required this.status,
    this.notes,
    this.symptoms,
    this.diagnosis,
    this.prescription,
    this.startedAt,
    this.endedAt,
    this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);

  ConsultationModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    DateTime? scheduledAt,
    String? status,
    String? notes,
    String? symptoms,
    String? diagnosis,
    String? prescription,
    DateTime? startedAt,
    DateTime? endedAt,
    double? rating,
    String? review,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      prescription: prescription ?? this.prescription,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters úteis
  bool get isScheduled => status == AppConstants.scheduledStatus;
  bool get isInProgress => status == AppConstants.inProgressStatus;
  bool get isCompleted => status == AppConstants.completedStatus;
  bool get isCancelled => status == AppConstants.cancelledStatus;
  bool get isNoShow => status == AppConstants.noShowStatus;

  bool get canStart =>
      isScheduled &&
      DateTime.now().isAfter(scheduledAt.subtract(const Duration(minutes: 5)));
  bool get canCancel =>
      isScheduled &&
      DateTime.now().isBefore(scheduledAt.subtract(const Duration(hours: 1)));
  bool get canRate => isCompleted && rating == null;

  // Verificar se o usuário atual é paciente ou médico
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

  String get formattedScheduledTime {
    return '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';
  }

  String get formattedScheduledDate {
    return '${scheduledAt.day.toString().padLeft(2, '0')}/${scheduledAt.month.toString().padLeft(2, '0')}/${scheduledAt.year}';
  }

  String get timeUntilConsultation {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);

    if (difference.isNegative) {
      return 'Já passou';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return '$days dia${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours hora${hours > 1 ? 's' : ''}';
    } else {
      return '$minutes minuto${minutes > 1 ? 's' : ''}';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsultationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ConsultationModel(id: $id, patientName: $patientName, doctorName: $doctorName, scheduledAt: $scheduledAt, status: $status)';
  }
}

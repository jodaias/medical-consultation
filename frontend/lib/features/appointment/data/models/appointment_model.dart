import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable()
class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime scheduledAt;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String? notes;
  final String? symptoms;
  final double consultationFee;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
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
    required this.consultationFee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);

  AppointmentModel copyWith({
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
    double? consultationFee,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
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
      consultationFee: consultationFee ?? this.consultationFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters úteis
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';
  bool get canCancel => isPending || isConfirmed;
  bool get canConfirm => isPending;
  bool get canStart =>
      isConfirmed &&
      DateTime.now().isAfter(scheduledAt.subtract(const Duration(minutes: 5)));

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendente';
      case 'confirmed':
        return 'Confirmada';
      case 'cancelled':
        return 'Cancelada';
      case 'completed':
        return 'Concluída';
      default:
        return 'Desconhecido';
    }
  }

  String get formattedScheduledTime =>
      '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';
  String get formattedScheduledDate =>
      '${scheduledAt.day.toString().padLeft(2, '0')}/${scheduledAt.month.toString().padLeft(2, '0')}/${scheduledAt.year}';
  String get formattedFee => 'R\$ ${consultationFee.toStringAsFixed(2)}';

  String get timeUntilAppointment {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);

    if (difference.isNegative) {
      return 'Já passou';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return '$days dias, $hours horas';
    } else if (hours > 0) {
      return '$hours horas, $minutes minutos';
    } else {
      return '$minutes minutos';
    }
  }
}

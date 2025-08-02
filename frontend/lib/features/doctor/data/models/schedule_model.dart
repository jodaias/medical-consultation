import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  final String id;
  final String doctorId;
  final int dayOfWeek; // 0 = Domingo, 1 = Segunda, etc.
  final String startTime; // formato "HH:MM"
  final String endTime; // formato "HH:MM"
  final bool isAvailable;
  final int maxConsultations; // máximo de consultas por slot
  final int currentConsultations; // consultas agendadas
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleModel({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.maxConsultations = 1,
    this.currentConsultations = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  ScheduleModel copyWith({
    String? id,
    String? doctorId,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isAvailable,
    int? maxConsultations,
    int? currentConsultations,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      maxConsultations: maxConsultations ?? this.maxConsultations,
      currentConsultations: currentConsultations ?? this.currentConsultations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters úteis
  String get dayName {
    switch (dayOfWeek) {
      case 0:
        return 'Domingo';
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      default:
        return 'Desconhecido';
    }
  }

  String get timeSlot => '$startTime - $endTime';
  bool get hasAvailability => currentConsultations < maxConsultations;
  int get availableSlots => maxConsultations - currentConsultations;
}

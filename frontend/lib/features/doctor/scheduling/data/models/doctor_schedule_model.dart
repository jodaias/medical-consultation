import 'package:json_annotation/json_annotation.dart';
import 'package:medical_consultation_app/features/doctor/data/models/doctor_model.dart';

part 'doctor_schedule_model.g.dart';

@JsonSerializable()
class DoctorScheduleModel {
  final String? id;
  final String? doctorId;
  final int? consultationDuration;
  final String? dayName;
  final int? dayOfWeek;
  final int? duration;
  final String? startTime;
  final String? endTime;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DoctorModel? doctor;

  DoctorScheduleModel({
    this.id,
    this.doctorId,
    this.consultationDuration,
    this.dayName,
    this.dayOfWeek,
    this.duration,
    this.startTime,
    this.endTime,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
    this.doctor,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorScheduleModelToJson(this);

  DoctorScheduleModel copyWith({
    String? id,
    String? doctorId,
    int? consultationDuration,
    String? dayName,
    int? dayOfWeek,
    int? duration,
    String? startTime,
    String? endTime,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    DoctorModel? doctor,
  }) {
    return DoctorScheduleModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      doctor: doctor ?? this.doctor,
      dayName: dayName ?? this.dayName,
      duration: duration ?? this.duration,
    );
  }

  String get timeSlot => '$startTime - $endTime';
}

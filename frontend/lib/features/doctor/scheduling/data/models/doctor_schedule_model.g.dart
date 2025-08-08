// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorScheduleModel _$DoctorScheduleModelFromJson(Map<String, dynamic> json) =>
    DoctorScheduleModel(
      id: json['id'] as String?,
      doctorId: json['doctorId'] as String?,
      consultationDuration: (json['consultationDuration'] as num?)?.toInt(),
      dayName: json['dayName'] as String?,
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      doctor: json['doctor'] == null
          ? null
          : DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorScheduleModelToJson(
        DoctorScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorId': instance.doctorId,
      'consultationDuration': instance.consultationDuration,
      'dayName': instance.dayName,
      'dayOfWeek': instance.dayOfWeek,
      'duration': instance.duration,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'doctor': instance.doctor,
    };

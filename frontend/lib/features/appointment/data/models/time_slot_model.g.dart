// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    TimeSlotModel(
      id: json['id'] as String?,
      doctorId: json['doctorId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      duration: (json['duration'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num).toDouble(),
      maxAppointments: (json['maxAppointments'] as num?)?.toInt() ?? 1,
      currentAppointments: (json['currentAppointments'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorId': instance.doctorId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'duration': instance.duration,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'maxAppointments': instance.maxAppointments,
      'currentAppointments': instance.currentAppointments,
      'notes': instance.notes,
    };

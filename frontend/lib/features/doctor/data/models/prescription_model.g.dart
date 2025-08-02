// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrescriptionModel _$PrescriptionModelFromJson(Map<String, dynamic> json) =>
    PrescriptionModel(
      id: json['id'] as String,
      consultationId: json['consultationId'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      diagnosis: json['diagnosis'] as String,
      medications: (json['medications'] as List<dynamic>)
          .map((e) => PrescriptionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
      validUntil: DateTime.parse(json['validUntil'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PrescriptionModelToJson(PrescriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'consultationId': instance.consultationId,
      'doctorId': instance.doctorId,
      'patientId': instance.patientId,
      'diagnosis': instance.diagnosis,
      'medications': instance.medications,
      'instructions': instance.instructions,
      'notes': instance.notes,
      'validUntil': instance.validUntil.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

PrescriptionItemModel _$PrescriptionItemModelFromJson(
        Map<String, dynamic> json) =>
    PrescriptionItemModel(
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      duration: (json['duration'] as num).toInt(),
      instructions: json['instructions'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PrescriptionItemModelToJson(
        PrescriptionItemModel instance) =>
    <String, dynamic>{
      'medicationName': instance.medicationName,
      'dosage': instance.dosage,
      'frequency': instance.frequency,
      'duration': instance.duration,
      'instructions': instance.instructions,
      'quantity': instance.quantity,
    };

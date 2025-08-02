// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorProfileModel _$DoctorProfileModelFromJson(Map<String, dynamic> json) =>
    DoctorProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      crm: json['crm'] as String,
      specialty: json['specialty'] as String,
      experience: (json['experience'] as num).toInt(),
      education:
          (json['education'] as List<dynamic>).map((e) => e as String).toList(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
      consultationFee: (json['consultationFee'] as num).toDouble(),
      availability: json['availability'] as Map<String, dynamic>,
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DoctorProfileModelToJson(DoctorProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'crm': instance.crm,
      'specialty': instance.specialty,
      'experience': instance.experience,
      'education': instance.education,
      'certifications': instance.certifications,
      'bio': instance.bio,
      'consultationFee': instance.consultationFee,
      'availability': instance.availability,
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

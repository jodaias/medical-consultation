// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      bloodType: json['bloodType'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      medications: (json['medications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      conditions: (json['conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferences: json['preferences'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      specialty: json['specialty'] as String?,
      crm: json['crm'] as String?,
      crmState: json['crmState'] as String?,
      education: json['education'] as String?,
      experience: json['experience'] as String?,
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      availability: json['availability'] as Map<String, dynamic>?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalConsultations: (json['totalConsultations'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'emergencyContact': instance.emergencyContact,
      'emergencyPhone': instance.emergencyPhone,
      'bloodType': instance.bloodType,
      'allergies': instance.allergies,
      'medications': instance.medications,
      'conditions': instance.conditions,
      'preferences': instance.preferences,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'specialty': instance.specialty,
      'crm': instance.crm,
      'crmState': instance.crmState,
      'education': instance.education,
      'experience': instance.experience,
      'certifications': instance.certifications,
      'availability': instance.availability,
      'rating': instance.rating,
      'totalConsultations': instance.totalConsultations,
    };

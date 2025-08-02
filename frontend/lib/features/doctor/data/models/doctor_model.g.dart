// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      specialty: json['specialty'] as String,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      totalConsultations: (json['totalConsultations'] as num).toInt(),
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      availability: json['availability'] as Map<String, dynamic>,
      consultationPrice: (json['consultationPrice'] as num).toDouble(),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool,
      isOnline: json['isOnline'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'specialty': instance.specialty,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'totalConsultations': instance.totalConsultations,
      'yearsOfExperience': instance.yearsOfExperience,
      'certifications': instance.certifications,
      'languages': instance.languages,
      'availability': instance.availability,
      'consultationPrice': instance.consultationPrice,
      'phone': instance.phone,
      'address': instance.address,
      'isVerified': instance.isVerified,
      'isOnline': instance.isOnline,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

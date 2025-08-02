// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialtyModel _$SpecialtyModelFromJson(Map<String, dynamic> json) =>
    SpecialtyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      doctorCount: (json['doctorCount'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$SpecialtyModelToJson(SpecialtyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'doctorCount': instance.doctorCount,
      'averageRating': instance.averageRating,
      'averagePrice': instance.averagePrice,
      'isActive': instance.isActive,
    };

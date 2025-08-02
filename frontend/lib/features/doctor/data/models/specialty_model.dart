import 'package:json_annotation/json_annotation.dart';

part 'specialty_model.g.dart';

@JsonSerializable()
class SpecialtyModel {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final int doctorCount;
  final double averageRating;
  final double averagePrice;
  final bool isActive;

  SpecialtyModel({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    required this.doctorCount,
    required this.averageRating,
    required this.averagePrice,
    required this.isActive,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyModelToJson(this);

  SpecialtyModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? doctorCount,
    double? averageRating,
    double? averagePrice,
    bool? isActive,
  }) {
    return SpecialtyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      doctorCount: doctorCount ?? this.doctorCount,
      averageRating: averageRating ?? this.averageRating,
      averagePrice: averagePrice ?? this.averagePrice,
      isActive: isActive ?? this.isActive,
    );
  }
} 
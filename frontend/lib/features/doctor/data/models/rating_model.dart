import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  final String id;
  final String doctorId;
  final String patientId;
  final String patientName;
  final String? patientAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool isVerified;

  RatingModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    this.patientAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.isVerified,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);

  RatingModel copyWith({
    String? id,
    String? doctorId,
    String? patientId,
    String? patientName,
    String? patientAvatar,
    double? rating,
    String? comment,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return RatingModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientAvatar: patientAvatar ?? this.patientAvatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
} 
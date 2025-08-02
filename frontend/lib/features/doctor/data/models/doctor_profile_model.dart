import 'package:json_annotation/json_annotation.dart';

part 'doctor_profile_model.g.dart';

@JsonSerializable()
class DoctorProfileModel {
  final String id;
  final String userId;
  final String crm;
  final String specialty;
  final int experience; // anos de experiência
  final List<String> education;
  final List<String> certifications;
  final String? bio;
  final double consultationFee;
  final Map<String, dynamic> availability; // JSON com disponibilidade
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorProfileModel({
    required this.id,
    required this.userId,
    required this.crm,
    required this.specialty,
    required this.experience,
    required this.education,
    required this.certifications,
    this.bio,
    required this.consultationFee,
    required this.availability,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorProfileModelToJson(this);

  DoctorProfileModel copyWith({
    String? id,
    String? userId,
    String? crm,
    String? specialty,
    int? experience,
    List<String>? education,
    List<String>? certifications,
    String? bio,
    double? consultationFee,
    Map<String, dynamic>? availability,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      crm: crm ?? this.crm,
      specialty: specialty ?? this.specialty,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      bio: bio ?? this.bio,
      consultationFee: consultationFee ?? this.consultationFee,
      availability: availability ?? this.availability,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters úteis
  String get experienceText => '$experience anos de experiência';
  String get educationText => education.join(', ');
  String get certificationsText => certifications.join(', ');
  String get formattedFee => 'R\$ ${consultationFee.toStringAsFixed(2)}';
}

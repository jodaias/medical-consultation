import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final String? avatar;
  final String? bio;
  final double rating;
  final int totalReviews;
  final int totalConsultations;
  final int yearsOfExperience;
  final List<String> certifications;
  final List<String> languages;
  final Map<String, dynamic> availability;
  final double consultationPrice;
  final String? phone;
  final String? address;
  final bool isVerified;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    this.avatar,
    this.bio,
    required this.rating,
    required this.totalReviews,
    required this.totalConsultations,
    required this.yearsOfExperience,
    required this.certifications,
    required this.languages,
    required this.availability,
    required this.consultationPrice,
    this.phone,
    this.address,
    required this.isVerified,
    required this.isOnline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);

  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? specialty,
    String? avatar,
    String? bio,
    double? rating,
    int? totalReviews,
    int? totalConsultations,
    int? yearsOfExperience,
    List<String>? certifications,
    List<String>? languages,
    Map<String, dynamic>? availability,
    double? consultationPrice,
    String? phone,
    String? address,
    bool? isVerified,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      availability: availability ?? this.availability,
      consultationPrice: consultationPrice ?? this.consultationPrice,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 
import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final String crm;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.crm,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalConsultations = 0,
    this.yearsOfExperience = 0,
    this.certifications = const [],
    this.languages = const [],
    this.availability = const {},
    this.consultationPrice = 0.0,
    this.isVerified = false,
    this.isOnline = false,
    this.avatar,
    this.bio,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
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
    String? crm,
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
      crm: crm ?? this.crm,
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

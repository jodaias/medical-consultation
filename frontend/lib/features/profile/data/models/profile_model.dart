import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? bio;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? medications;
  final List<String>? conditions;
  final Map<String, dynamic>? preferences;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Campos específicos para médicos
  final String? specialty;
  final String? crm;
  final String? crmState;
  final String? education;
  final String? experience;
  final List<String>? certifications;
  final Map<String, dynamic>? availability;
  final double? rating;
  final int? totalConsultations;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.bio,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.emergencyContact,
    this.emergencyPhone,
    this.bloodType,
    this.allergies,
    this.medications,
    this.conditions,
    this.preferences,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    // Campos específicos para médicos
    this.specialty,
    this.crm,
    this.crmState,
    this.education,
    this.experience,
    this.certifications,
    this.availability,
    this.rating,
    this.totalConsultations,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? emergencyContact,
    String? emergencyPhone,
    String? bloodType,
    List<String>? allergies,
    List<String>? medications,
    List<String>? conditions,
    Map<String, dynamic>? preferences,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? specialty,
    String? crm,
    String? crmState,
    String? education,
    String? experience,
    List<String>? certifications,
    Map<String, dynamic>? availability,
    double? rating,
    int? totalConsultations,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      conditions: conditions ?? this.conditions,
      preferences: preferences ?? this.preferences,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialty: specialty ?? this.specialty,
      crm: crm ?? this.crm,
      crmState: crmState ?? this.crmState,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      certifications: certifications ?? this.certifications,
      availability: availability ?? this.availability,
      rating: rating ?? this.rating,
      totalConsultations: totalConsultations ?? this.totalConsultations,
    );
  }

  // Verificar se é médico
  bool get isDoctor => specialty != null && crm != null;

  // Verificar se é paciente
  bool get isPatient => specialty == null && crm == null;

  // Formatar nome completo
  String get fullName => name;

  // Formatar endereço completo
  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (zipCode != null && zipCode!.isNotEmpty) parts.add(zipCode!);
    return parts.join(', ');
  }

  // Verificar se tem informações médicas
  bool get hasMedicalInfo =>
      bloodType != null ||
      (allergies != null && allergies!.isNotEmpty) ||
      (medications != null && medications!.isNotEmpty) ||
      (conditions != null && conditions!.isNotEmpty);

  // Verificar se tem informações de emergência
  bool get hasEmergencyInfo =>
      emergencyContact != null && emergencyPhone != null;

  // Formatar especialidade e CRM para médicos
  String get doctorInfo {
    if (!isDoctor) return '';
    final parts = <String>[];
    if (specialty != null) parts.add(specialty!);
    if (crm != null) parts.add('CRM: $crm');
    if (crmState != null) parts.add('($crmState)');
    return parts.join(' ');
  }
}

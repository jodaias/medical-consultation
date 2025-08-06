import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String userType; // 'PATIENT' ou 'DOCTOR'
  final String? phone;
  final String? avatar;
  final String? specialty; // Apenas para médicos
  final String? crm; // Apenas para médicos
  final String? bio;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    this.avatar,
    this.specialty,
    this.crm,
    this.bio,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? userType,
    String? phone,
    String? avatar,
    String? specialty,
    String? crm,
    String? bio,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      specialty: specialty ?? this.specialty,
      crm: crm ?? this.crm,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters úteis
  bool get isPatient => userType == 'patient';
  bool get isDoctor => userType == 'doctor';
  String get displayName => name;
  String get displayType => isDoctor ? 'Médico' : 'Paciente';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, userType: $userType)';
  }
}

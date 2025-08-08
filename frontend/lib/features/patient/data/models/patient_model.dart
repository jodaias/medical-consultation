import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientModel {
  final String id;
  final String name;
  final String email;
  final String phone;

  PatientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}

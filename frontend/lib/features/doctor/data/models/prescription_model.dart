import 'package:json_annotation/json_annotation.dart';

part 'prescription_model.g.dart';

@JsonSerializable()
class PrescriptionModel {
  final String id;
  final String consultationId;
  final String doctorId;
  final String patientId;
  final String diagnosis;
  final List<PrescriptionItemModel> medications;
  final List<String> instructions;
  final String? notes;
  final DateTime validUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionModel({
    required this.id,
    required this.consultationId,
    required this.doctorId,
    required this.patientId,
    required this.diagnosis,
    required this.medications,
    required this.instructions,
    this.notes,
    required this.validUntil,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionModelToJson(this);

  PrescriptionModel copyWith({
    String? id,
    String? consultationId,
    String? doctorId,
    String? patientId,
    String? diagnosis,
    List<PrescriptionItemModel>? medications,
    List<String>? instructions,
    String? notes,
    DateTime? validUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      diagnosis: diagnosis ?? this.diagnosis,
      medications: medications ?? this.medications,
      instructions: instructions ?? this.instructions,
      notes: notes ?? this.notes,
      validUntil: validUntil ?? this.validUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters úteis
  bool get isValid => DateTime.now().isBefore(validUntil);
  String get validityStatus => isValid ? 'Válida' : 'Expirada';
  String get formattedValidUntil =>
      '${validUntil.day}/${validUntil.month}/${validUntil.year}';
}

@JsonSerializable()
class PrescriptionItemModel {
  final String medicationName;
  final String dosage;
  final String frequency;
  final int duration; // em dias
  final String? instructions;
  final int quantity;

  PrescriptionItemModel({
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
    required this.quantity,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionItemModelToJson(this);

  PrescriptionItemModel copyWith({
    String? medicationName,
    String? dosage,
    String? frequency,
    int? duration,
    String? instructions,
    int? quantity,
  }) {
    return PrescriptionItemModel(
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      quantity: quantity ?? this.quantity,
    );
  }

  // Getters úteis
  String get dosageText => '$medicationName - $dosage';
  String get frequencyText => '$frequency por $duration dias';
}

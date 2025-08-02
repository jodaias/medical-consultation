import 'package:json_annotation/json_annotation.dart';

part 'time_slot_model.g.dart';

@JsonSerializable()
class TimeSlotModel {
  final String id;
  final String doctorId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final int maxAppointments;
  final int currentAppointments;
  final double price;
  final String? notes;

  TimeSlotModel({
    required this.id,
    required this.doctorId,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.maxAppointments = 1,
    this.currentAppointments = 0,
    required this.price,
    this.notes,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);

  TimeSlotModel copyWith({
    String? id,
    String? doctorId,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    int? maxAppointments,
    int? currentAppointments,
    double? price,
    String? notes,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      maxAppointments: maxAppointments ?? this.maxAppointments,
      currentAppointments: currentAppointments ?? this.currentAppointments,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }

  // Getters úteis
  String get formattedStartTime =>
      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  String get formattedEndTime =>
      '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  String get timeRange => '$formattedStartTime - $formattedEndTime';
  String get formattedDate =>
      '${startTime.day.toString().padLeft(2, '0')}/${startTime.month.toString().padLeft(2, '0')}/${startTime.year}';
  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2)}';

  bool get hasAvailability => currentAppointments < maxAppointments;
  int get availableSlots => maxAppointments - currentAppointments;
  bool get isToday =>
      startTime.day == DateTime.now().day &&
      startTime.month == DateTime.now().month &&
      startTime.year == DateTime.now().year;
  bool get isPast => startTime.isBefore(DateTime.now());
  bool get isUpcoming => startTime.isAfter(DateTime.now());

  String get dayName {
    switch (startTime.weekday) {
      case 1:
        return 'Segunda';
      case 2:
        return 'Terça';
      case 3:
        return 'Quarta';
      case 4:
        return 'Quinta';
      case 5:
        return 'Sexta';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return 'Desconhecido';
    }
  }
}

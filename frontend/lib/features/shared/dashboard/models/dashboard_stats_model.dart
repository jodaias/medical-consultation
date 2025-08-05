import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel {
  final int totalConsultations;
  final int completedConsultations;
  final int pendingConsultations;
  final int cancelledConsultations;
  final double averageRating;
  final int totalPatients;
  final int totalDoctors;
  final double totalRevenue;
  final Map<String, int> consultationsByMonth;
  final Map<String, double> ratingsByMonth;
  final List<Map<String, dynamic>> recentActivity;
  final Map<String, int> specialtyDistribution;
  final Map<String, int> consultationStatusDistribution;

  DashboardStatsModel({
    required this.totalConsultations,
    required this.completedConsultations,
    required this.pendingConsultations,
    required this.cancelledConsultations,
    required this.averageRating,
    required this.totalPatients,
    required this.totalDoctors,
    required this.totalRevenue,
    required this.consultationsByMonth,
    required this.ratingsByMonth,
    required this.recentActivity,
    required this.specialtyDistribution,
    required this.consultationStatusDistribution,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  // Calculated properties
  double get completionRate => totalConsultations > 0
      ? (completedConsultations / totalConsultations) * 100
      : 0;
  double get cancellationRate => totalConsultations > 0
      ? (cancelledConsultations / totalConsultations) * 100
      : 0;
  int get activeConsultations => pendingConsultations;
  double get averageConsultationsPerMonth =>
      consultationsByMonth.values.isNotEmpty
          ? consultationsByMonth.values.reduce((a, b) => a + b) /
              consultationsByMonth.length
          : 0;
}

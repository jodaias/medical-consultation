// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      totalConsultations: (json['totalConsultations'] as num).toInt(),
      completedConsultations: (json['completedConsultations'] as num).toInt(),
      pendingConsultations: (json['pendingConsultations'] as num).toInt(),
      cancelledConsultations: (json['cancelledConsultations'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalPatients: (json['totalPatients'] as num).toInt(),
      totalDoctors: (json['totalDoctors'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      consultationsByMonth:
          Map<String, int>.from(json['consultationsByMonth'] as Map),
      ratingsByMonth: (json['ratingsByMonth'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      recentActivity: (json['recentActivity'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      specialtyDistribution:
          Map<String, int>.from(json['specialtyDistribution'] as Map),
      consultationStatusDistribution:
          Map<String, int>.from(json['consultationStatusDistribution'] as Map),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
        DashboardStatsModel instance) =>
    <String, dynamic>{
      'totalConsultations': instance.totalConsultations,
      'completedConsultations': instance.completedConsultations,
      'pendingConsultations': instance.pendingConsultations,
      'cancelledConsultations': instance.cancelledConsultations,
      'averageRating': instance.averageRating,
      'totalPatients': instance.totalPatients,
      'totalDoctors': instance.totalDoctors,
      'totalRevenue': instance.totalRevenue,
      'consultationsByMonth': instance.consultationsByMonth,
      'ratingsByMonth': instance.ratingsByMonth,
      'recentActivity': instance.recentActivity,
      'specialtyDistribution': instance.specialtyDistribution,
      'consultationStatusDistribution': instance.consultationStatusDistribution,
    };

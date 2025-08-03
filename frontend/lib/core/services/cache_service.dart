import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _consultationsKey = 'consultations_cache';
  static const String _doctorStatsKey = 'doctor_stats_cache';
  static const String _patientStatsKey = 'patient_stats_cache';
  static const String _lastUpdateKey = 'last_update_cache';

  static const Duration _cacheExpiration = Duration(hours: 1);

  // Cache de consultas
  static Future<void> cacheConsultations(
      String userId, List<Map<String, dynamic>> consultations) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'userId': userId,
      'data': consultations,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_consultationsKey, jsonEncode(cacheData));
  }

  static Future<List<Map<String, dynamic>>?> getCachedConsultations(
      String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_consultationsKey);

    if (cached != null) {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;

      // Verificar se é do mesmo usuário
      if (cacheData['userId'] == userId) {
        final timestamp = cacheData['timestamp'] as int;
        final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);

        // Verificar se o cache ainda é válido
        if (DateTime.now().difference(lastUpdate) < _cacheExpiration) {
          return List<Map<String, dynamic>>.from(cacheData['data']);
        }
      }
    }

    return null;
  }

  // Cache de estatísticas do médico
  static Future<void> cacheDoctorStats(
      String doctorId, Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'doctorId': doctorId,
      'data': stats,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_doctorStatsKey, jsonEncode(cacheData));
  }

  static Future<Map<String, dynamic>?> getCachedDoctorStats(
      String doctorId) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_doctorStatsKey);

    if (cached != null) {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;

      if (cacheData['doctorId'] == doctorId) {
        final timestamp = cacheData['timestamp'] as int;
        final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);

        if (DateTime.now().difference(lastUpdate) < _cacheExpiration) {
          return Map<String, dynamic>.from(cacheData['data']);
        }
      }
    }

    return null;
  }

  // Cache de estatísticas do paciente
  static Future<void> cachePatientStats(
      String patientId, Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'patientId': patientId,
      'data': stats,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_patientStatsKey, jsonEncode(cacheData));
  }

  static Future<Map<String, dynamic>?> getCachedPatientStats(
      String patientId) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_patientStatsKey);

    if (cached != null) {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;

      if (cacheData['patientId'] == patientId) {
        final timestamp = cacheData['timestamp'] as int;
        final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);

        if (DateTime.now().difference(lastUpdate) < _cacheExpiration) {
          return Map<String, dynamic>.from(cacheData['data']);
        }
      }
    }

    return null;
  }

  // Limpar cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_consultationsKey);
    await prefs.remove(_doctorStatsKey);
    await prefs.remove(_patientStatsKey);
    await prefs.remove(_lastUpdateKey);
  }

  // Verificar se há dados em cache
  static Future<bool> hasCachedData(String userId) async {
    final consultations = await getCachedConsultations(userId);
    final stats = await getCachedDoctorStats(userId);
    return consultations != null || stats != null;
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@injectable
class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _userTypeKey = 'user_type';
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _userIdKey = 'user_id';

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  // User Data Management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs.setString(_userDataKey, jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = _prefs.getString(_userDataKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveUserType(String userType) async {
    await _prefs.setString(_userTypeKey, userType);
  }

  Future<String?> getUserType() async {
    return _prefs.getString(_userTypeKey);
  }

  // Authentication State
  Future<void> setAuthenticated(bool isAuthenticated) async {
    await _prefs.setBool(_isAuthenticatedKey, isAuthenticated);
  }

  Future<bool> isAuthenticated() async {
    return _prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  // FCM Token Management
  Future<void> saveFCMToken(String token) async {
    await _prefs.setString(_fcmTokenKey, token);
  }

  Future<String?> getFCMToken() async {
    return _prefs.getString(_fcmTokenKey);
  }

  // User ID Management
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userDataKey);
    await _prefs.remove(_userTypeKey);
    await _prefs.remove(_isAuthenticatedKey);
    await _prefs.remove(_fcmTokenKey);
    await _prefs.remove(_userIdKey);
  }

  // Check if token is expired
  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);

      final exp = payloadMap['exp'];
      if (exp == null) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  /// Retorna a data de expiração do token JWT salvo, ou null se não houver token válido.
  Future<DateTime?> getTokenExpiration() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      final exp = payloadMap['exp'];
      if (exp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null;
    }
  }
}

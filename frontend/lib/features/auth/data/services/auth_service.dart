import 'package:medical_consultation_app/core/custom_dio/rest.dart';

class AuthService {
  final Rest rest;

  AuthService(this.rest);

  Future<RestResult<dynamic>> login(String email, String password) async {
    return await rest.postModel('/users/login', {
      'email': email,
      'password': password,
    });
  }

  Future<RestResult<dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String userType,
    String? specialty,
    String? crm,
    String? bio,
    double? hourlyRate,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'userType': userType,
    };
    if (userType == 'DOCTOR') {
      if (specialty != null) data['specialty'] = specialty;
      if (crm != null) data['crm'] = crm;
      if (bio != null) data['bio'] = bio;
      if (hourlyRate != null) data['hourlyRate'] = hourlyRate.toString();
    }
    return await rest.postModel('/users/register', data);
  }

  Future<RestResult<dynamic>> logout() async {
    return await rest.postModel('/users/logout', {});
  }

  Future<RestResult<dynamic>> refreshToken(String refreshToken) async {
    return await rest.postModel('/users/refresh', {
      'refreshToken': refreshToken,
    });
  }

  Future<RestResult<dynamic>> forgotPassword(String email) async {
    return await rest.postModel('/users/forgot-password', {
      'email': email,
    });
  }

  Future<RestResult<dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await rest.postModel('/users/reset-password', {
      'token': token,
      'newPassword': newPassword,
    });
  }

  Future<RestResult<dynamic>> getUserProfile() async {
    return await rest.getModel('/users/profile', (data) => data);
  }

  Future<RestResult<dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    return await rest.putModel('/users/profile', body: data);
  }

  Future<RestResult<dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await rest.postModel('/users/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  Future<RestResult<dynamic>> validateToken() async {
    return await rest.getModel('/users/validate', (data) => data);
  }
}

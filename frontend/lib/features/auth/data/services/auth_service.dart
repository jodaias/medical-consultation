import 'package:dio/dio.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/users/login', data: {
        'email': email,
        'password': password,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
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
    try {
      print('🔍 AuthService.register iniciado');
      final data = {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'userType': userType,
      };

      // Adicionar campos específicos para médicos
      if (userType == 'DOCTOR') {
        if (specialty != null) data['specialty'] = specialty;
        if (crm != null) data['crm'] = crm;
        if (bio != null) data['bio'] = bio;
        if (hourlyRate != null) data['hourlyRate'] = hourlyRate.toString();
      }

      print('🔍 Dados enviados: $data');
      final response = await _apiService.post('/users/register', data: data);
      print('🔍 Resposta da API: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('❌ AuthService.register erro DioException: $e');
      throw _handleDioError(e);
    } catch (e) {
      print('❌ AuthService.register erro geral: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post('/users/logout');
    } on DioException {
      // Não lançar erro no logout, apenas logar
      print('Logout completed');
    }
  }

  // Refresh Token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _apiService.post('/users/refresh', data: {
        'refreshToken': refreshToken,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post('/users/forgot-password', data: {
        'email': email,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiService.post('/users/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Get User Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get('/users/profile');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Update User Profile
  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/users/profile', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.post('/users/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Verificar se o token é válido
  Future<bool> validateToken() async {
    try {
      await _apiService.get('/users/validate');
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return false;
      }
      throw _handleDioError(e);
    }
  }

  // Tratamento de erros do Dio
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(AppConstants.networkError);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? AppConstants.unknownError;

        switch (statusCode) {
          case 401:
            return UnauthorizedException(AppConstants.sessionExpired);
          case 403:
            return ForbiddenException(message);
          case 404:
            return NotFoundException(message);
          case 422:
            return ValidationException(message);
          case 500:
            return ServerException(AppConstants.serverError);
          default:
            return ApiException(message);
        }
      case DioExceptionType.cancel:
        return ApiException('Requisição cancelada');
      default:
        return ApiException(AppConstants.networkError);
    }
  }
}

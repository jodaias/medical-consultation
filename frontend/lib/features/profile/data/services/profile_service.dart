import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/profile/data/models/profile_model.dart';

@injectable
class ProfileService {
  final ApiService _apiService = getIt<ApiService>();

  // Buscar perfil do usuário atual
  Future<ProfileModel> getProfile() async {
    final response = await _apiService.get('/profile');
    return ProfileModel.fromJson(response.data);
  }

  // Atualizar perfil básico
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.put('/profile', data: data);
    return ProfileModel.fromJson(response.data);
  }

  // Atualizar informações médicas (para pacientes)
  Future<ProfileModel> updateMedicalInfo(Map<String, dynamic> data) async {
    final response = await _apiService.put('/profile/medical', data: data);
    return ProfileModel.fromJson(response.data);
  }

  // Atualizar informações profissionais (para médicos)
  Future<ProfileModel> updateProfessionalInfo(Map<String, dynamic> data) async {
    final response = await _apiService.put('/profile/professional', data: data);
    return ProfileModel.fromJson(response.data);
  }

  // Upload de avatar
  Future<String> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });

    final response = await _apiService.post('/profile/avatar', data: formData);
    return response.data['avatarUrl'];
  }

  // Deletar avatar
  Future<void> deleteAvatar() async {
    await _apiService.delete('/profile/avatar');
  }

  // Atualizar configurações de notificação
  Future<Map<String, dynamic>> updateNotificationSettings(
      Map<String, dynamic> settings) async {
    final response =
        await _apiService.put('/profile/notifications', data: settings);
    return response.data;
  }

  // Buscar configurações de notificação
  Future<Map<String, dynamic>> getNotificationSettings() async {
    final response = await _apiService.get('/profile/notifications');
    return response.data;
  }

  // Atualizar configurações de privacidade
  Future<Map<String, dynamic>> updatePrivacySettings(
      Map<String, dynamic> settings) async {
    final response = await _apiService.put('/profile/privacy', data: settings);
    return response.data;
  }

  // Buscar configurações de privacidade
  Future<Map<String, dynamic>> getPrivacySettings() async {
    final response = await _apiService.get('/profile/privacy');
    return response.data;
  }

  // Alterar senha
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await _apiService.put('/profile/password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // Solicitar exclusão de conta
  Future<void> requestAccountDeletion(String reason) async {
    await _apiService.post('/profile/deletion-request', data: {
      'reason': reason,
    });
  }

  // Exportar dados do usuário
  Future<Map<String, dynamic>> exportUserData() async {
    final response = await _apiService.get('/profile/export');
    return response.data;
  }

  // Buscar histórico de atividades
  Future<List<Map<String, dynamic>>> getActivityHistory(
      {int? limit, int? offset}) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final response = await _apiService.get('/profile/activity',
        queryParameters: queryParams);
    return List<Map<String, dynamic>>.from(response.data);
  }

  // Buscar estatísticas do usuário
  Future<Map<String, dynamic>> getUserStats() async {
    final response = await _apiService.get('/profile/stats');
    return response.data;
  }
}

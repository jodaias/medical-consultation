import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/features/profile/data/models/profile_model.dart';

@injectable
class ProfileService {
  final Rest rest;

  ProfileService(this.rest);

  // Buscar perfil do usuário atual
  Future<RestResult<ProfileModel>> getProfile() {
    return rest.getModel<ProfileModel>(
      '/profile',
      (json) => ProfileModel.fromJson(json ?? {}),
    );
  }

  // Atualizar perfil básico
  Future<RestResult<ProfileModel>> updateProfile(Map<String, dynamic> data) {
    return rest.putModel<ProfileModel>(
      '/profile',
      body: data,
      parse: (json) => ProfileModel.fromJson(json ?? {}),
    );
  }

  // Atualizar informações médicas (para pacientes)
  Future<RestResult<ProfileModel>> updateMedicalInfo(
      Map<String, dynamic> data) {
    return rest.putModel<ProfileModel>(
      '/profile/medical',
      body: data,
      parse: (json) => ProfileModel.fromJson(json ?? {}),
    );
  }

  // Atualizar informações profissionais (para médicos)
  Future<RestResult<ProfileModel>> updateProfessionalInfo(
      Map<String, dynamic> data) {
    return rest.putModel<ProfileModel>(
      '/profile/professional',
      body: data,
      parse: (json) => ProfileModel.fromJson(json ?? {}),
    );
  }

  // Upload de avatar
  Future<RestResult<String>> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    return rest.postModel<String>(
      '/profile/avatar',
      formData,
      parse: (json) => json['avatarUrl'] as String,
    );
  }

  // Deletar avatar
  Future<RestResult<void>> deleteAvatar() {
    return rest.deleteModel<void>('/profile/avatar', null);
  }

  // Atualizar configurações de notificação
  Future<RestResult<Map<String, dynamic>>> updateNotificationSettings(
      Map<String, dynamic> settings) {
    return rest.putModel<Map<String, dynamic>>(
      '/profile/notifications',
      body: settings,
      parse: (json) => Map<String, dynamic>.from(json ?? {}),
    );
  }

  // Buscar configurações de notificação
  Future<RestResult<Map<String, dynamic>>> getNotificationSettings() {
    return rest.getModel<Map<String, dynamic>>(
      '/profile/notifications',
      (json) => Map<String, dynamic>.from(json ?? {}),
    );
  }

  // Atualizar configurações de privacidade
  Future<RestResult<Map<String, dynamic>>> updatePrivacySettings(
      Map<String, dynamic> settings) {
    return rest.putModel<Map<String, dynamic>>(
      '/profile/privacy',
      body: settings,
      parse: (json) => Map<String, dynamic>.from(json ?? {}),
    );
  }

  // Buscar configurações de privacidade
  Future<RestResult<Map<String, dynamic>>> getPrivacySettings() {
    return rest.getModel<Map<String, dynamic>>(
      '/profile/privacy',
      (json) => Map<String, dynamic>.from(json ?? {}),
    );
  }

  // Alterar senha
  Future<RestResult<void>> changePassword(
      String currentPassword, String newPassword) {
    return rest.putModel<void>(
      '/profile/password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  // Solicitar exclusão de conta
  Future<RestResult<void>> requestAccountDeletion(String reason) {
    return rest.postModel<void>(
      '/profile/deletion-request',
      {'reason': reason},
    );
  }

  // Exportar dados do usuário
  Future<RestResult<Map<String, dynamic>>> exportUserData() {
    return rest.getModel<Map<String, dynamic>>(
      '/profile/export',
      (json) => Map<String, dynamic>.from(json ?? {}),
    );
  }

  // Buscar histórico de atividades
  Future<RestResult<List<Map<String, dynamic>>>> getActivityHistory(
      {int? limit, int? offset}) {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;
    return rest.getModel<List<Map<String, dynamic>>>(
      '/profile/activity',
      (json) =>
          (json?['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      query: queryParams,
    );
  }

  // Buscar estatísticas do usuário
  Future<RestResult<Map<String, dynamic>>> getUserStats() {
    return rest.getModel<Map<String, dynamic>>(
      '/profile/stats',
      (json) => Map<String, dynamic>.from(json ?? {}),
    );
  }
}

import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/profile/data/models/profile_model.dart';
import 'package:medical_consultation_app/features/profile/data/services/profile_service.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

part 'profile_store.g.dart';

@injectable
class ProfileStore = ProfileStoreBase with _$ProfileStore;

abstract class ProfileStoreBase with Store {
  final _profileService = getIt<ProfileService>();

  @observable
  ProfileModel? profile;

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  String? errorMessage;

  @observable
  Map<String, dynamic> notificationSettings = {};

  @observable
  Map<String, dynamic> privacySettings = {};

  @observable
  List<Map<String, dynamic>> activityHistory = [];

  @observable
  Map<String, dynamic> userStats = {};

  @observable
  RequestStatusEnum updateStatus = RequestStatusEnum.none;

  @observable
  RequestStatusEnum uploadAvatarStatus = RequestStatusEnum.none;

  // Computed
  @computed
  bool get hasProfile => profile != null;

  @computed
  bool get isDoctor => profile?.isDoctor ?? false;

  @computed
  bool get isPatient => profile?.isPatient ?? false;

  @computed
  String get displayName => profile?.fullName ?? '';

  @computed
  String get displayEmail => profile?.email ?? '';

  @computed
  String? get avatarUrl => profile?.avatar;

  @computed
  bool get hasMedicalInfo => profile?.hasMedicalInfo ?? false;

  @computed
  bool get hasEmergencyInfo => profile?.hasEmergencyInfo ?? false;

  // Actions
  @action
  Future<void> loadProfile() async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.getProfile();
    if (result.success) {
      profile = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao carregar perfil: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updateProfile(Map<String, dynamic> data) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.updateProfile(data);
    if (result.success) {
      profile = result.data;
      updateStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao atualizar perfil: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updateMedicalInfo(Map<String, dynamic> data) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.updateMedicalInfo(data);
    if (result.success) {
      profile = result.data;
      updateStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao atualizar informações médicas: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updateProfessionalInfo(Map<String, dynamic> data) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.updateProfessionalInfo(data);
    if (result.success) {
      profile = result.data;
      updateStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao atualizar informações profissionais: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> uploadAvatar(String filePath) async {
    uploadAvatarStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.uploadAvatar(filePath);
    if (result.success) {
      profile = profile?.copyWith(avatar: result.data);
      uploadAvatarStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao fazer upload do avatar: ${result.error?.toString() ?? ''}';
      uploadAvatarStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> deleteAvatar() async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.deleteAvatar();
    if (result.success) {
      profile = profile?.copyWith(avatar: null);
      updateStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao deletar avatar: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadNotificationSettings() async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.getNotificationSettings();
    if (result.success) {
      notificationSettings = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao carregar configurações de notificação: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.updateNotificationSettings(settings);
    if (result.success) {
      notificationSettings = result.data;
      updateStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao atualizar configurações de notificação: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadPrivacySettings() async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.getPrivacySettings();
    if (result.success) {
      privacySettings = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao carregar configurações de privacidade: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.updatePrivacySettings(settings);
    if (result.success) {
      privacySettings = result.data;
      updateStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao atualizar configurações de privacidade: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result =
        await _profileService.changePassword(currentPassword, newPassword);
    if (!result.success) {
      errorMessage = 'Erro ao alterar senha: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    } else {
      updateStatus = RequestStatusEnum.success;
    }
  }

  @action
  Future<void> requestAccountDeletion(String reason) async {
    updateStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.requestAccountDeletion(reason);
    if (!result.success) {
      errorMessage =
          'Erro ao solicitar exclusão de conta: ${result.error?.toString() ?? ''}';
      updateStatus = RequestStatusEnum.fail;
    } else {
      updateStatus = RequestStatusEnum.success;
    }
  }

  @action
  Future<void> loadActivityHistory({int? limit, int? offset}) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result =
        await _profileService.getActivityHistory(limit: limit, offset: offset);
    if (result.success) {
      activityHistory = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao carregar histórico de atividades: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadUserStats() async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.getUserStats();
    if (result.success) {
      userStats = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao carregar estatísticas: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<Map<String, dynamic>> exportUserData() async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _profileService.exportUserData();
    requestStatus = RequestStatusEnum.none;
    if (result.success) {
      return result.data;
    } else {
      errorMessage =
          'Erro ao exportar dados: ${result.error?.toString() ?? ''}';
      throw Exception(errorMessage);
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void reset() {
    profile = null;
    requestStatus = RequestStatusEnum.none;
    errorMessage = null;
    notificationSettings = {};
    privacySettings = {};
    activityHistory = [];
    userStats = {};
    updateStatus = RequestStatusEnum.none;
    uploadAvatarStatus = RequestStatusEnum.none;
  }
}

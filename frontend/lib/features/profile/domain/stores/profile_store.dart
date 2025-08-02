import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/profile/data/models/profile_model.dart';
import 'package:medical_consultation_app/features/profile/data/services/profile_service.dart';

part 'profile_store.g.dart';

@injectable
class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final ProfileService _profileService = ProfileService();

  @observable
  ProfileModel? profile;

  @observable
  bool isLoading = false;

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
  bool isUpdating = false;

  @observable
  bool isUploadingAvatar = false;

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
    try {
      isLoading = true;
      errorMessage = null;
      profile = await _profileService.getProfile();
    } catch (e) {
      errorMessage = 'Erro ao carregar perfil: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isUpdating = true;
      errorMessage = null;
      profile = await _profileService.updateProfile(data);
    } catch (e) {
      errorMessage = 'Erro ao atualizar perfil: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> updateMedicalInfo(Map<String, dynamic> data) async {
    try {
      isUpdating = true;
      errorMessage = null;
      profile = await _profileService.updateMedicalInfo(data);
    } catch (e) {
      errorMessage = 'Erro ao atualizar informações médicas: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> updateProfessionalInfo(Map<String, dynamic> data) async {
    try {
      isUpdating = true;
      errorMessage = null;
      profile = await _profileService.updateProfessionalInfo(data);
    } catch (e) {
      errorMessage = 'Erro ao atualizar informações profissionais: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> uploadAvatar(String filePath) async {
    try {
      isUploadingAvatar = true;
      errorMessage = null;
      final avatarUrl = await _profileService.uploadAvatar(filePath);
      profile = profile?.copyWith(avatar: avatarUrl);
    } catch (e) {
      errorMessage = 'Erro ao fazer upload do avatar: $e';
    } finally {
      isUploadingAvatar = false;
    }
  }

  @action
  Future<void> deleteAvatar() async {
    try {
      isUpdating = true;
      errorMessage = null;
      await _profileService.deleteAvatar();
      profile = profile?.copyWith(avatar: null);
    } catch (e) {
      errorMessage = 'Erro ao deletar avatar: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> loadNotificationSettings() async {
    try {
      isLoading = true;
      errorMessage = null;
      notificationSettings = await _profileService.getNotificationSettings();
    } catch (e) {
      errorMessage = 'Erro ao carregar configurações de notificação: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      isUpdating = true;
      errorMessage = null;
      notificationSettings =
          await _profileService.updateNotificationSettings(settings);
    } catch (e) {
      errorMessage = 'Erro ao atualizar configurações de notificação: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> loadPrivacySettings() async {
    try {
      isLoading = true;
      errorMessage = null;
      privacySettings = await _profileService.getPrivacySettings();
    } catch (e) {
      errorMessage = 'Erro ao carregar configurações de privacidade: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    try {
      isUpdating = true;
      errorMessage = null;
      privacySettings = await _profileService.updatePrivacySettings(settings);
    } catch (e) {
      errorMessage = 'Erro ao atualizar configurações de privacidade: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      isUpdating = true;
      errorMessage = null;
      await _profileService.changePassword(currentPassword, newPassword);
    } catch (e) {
      errorMessage = 'Erro ao alterar senha: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> requestAccountDeletion(String reason) async {
    try {
      isUpdating = true;
      errorMessage = null;
      await _profileService.requestAccountDeletion(reason);
    } catch (e) {
      errorMessage = 'Erro ao solicitar exclusão de conta: $e';
    } finally {
      isUpdating = false;
    }
  }

  @action
  Future<void> loadActivityHistory({int? limit, int? offset}) async {
    try {
      isLoading = true;
      errorMessage = null;
      activityHistory = await _profileService.getActivityHistory(
          limit: limit, offset: offset);
    } catch (e) {
      errorMessage = 'Erro ao carregar histórico de atividades: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadUserStats() async {
    try {
      isLoading = true;
      errorMessage = null;
      userStats = await _profileService.getUserStats();
    } catch (e) {
      errorMessage = 'Erro ao carregar estatísticas: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<Map<String, dynamic>> exportUserData() async {
    try {
      isLoading = true;
      errorMessage = null;
      return await _profileService.exportUserData();
    } catch (e) {
      errorMessage = 'Erro ao exportar dados: $e';
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void reset() {
    profile = null;
    isLoading = false;
    errorMessage = null;
    notificationSettings = {};
    privacySettings = {};
    activityHistory = [];
    userStats = {};
    isUpdating = false;
    isUploadingAvatar = false;
  }
}

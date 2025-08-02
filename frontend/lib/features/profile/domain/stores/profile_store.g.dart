// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  Computed<bool>? _$hasProfileComputed;

  @override
  bool get hasProfile =>
      (_$hasProfileComputed ??= Computed<bool>(() => super.hasProfile,
              name: '_ProfileStore.hasProfile'))
          .value;
  Computed<bool>? _$isDoctorComputed;

  @override
  bool get isDoctor => (_$isDoctorComputed ??=
          Computed<bool>(() => super.isDoctor, name: '_ProfileStore.isDoctor'))
      .value;
  Computed<bool>? _$isPatientComputed;

  @override
  bool get isPatient =>
      (_$isPatientComputed ??= Computed<bool>(() => super.isPatient,
              name: '_ProfileStore.isPatient'))
          .value;
  Computed<String>? _$displayNameComputed;

  @override
  String get displayName =>
      (_$displayNameComputed ??= Computed<String>(() => super.displayName,
              name: '_ProfileStore.displayName'))
          .value;
  Computed<String>? _$displayEmailComputed;

  @override
  String get displayEmail =>
      (_$displayEmailComputed ??= Computed<String>(() => super.displayEmail,
              name: '_ProfileStore.displayEmail'))
          .value;
  Computed<String?>? _$avatarUrlComputed;

  @override
  String? get avatarUrl =>
      (_$avatarUrlComputed ??= Computed<String?>(() => super.avatarUrl,
              name: '_ProfileStore.avatarUrl'))
          .value;
  Computed<bool>? _$hasMedicalInfoComputed;

  @override
  bool get hasMedicalInfo =>
      (_$hasMedicalInfoComputed ??= Computed<bool>(() => super.hasMedicalInfo,
              name: '_ProfileStore.hasMedicalInfo'))
          .value;
  Computed<bool>? _$hasEmergencyInfoComputed;

  @override
  bool get hasEmergencyInfo => (_$hasEmergencyInfoComputed ??= Computed<bool>(
          () => super.hasEmergencyInfo,
          name: '_ProfileStore.hasEmergencyInfo'))
      .value;

  late final _$profileAtom =
      Atom(name: '_ProfileStore.profile', context: context);

  @override
  ProfileModel? get profile {
    _$profileAtom.reportRead();
    return super.profile;
  }

  @override
  set profile(ProfileModel? value) {
    _$profileAtom.reportWrite(value, super.profile, () {
      super.profile = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ProfileStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ProfileStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$notificationSettingsAtom =
      Atom(name: '_ProfileStore.notificationSettings', context: context);

  @override
  Map<String, dynamic> get notificationSettings {
    _$notificationSettingsAtom.reportRead();
    return super.notificationSettings;
  }

  @override
  set notificationSettings(Map<String, dynamic> value) {
    _$notificationSettingsAtom.reportWrite(value, super.notificationSettings,
        () {
      super.notificationSettings = value;
    });
  }

  late final _$privacySettingsAtom =
      Atom(name: '_ProfileStore.privacySettings', context: context);

  @override
  Map<String, dynamic> get privacySettings {
    _$privacySettingsAtom.reportRead();
    return super.privacySettings;
  }

  @override
  set privacySettings(Map<String, dynamic> value) {
    _$privacySettingsAtom.reportWrite(value, super.privacySettings, () {
      super.privacySettings = value;
    });
  }

  late final _$activityHistoryAtom =
      Atom(name: '_ProfileStore.activityHistory', context: context);

  @override
  List<Map<String, dynamic>> get activityHistory {
    _$activityHistoryAtom.reportRead();
    return super.activityHistory;
  }

  @override
  set activityHistory(List<Map<String, dynamic>> value) {
    _$activityHistoryAtom.reportWrite(value, super.activityHistory, () {
      super.activityHistory = value;
    });
  }

  late final _$userStatsAtom =
      Atom(name: '_ProfileStore.userStats', context: context);

  @override
  Map<String, dynamic> get userStats {
    _$userStatsAtom.reportRead();
    return super.userStats;
  }

  @override
  set userStats(Map<String, dynamic> value) {
    _$userStatsAtom.reportWrite(value, super.userStats, () {
      super.userStats = value;
    });
  }

  late final _$isUpdatingAtom =
      Atom(name: '_ProfileStore.isUpdating', context: context);

  @override
  bool get isUpdating {
    _$isUpdatingAtom.reportRead();
    return super.isUpdating;
  }

  @override
  set isUpdating(bool value) {
    _$isUpdatingAtom.reportWrite(value, super.isUpdating, () {
      super.isUpdating = value;
    });
  }

  late final _$isUploadingAvatarAtom =
      Atom(name: '_ProfileStore.isUploadingAvatar', context: context);

  @override
  bool get isUploadingAvatar {
    _$isUploadingAvatarAtom.reportRead();
    return super.isUploadingAvatar;
  }

  @override
  set isUploadingAvatar(bool value) {
    _$isUploadingAvatarAtom.reportWrite(value, super.isUploadingAvatar, () {
      super.isUploadingAvatar = value;
    });
  }

  late final _$loadProfileAsyncAction =
      AsyncAction('_ProfileStore.loadProfile', context: context);

  @override
  Future<void> loadProfile() {
    return _$loadProfileAsyncAction.run(() => super.loadProfile());
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_ProfileStore.updateProfile', context: context);

  @override
  Future<void> updateProfile(Map<String, dynamic> data) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(data));
  }

  late final _$updateMedicalInfoAsyncAction =
      AsyncAction('_ProfileStore.updateMedicalInfo', context: context);

  @override
  Future<void> updateMedicalInfo(Map<String, dynamic> data) {
    return _$updateMedicalInfoAsyncAction
        .run(() => super.updateMedicalInfo(data));
  }

  late final _$updateProfessionalInfoAsyncAction =
      AsyncAction('_ProfileStore.updateProfessionalInfo', context: context);

  @override
  Future<void> updateProfessionalInfo(Map<String, dynamic> data) {
    return _$updateProfessionalInfoAsyncAction
        .run(() => super.updateProfessionalInfo(data));
  }

  late final _$uploadAvatarAsyncAction =
      AsyncAction('_ProfileStore.uploadAvatar', context: context);

  @override
  Future<void> uploadAvatar(String filePath) {
    return _$uploadAvatarAsyncAction.run(() => super.uploadAvatar(filePath));
  }

  late final _$deleteAvatarAsyncAction =
      AsyncAction('_ProfileStore.deleteAvatar', context: context);

  @override
  Future<void> deleteAvatar() {
    return _$deleteAvatarAsyncAction.run(() => super.deleteAvatar());
  }

  late final _$loadNotificationSettingsAsyncAction =
      AsyncAction('_ProfileStore.loadNotificationSettings', context: context);

  @override
  Future<void> loadNotificationSettings() {
    return _$loadNotificationSettingsAsyncAction
        .run(() => super.loadNotificationSettings());
  }

  late final _$updateNotificationSettingsAsyncAction =
      AsyncAction('_ProfileStore.updateNotificationSettings', context: context);

  @override
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) {
    return _$updateNotificationSettingsAsyncAction
        .run(() => super.updateNotificationSettings(settings));
  }

  late final _$loadPrivacySettingsAsyncAction =
      AsyncAction('_ProfileStore.loadPrivacySettings', context: context);

  @override
  Future<void> loadPrivacySettings() {
    return _$loadPrivacySettingsAsyncAction
        .run(() => super.loadPrivacySettings());
  }

  late final _$updatePrivacySettingsAsyncAction =
      AsyncAction('_ProfileStore.updatePrivacySettings', context: context);

  @override
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) {
    return _$updatePrivacySettingsAsyncAction
        .run(() => super.updatePrivacySettings(settings));
  }

  late final _$changePasswordAsyncAction =
      AsyncAction('_ProfileStore.changePassword', context: context);

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return _$changePasswordAsyncAction
        .run(() => super.changePassword(currentPassword, newPassword));
  }

  late final _$requestAccountDeletionAsyncAction =
      AsyncAction('_ProfileStore.requestAccountDeletion', context: context);

  @override
  Future<void> requestAccountDeletion(String reason) {
    return _$requestAccountDeletionAsyncAction
        .run(() => super.requestAccountDeletion(reason));
  }

  late final _$loadActivityHistoryAsyncAction =
      AsyncAction('_ProfileStore.loadActivityHistory', context: context);

  @override
  Future<void> loadActivityHistory({int? limit, int? offset}) {
    return _$loadActivityHistoryAsyncAction
        .run(() => super.loadActivityHistory(limit: limit, offset: offset));
  }

  late final _$loadUserStatsAsyncAction =
      AsyncAction('_ProfileStore.loadUserStats', context: context);

  @override
  Future<void> loadUserStats() {
    return _$loadUserStatsAsyncAction.run(() => super.loadUserStats());
  }

  late final _$exportUserDataAsyncAction =
      AsyncAction('_ProfileStore.exportUserData', context: context);

  @override
  Future<Map<String, dynamic>> exportUserData() {
    return _$exportUserDataAsyncAction.run(() => super.exportUserData());
  }

  late final _$_ProfileStoreActionController =
      ActionController(name: '_ProfileStore', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.reset');
    try {
      return super.reset();
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profile: ${profile},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
notificationSettings: ${notificationSettings},
privacySettings: ${privacySettings},
activityHistory: ${activityHistory},
userStats: ${userStats},
isUpdating: ${isUpdating},
isUploadingAvatar: ${isUploadingAvatar},
hasProfile: ${hasProfile},
isDoctor: ${isDoctor},
isPatient: ${isPatient},
displayName: ${displayName},
displayEmail: ${displayEmail},
avatarUrl: ${avatarUrl},
hasMedicalInfo: ${hasMedicalInfo},
hasEmergencyInfo: ${hasEmergencyInfo}
    ''';
  }
}

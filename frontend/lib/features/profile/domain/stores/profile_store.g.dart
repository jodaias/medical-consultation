// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on ProfileStoreBase, Store {
  Computed<bool>? _$hasProfileComputed;

  @override
  bool get hasProfile =>
      (_$hasProfileComputed ??= Computed<bool>(() => super.hasProfile,
              name: 'ProfileStoreBase.hasProfile'))
          .value;
  Computed<bool>? _$isDoctorComputed;

  @override
  bool get isDoctor =>
      (_$isDoctorComputed ??= Computed<bool>(() => super.isDoctor,
              name: 'ProfileStoreBase.isDoctor'))
          .value;
  Computed<bool>? _$isPatientComputed;

  @override
  bool get isPatient =>
      (_$isPatientComputed ??= Computed<bool>(() => super.isPatient,
              name: 'ProfileStoreBase.isPatient'))
          .value;
  Computed<String>? _$displayNameComputed;

  @override
  String get displayName =>
      (_$displayNameComputed ??= Computed<String>(() => super.displayName,
              name: 'ProfileStoreBase.displayName'))
          .value;
  Computed<String>? _$displayEmailComputed;

  @override
  String get displayEmail =>
      (_$displayEmailComputed ??= Computed<String>(() => super.displayEmail,
              name: 'ProfileStoreBase.displayEmail'))
          .value;
  Computed<String?>? _$avatarUrlComputed;

  @override
  String? get avatarUrl =>
      (_$avatarUrlComputed ??= Computed<String?>(() => super.avatarUrl,
              name: 'ProfileStoreBase.avatarUrl'))
          .value;
  Computed<bool>? _$hasMedicalInfoComputed;

  @override
  bool get hasMedicalInfo =>
      (_$hasMedicalInfoComputed ??= Computed<bool>(() => super.hasMedicalInfo,
              name: 'ProfileStoreBase.hasMedicalInfo'))
          .value;
  Computed<bool>? _$hasEmergencyInfoComputed;

  @override
  bool get hasEmergencyInfo => (_$hasEmergencyInfoComputed ??= Computed<bool>(
          () => super.hasEmergencyInfo,
          name: 'ProfileStoreBase.hasEmergencyInfo'))
      .value;

  late final _$profileAtom =
      Atom(name: 'ProfileStoreBase.profile', context: context);

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

  late final _$requestStatusAtom =
      Atom(name: 'ProfileStoreBase.requestStatus', context: context);

  @override
  RequestStatusEnum get requestStatus {
    _$requestStatusAtom.reportRead();
    return super.requestStatus;
  }

  @override
  set requestStatus(RequestStatusEnum value) {
    _$requestStatusAtom.reportWrite(value, super.requestStatus, () {
      super.requestStatus = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'ProfileStoreBase.errorMessage', context: context);

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
      Atom(name: 'ProfileStoreBase.notificationSettings', context: context);

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
      Atom(name: 'ProfileStoreBase.privacySettings', context: context);

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
      Atom(name: 'ProfileStoreBase.activityHistory', context: context);

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
      Atom(name: 'ProfileStoreBase.userStats', context: context);

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

  late final _$updateStatusAtom =
      Atom(name: 'ProfileStoreBase.updateStatus', context: context);

  @override
  RequestStatusEnum get updateStatus {
    _$updateStatusAtom.reportRead();
    return super.updateStatus;
  }

  @override
  set updateStatus(RequestStatusEnum value) {
    _$updateStatusAtom.reportWrite(value, super.updateStatus, () {
      super.updateStatus = value;
    });
  }

  late final _$uploadAvatarStatusAtom =
      Atom(name: 'ProfileStoreBase.uploadAvatarStatus', context: context);

  @override
  RequestStatusEnum get uploadAvatarStatus {
    _$uploadAvatarStatusAtom.reportRead();
    return super.uploadAvatarStatus;
  }

  @override
  set uploadAvatarStatus(RequestStatusEnum value) {
    _$uploadAvatarStatusAtom.reportWrite(value, super.uploadAvatarStatus, () {
      super.uploadAvatarStatus = value;
    });
  }

  late final _$loadProfileAsyncAction =
      AsyncAction('ProfileStoreBase.loadProfile', context: context);

  @override
  Future<void> loadProfile() {
    return _$loadProfileAsyncAction.run(() => super.loadProfile());
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('ProfileStoreBase.updateProfile', context: context);

  @override
  Future<void> updateProfile(Map<String, dynamic> data) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(data));
  }

  late final _$updateMedicalInfoAsyncAction =
      AsyncAction('ProfileStoreBase.updateMedicalInfo', context: context);

  @override
  Future<void> updateMedicalInfo(Map<String, dynamic> data) {
    return _$updateMedicalInfoAsyncAction
        .run(() => super.updateMedicalInfo(data));
  }

  late final _$updateProfessionalInfoAsyncAction =
      AsyncAction('ProfileStoreBase.updateProfessionalInfo', context: context);

  @override
  Future<void> updateProfessionalInfo(Map<String, dynamic> data) {
    return _$updateProfessionalInfoAsyncAction
        .run(() => super.updateProfessionalInfo(data));
  }

  late final _$uploadAvatarAsyncAction =
      AsyncAction('ProfileStoreBase.uploadAvatar', context: context);

  @override
  Future<void> uploadAvatar(String filePath) {
    return _$uploadAvatarAsyncAction.run(() => super.uploadAvatar(filePath));
  }

  late final _$deleteAvatarAsyncAction =
      AsyncAction('ProfileStoreBase.deleteAvatar', context: context);

  @override
  Future<void> deleteAvatar() {
    return _$deleteAvatarAsyncAction.run(() => super.deleteAvatar());
  }

  late final _$loadNotificationSettingsAsyncAction = AsyncAction(
      'ProfileStoreBase.loadNotificationSettings',
      context: context);

  @override
  Future<void> loadNotificationSettings() {
    return _$loadNotificationSettingsAsyncAction
        .run(() => super.loadNotificationSettings());
  }

  late final _$updateNotificationSettingsAsyncAction = AsyncAction(
      'ProfileStoreBase.updateNotificationSettings',
      context: context);

  @override
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) {
    return _$updateNotificationSettingsAsyncAction
        .run(() => super.updateNotificationSettings(settings));
  }

  late final _$loadPrivacySettingsAsyncAction =
      AsyncAction('ProfileStoreBase.loadPrivacySettings', context: context);

  @override
  Future<void> loadPrivacySettings() {
    return _$loadPrivacySettingsAsyncAction
        .run(() => super.loadPrivacySettings());
  }

  late final _$updatePrivacySettingsAsyncAction =
      AsyncAction('ProfileStoreBase.updatePrivacySettings', context: context);

  @override
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) {
    return _$updatePrivacySettingsAsyncAction
        .run(() => super.updatePrivacySettings(settings));
  }

  late final _$changePasswordAsyncAction =
      AsyncAction('ProfileStoreBase.changePassword', context: context);

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return _$changePasswordAsyncAction
        .run(() => super.changePassword(currentPassword, newPassword));
  }

  late final _$requestAccountDeletionAsyncAction =
      AsyncAction('ProfileStoreBase.requestAccountDeletion', context: context);

  @override
  Future<void> requestAccountDeletion(String reason) {
    return _$requestAccountDeletionAsyncAction
        .run(() => super.requestAccountDeletion(reason));
  }

  late final _$loadActivityHistoryAsyncAction =
      AsyncAction('ProfileStoreBase.loadActivityHistory', context: context);

  @override
  Future<void> loadActivityHistory({int? limit, int? offset}) {
    return _$loadActivityHistoryAsyncAction
        .run(() => super.loadActivityHistory(limit: limit, offset: offset));
  }

  late final _$loadUserStatsAsyncAction =
      AsyncAction('ProfileStoreBase.loadUserStats', context: context);

  @override
  Future<void> loadUserStats() {
    return _$loadUserStatsAsyncAction.run(() => super.loadUserStats());
  }

  late final _$exportUserDataAsyncAction =
      AsyncAction('ProfileStoreBase.exportUserData', context: context);

  @override
  Future<Map<String, dynamic>> exportUserData() {
    return _$exportUserDataAsyncAction.run(() => super.exportUserData());
  }

  late final _$ProfileStoreBaseActionController =
      ActionController(name: 'ProfileStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$ProfileStoreBaseActionController.startAction(
        name: 'ProfileStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$ProfileStoreBaseActionController.startAction(
        name: 'ProfileStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profile: ${profile},
requestStatus: ${requestStatus},
errorMessage: ${errorMessage},
notificationSettings: ${notificationSettings},
privacySettings: ${privacySettings},
activityHistory: ${activityHistory},
userStats: ${userStats},
updateStatus: ${updateStatus},
uploadAvatarStatus: ${uploadAvatarStatus},
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

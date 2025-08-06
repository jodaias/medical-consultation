// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on AuthStoreBase, Store {
  Computed<bool>? _$isPatientComputed;

  @override
  bool get isPatient =>
      (_$isPatientComputed ??= Computed<bool>(() => super.isPatient,
              name: 'AuthStoreBase.isPatient'))
          .value;
  Computed<bool>? _$isDoctorComputed;

  @override
  bool get isDoctor => (_$isDoctorComputed ??=
          Computed<bool>(() => super.isDoctor, name: 'AuthStoreBase.isDoctor'))
      .value;

  late final _$requestStatusAtom =
      Atom(name: 'AuthStoreBase.requestStatus', context: context);

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

  late final _$isAuthenticatedAtom =
      Atom(name: 'AuthStoreBase.isAuthenticated', context: context);

  @override
  bool get isAuthenticated {
    _$isAuthenticatedAtom.reportRead();
    return super.isAuthenticated;
  }

  @override
  set isAuthenticated(bool value) {
    _$isAuthenticatedAtom.reportWrite(value, super.isAuthenticated, () {
      super.isAuthenticated = value;
    });
  }

  late final _$userTypeAtom =
      Atom(name: 'AuthStoreBase.userType', context: context);

  @override
  String? get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(String? value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  late final _$userIdAtom =
      Atom(name: 'AuthStoreBase.userId', context: context);

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$userNameAtom =
      Atom(name: 'AuthStoreBase.userName', context: context);

  @override
  String? get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String? value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: 'AuthStoreBase.userEmail', context: context);

  @override
  String? get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String? value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'AuthStoreBase.errorMessage', context: context);

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

  late final _$loginAsyncAction =
      AsyncAction('AuthStoreBase.login', context: context);

  @override
  Future<bool> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$registerAsyncAction =
      AsyncAction('AuthStoreBase.register', context: context);

  @override
  Future<bool> register(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String userType,
      String? specialty,
      String? crm,
      String? bio,
      double? hourlyRate}) {
    return _$registerAsyncAction.run(() => super.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        userType: userType,
        specialty: specialty,
        crm: crm,
        bio: bio,
        hourlyRate: hourlyRate));
  }

  late final _$logoutAsyncAction =
      AsyncAction('AuthStoreBase.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$checkAuthStatusAsyncAction =
      AsyncAction('AuthStoreBase.checkAuthStatus', context: context);

  @override
  Future<void> checkAuthStatus() {
    return _$checkAuthStatusAsyncAction.run(() => super.checkAuthStatus());
  }

  late final _$resetPasswordAsyncAction =
      AsyncAction('AuthStoreBase.resetPassword', context: context);

  @override
  Future<bool> resetPassword(String email) {
    return _$resetPasswordAsyncAction.run(() => super.resetPassword(email));
  }

  late final _$AuthStoreBaseActionController =
      ActionController(name: 'AuthStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$AuthStoreBaseActionController.startAction(
        name: 'AuthStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
requestStatus: ${requestStatus},
isAuthenticated: ${isAuthenticated},
userType: ${userType},
userId: ${userId},
userName: ${userName},
userEmail: ${userEmail},
errorMessage: ${errorMessage},
isPatient: ${isPatient},
isDoctor: ${isDoctor}
    ''';
  }
}

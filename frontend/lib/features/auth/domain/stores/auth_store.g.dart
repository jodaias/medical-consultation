// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<bool>? _$isPatientComputed;

  @override
  bool get isPatient => (_$isPatientComputed ??=
          Computed<bool>(() => super.isPatient, name: '_AuthStore.isPatient'))
      .value;
  Computed<bool>? _$isDoctorComputed;

  @override
  bool get isDoctor => (_$isDoctorComputed ??=
          Computed<bool>(() => super.isDoctor, name: '_AuthStore.isDoctor'))
      .value;

  late final _$isAuthenticatedAtom =
      Atom(name: '_AuthStore.isAuthenticated', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: '_AuthStore.isLoading', context: context);

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

  late final _$userTypeAtom =
      Atom(name: '_AuthStore.userType', context: context);

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

  late final _$userIdAtom = Atom(name: '_AuthStore.userId', context: context);

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
      Atom(name: '_AuthStore.userName', context: context);

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
      Atom(name: '_AuthStore.userEmail', context: context);

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
      Atom(name: '_AuthStore.errorMessage', context: context);

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
      AsyncAction('_AuthStore.login', context: context);

  @override
  Future<bool> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$registerAsyncAction =
      AsyncAction('_AuthStore.register', context: context);

  @override
  Future<bool> register(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String userType}) {
    return _$registerAsyncAction.run(() => super.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        userType: userType));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthStore.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$checkAuthStatusAsyncAction =
      AsyncAction('_AuthStore.checkAuthStatus', context: context);

  @override
  Future<void> checkAuthStatus() {
    return _$checkAuthStatusAsyncAction.run(() => super.checkAuthStatus());
  }

  late final _$_AuthStoreActionController =
      ActionController(name: '_AuthStore', context: context);

  @override
  void clearError() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isAuthenticated: ${isAuthenticated},
isLoading: ${isLoading},
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

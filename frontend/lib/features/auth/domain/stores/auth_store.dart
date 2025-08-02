import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/data/services/auth_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';

part 'auth_store.g.dart';

@injectable
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthService _authService = AuthService();
  late final StorageService _storageService;

  _AuthStore() {
    _storageService = GetIt.instance<StorageService>();
  }

  @observable
  bool isAuthenticated = false;

  @observable
  bool isLoading = false;

  @observable
  String? userType;

  @observable
  String? userId;

  @observable
  String? userName;

  @observable
  String? userEmail;

  @observable
  String? errorMessage;

  @computed
  bool get isPatient => userType == AppConstants.patientType;

  @computed
  bool get isDoctor => userType == AppConstants.doctorType;

  @action
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      final response = await _authService.login(email, password);

      // Extrair dados da resposta
      isAuthenticated = true;
      userType = response['user']['userType'];
      userId = response['user']['id'];
      userName = response['user']['name'];
      userEmail = response['user']['email'];

      // Salvar dados no storage
      await _storageService.saveToken(response['token']);
      await _storageService.saveUserData(response['user']);
      await _storageService.saveUserType(response['user']['userType']);
      await _storageService.setAuthenticated(true);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String userType,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        userType: userType,
      );

      // Extrair dados da resposta
      isAuthenticated = true;
      this.userType = response['user']['userType'];
      userId = response['user']['id'];
      userName = response['user']['name'];
      userEmail = response['user']['email'];

      // Salvar dados no storage
      await _storageService.saveToken(response['token']);
      await _storageService.saveUserData(response['user']);
      await _storageService.saveUserType(response['user']['userType']);
      await _storageService.saveUserId(response['user']['id']);
      await _storageService.setAuthenticated(true);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;

    try {
      await _authService.logout();

      // Limpar dados locais
      isAuthenticated = false;
      userType = null;
      userId = null;
      userName = null;
      userEmail = null;
      errorMessage = null;

      // Limpar dados do storage
      await _storageService.clearAll();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> checkAuthStatus() async {
    try {
      await _storageService.initialize();

      final isAuth = await _storageService.isAuthenticated();
      if (!isAuth) {
        isAuthenticated = false;
        return;
      }

      final token = await _storageService.getToken();
      if (token == null || _storageService.isTokenExpired(token)) {
        await _storageService.clearAll();
        isAuthenticated = false;
        return;
      }

      final userData = await _storageService.getUserData();
      final storedUserId = await _storageService.getUserId();
      if (userData != null && storedUserId != null) {
        isAuthenticated = true;
        userType = userData['userType'];
        userId = storedUserId;
        userName = userData['name'];
        userEmail = userData['email'];
      } else {
        isAuthenticated = false;
      }
    } catch (e) {
      isAuthenticated = false;
      await _storageService.clearAll();
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  Future<bool> resetPassword(String email) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _authService.forgotPassword(email);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }
}

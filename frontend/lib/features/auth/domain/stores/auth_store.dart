import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/data/services/auth_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';
import 'package:medical_consultation_app/core/services/notification_service.dart';

part 'auth_store.g.dart';

@injectable
class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final _authService = getIt<AuthService>();
  final _storageService = getIt<StorageService>();

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  bool isAuthenticated = false;

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
  Future<void> login(String email, String password) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    try {
      final result = await _authService.login(email, password);
      if (result.success) {
        final data = result.data['data'];
        final userData = data['user'];
        isAuthenticated = true;
        userType = userData['userType'];
        userId = userData['id'];
        userName = userData['name'];
        userEmail = userData['email'];
        await _storageService.saveToken(data['token']);
        await _storageService.saveUserId(userData['id']);
        await _storageService.saveRefreshToken(data['refreshToken']);
        await _storageService.saveUserData(userData);
        await _storageService.saveUserType(userData['userType']);
        await _storageService.setAuthenticated(true);
        // Após login, registra token FCM
        final notificationService = getIt<NotificationService>();
        await notificationService.registerFCMTokenIfAuthenticated();
        requestStatus = RequestStatusEnum.success;
      } else {
        errorMessage = result.error?.toString() ?? 'Erro desconhecido';
        requestStatus = RequestStatusEnum.fail;
      }
    } catch (e) {
      errorMessage = e.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> register({
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
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        userType: userType,
        specialty: specialty,
        crm: crm,
        bio: bio,
        hourlyRate: hourlyRate,
      );
      if (result.success) {
        final data = result.data['data'];
        final userData = data['user'];
        isAuthenticated = true;
        this.userType = userData['userType'];
        userId = userData['id'];
        userName = userData['name'];
        userEmail = userData['email'];
        await _storageService.saveToken(data['token']);
        await _storageService.saveRefreshToken(data['refreshToken']);
        await _storageService.saveUserData(userData);
        await _storageService.saveUserType(userData['userType']);
        await _storageService.saveUserId(userData['id']);
        await _storageService.setAuthenticated(true);
        // Após registro, registra token FCM
        final notificationService = getIt<NotificationService>();
        await notificationService.registerFCMTokenIfAuthenticated();
        requestStatus = RequestStatusEnum.success;
      } else {
        errorMessage = result.error?.toString() ?? 'Erro desconhecido';
        requestStatus = RequestStatusEnum.fail;
      }
    } catch (e) {
      errorMessage = e.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> logout() async {
    requestStatus = RequestStatusEnum.loading;
    try {
      final result = await _authService.logout();
      isAuthenticated = false;
      userType = null;
      userId = null;
      userName = null;
      userEmail = null;
      errorMessage = null;
      await _storageService.clearAll();
      if (!result.success) {
        errorMessage = result.error?.toString();
        requestStatus = RequestStatusEnum.fail;
      } else {
        requestStatus = RequestStatusEnum.success;
      }
    } catch (e) {
      errorMessage = e.toString();
      requestStatus = RequestStatusEnum.fail;
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
  Future<void> resetPassword(String email) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    try {
      final result = await _authService.forgotPassword(email);
      if (result.success) {
        requestStatus = RequestStatusEnum.success;
      } else {
        errorMessage = result.error?.toString() ?? 'Erro desconhecido';
        requestStatus = RequestStatusEnum.fail;
      }
    } catch (e) {
      errorMessage = e.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }
}

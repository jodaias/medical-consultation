import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';

part 'auth_store.g.dart';

@injectable
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
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
      // TODO: Implementar chamada para API
      await Future.delayed(const Duration(seconds: 2)); // Simulação

      // Simular dados de resposta
      isAuthenticated = true;
      userType =
          AppConstants.patientType; // Por padrão, vamos simular um paciente
      userId = 'user_123';
      userName = 'João Silva';
      userEmail = email;

      return true;
    } catch (e) {
      errorMessage = 'Erro ao fazer login: $e';
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
      // TODO: Implementar chamada para API
      await Future.delayed(const Duration(seconds: 2)); // Simulação

      // Simular dados de resposta
      isAuthenticated = true;
      userType = userType;
      userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      userName = name;
      userEmail = email;

      return true;
    } catch (e) {
      errorMessage = 'Erro ao criar conta: $e';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;

    try {
      // TODO: Implementar logout na API
      await Future.delayed(const Duration(seconds: 1)); // Simulação

      isAuthenticated = false;
      userType = null;
      userId = null;
      userName = null;
      userEmail = null;
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Erro ao fazer logout: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> checkAuthStatus() async {
    // TODO: Verificar token salvo e validar com a API
    // Por enquanto, vamos simular que não está autenticado
    isAuthenticated = false;
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}

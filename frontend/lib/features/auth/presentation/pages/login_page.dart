import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthStore _authStore = getIt<AuthStore>();

  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  String _password = '';
  bool _showPasswordRequirements = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo e título
                Column(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Medical Consultation',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Faça login para continuar',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Campo de email
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Digite seu email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: AppConstants.requiredField),
                    FormBuilderValidators.email(
                        errorText: AppConstants.invalidEmail),
                  ]),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    if (_authStore.errorMessage != null) {
                      _authStore.clearError();
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Campo de senha
                FormBuilderTextField(
                  name: 'password',
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: AppConstants.requiredField),
                    (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.requiredField;
                      }
                      if (!_isPasswordValid(value)) {
                        return 'Senha não atende aos requisitos';
                      }
                      return null;
                    },
                  ]),
                  onChanged: (value) {
                    setState(() {
                      _password = value ?? '';
                    });
                    if (_authStore.errorMessage != null) {
                      _authStore.clearError();
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Esqueci a senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push('/forgot-password');
                    },
                    child: const Text('Esqueci minha senha'),
                  ),
                ),

                const SizedBox(height: 30),

                // Botão de login
                Observer(
                  builder: (_) => ElevatedButton(
                    onPressed:
                        _authStore.requestStatus == RequestStatusEnum.loading
                            ? null
                            : _handleLogin,
                    child: _authStore.requestStatus == RequestStatusEnum.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar'),
                  ),
                ),

                const SizedBox(height: 20),

                // Divisor
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ou',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // Botão de registro
                OutlinedButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formData = _formKey.currentState!.value;
        final email = formData['email'];
        final password = formData['password'];

        // Implementar login com AuthStore
        await _authStore.login(email, password);

        if (_authStore.requestStatus == RequestStatusEnum.success) {
          ToastUtils.showSuccessToast('Login realizado com sucesso!');

          // Navegar para a tela principal baseada no tipo de usuário
          if (_authStore.isDoctor) {
            context.go('/doctor');
          } else {
            context.go('/patient');
          }
        } else {
          ToastUtils.showErrorToast(
              'Erro ao fazer login: ${_authStore.errorMessage}');
        }
      } catch (e) {
        ToastUtils.showErrorToast(
            'Erro ao fazer login: ${_authStore.errorMessage ?? e}');
      }
    }
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
            .hasMatch(password);
  }
}

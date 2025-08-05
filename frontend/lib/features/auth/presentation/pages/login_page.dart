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
// Requisitos da senha
                if (_password.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildPasswordContainer(),
                ],

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
                    onPressed: _authStore.isLoading ? null : _handleLogin,
                    child: _authStore.isLoading
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
        final success = await _authStore.login(email, password);

        if (mounted && success) {
          ToastUtils.showSuccessToast('Login realizado com sucesso!');

          // Navegar para a tela principal baseada no tipo de usuário
          if (_authStore.isDoctor) {
            context.go('/doctor');
          } else {
            context.go('/patient');
          }
        }
      } catch (e) {
        if (mounted) {
          ToastUtils.showErrorToast(
              'Erro ao fazer login: ${_authStore.errorMessage ?? e}');
        }
      }
    }
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
            .hasMatch(password);
  }

  // Container principal dos requisitos da senha
  Widget _buildPasswordContainer() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com título e botão toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  'Requisitos da senha',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showPasswordRequirements = !_showPasswordRequirements;
                  });
                },
                icon: Icon(
                  _showPasswordRequirements
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                ),
                label: Text(
                  _showPasswordRequirements
                      ? 'Ocultar requisitos'
                      : 'Mostrar requisitos',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          // Conteúdo baseado no estado
          if (_showPasswordRequirements) ...[
            const SizedBox(height: 8),
            _buildPasswordRequirements(),
          ] else ...[
            const SizedBox(height: 8),
            _buildPasswordSummary(),
          ],
        ],
      ),
    );
  }

  // Widget de requisitos da senha
  Widget _buildPasswordRequirements() {
    final hasMinLength = _password.length >= 8;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(_password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(_password);
    final hasNumber = RegExp(r'\d').hasMatch(_password);
    final hasSpecialChar = RegExp(r'[@$!%*?&]').hasMatch(_password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirementItem(
          'Pelo menos 8 caracteres',
          hasMinLength,
        ),
        _buildRequirementItem(
          'Uma letra maiúscula',
          hasUpperCase,
        ),
        _buildRequirementItem(
          'Uma letra minúscula',
          hasLowerCase,
        ),
        _buildRequirementItem(
          'Um número',
          hasNumber,
        ),
        _buildRequirementItem(
          'Um caractere especial (@\$!%*?&)',
          hasSpecialChar,
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet
                  ? Colors.green[700]
                  : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Widget de resumo da senha
  Widget _buildPasswordSummary() {
    final hasMinLength = _password.length >= 8;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(_password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(_password);
    final hasNumber = RegExp(r'\d').hasMatch(_password);
    final hasSpecialChar = RegExp(r'[@$!%*?&]').hasMatch(_password);

    final totalRequirements = 5;
    final metRequirements = [
      hasMinLength,
      hasUpperCase,
      hasLowerCase,
      hasNumber,
      hasSpecialChar
    ].where((met) => met).length;

    final progress = metRequirements / totalRequirements;
    final isComplete = metRequirements == totalRequirements;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Força da senha:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$metRequirements de $totalRequirements requisitos atendidos',
                style: TextStyle(
                  fontSize: 11,
                  color: isComplete
                      ? Colors.green[700]
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Icon(
          isComplete ? Icons.check_circle : Icons.info_outline,
          size: 20,
          color: isComplete ? Colors.green : Colors.orange,
        ),
      ],
    );
  }
}

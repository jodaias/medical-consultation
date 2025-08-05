import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/utils/currency_formatter.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthStore _authStore = getIt<AuthStore>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedUserType = AppConstants.patientType;
  String _password = '';
  bool _showPasswordRequirements = false;

  // Máscara para telefone brasileiro
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Título
                Text(
                  'Crie sua conta',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
                Text(
                  'Preencha os dados abaixo',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Seleção de tipo de usuário
                Text(
                  'Tipo de conta',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildUserTypeCard(
                        title: 'Paciente',
                        icon: Icons.person,
                        isSelected:
                            _selectedUserType == AppConstants.patientType,
                        onTap: () => setState(() {
                          _selectedUserType = AppConstants.patientType;
                        }),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUserTypeCard(
                        title: 'Médico',
                        icon: Icons.medical_services,
                        isSelected:
                            _selectedUserType == AppConstants.doctorType,
                        onTap: () => setState(() {
                          _selectedUserType = AppConstants.doctorType;
                        }),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Campo de nome
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    hintText: 'Digite seu nome completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: AppConstants.requiredField),
                    (value) {
                      if (value != null && value.trim().length < 3) {
                        return 'Nome deve ter pelo menos 3 caracteres';
                      }
                      if (value != null &&
                          !RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
                        return 'Nome deve conter apenas letras';
                      }
                      return null;
                    },
                  ]),
                  onChanged: (value) {
                    if (_authStore.errorMessage != null) {
                      _authStore.clearError();
                    }
                  },
                ),

                const SizedBox(height: 20),

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

                // Campo de telefone
                FormBuilderTextField(
                  name: 'phone',
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: '(99) 99999-9999',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: AppConstants.requiredField),
                    (value) {
                      if (value != null && value.length < 14) {
                        return 'Telefone inválido';
                      }
                      return null;
                    },
                  ]),
                  onChanged: (value) {
                    if (_authStore.errorMessage != null) {
                      _authStore.clearError();
                    }
                  },
                  inputFormatters: [_phoneMask],
                  keyboardType: TextInputType.phone,
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

                const SizedBox(height: 20),

                // Campo de confirmar senha
                FormBuilderTextField(
                  name: 'confirmPassword',
                  decoration: InputDecoration(
                    labelText: 'Confirmar senha',
                    hintText: 'Confirme sua senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: AppConstants.requiredField),
                    (value) {
                      final password =
                          _formKey.currentState?.fields['password']?.value;
                      if (value != password) {
                        return AppConstants.passwordMismatch;
                      }
                      return null;
                    },
                  ]),
                ),

                // Campos específicos para médicos
                if (_selectedUserType == AppConstants.doctorType) ...[
                  const SizedBox(height: 20),

                  // Campo de especialidade com pesquisa
                  FormBuilderTextField(
                    name: 'specialty',
                    decoration: const InputDecoration(
                      labelText: 'Especialidade',
                      hintText: 'Digite para pesquisar especialidade',
                      prefixIcon: Icon(Icons.medical_services_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: AppConstants.requiredField),
                      (value) {
                        if (value == null || value.isEmpty) {
                          return AppConstants.requiredField;
                        }
                        if (!AppConstants.specialties.contains(value)) {
                          return AppConstants.invalidSpecialty;
                        }
                        return null;
                      },
                    ]),
                    onTap: () => _showSpecialtyDialog(context),
                    readOnly: true,
                  ),

                  const SizedBox(height: 20),

                  // Campo de CRM
                  FormBuilderTextField(
                    name: 'crm',
                    decoration: const InputDecoration(
                      labelText: 'CRM',
                      hintText: 'Digite seu CRM',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'CRM é obrigatório'),
                      (value) {
                        if (value != null && value.length < 5) {
                          return 'CRM deve ter pelo menos 5 caracteres';
                        }
                        return null;
                      },
                    ]),
                  ),

                  const SizedBox(height: 20),

                  // Campo de biografia
                  FormBuilderTextField(
                    name: 'bio',
                    decoration: const InputDecoration(
                      labelText: 'Biografia (opcional)',
                      hintText: 'Conte um pouco sobre sua experiência...',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    maxLines: 3,
                    maxLength: 500,
                  ),

                  const SizedBox(height: 20),

                  // Campo de valor por hora
                  FormBuilderTextField(
                    name: 'hourlyRate',
                    decoration: const InputDecoration(
                      labelText: 'Valor por consulta (R\$)',
                      hintText: 'R\$ 0,00',
                      prefixIcon: Icon(Icons.attach_money_outlined),
                    ),
                    showCursor: false,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    inputFormatters: [BrazilianCurrencyFormatter()],
                    validator: FormBuilderValidators.compose([
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Valor é obrigatório';
                        }

                        // Usar o método da classe BrazilianCurrencyFormatter
                        final rate =
                            BrazilianCurrencyFormatter.parseToReais(value);
                        if (rate < 10) {
                          return 'Valor mínimo é R\$ 10,00';
                        }
                        if (rate > 10000) {
                          return 'Valor máximo é R\$ 10.000,00';
                        }
                        return null;
                      },
                    ]),
                  ),
                ],

                const SizedBox(height: 30),

                // Botão de registro
                Observer(
                  builder: (_) => ElevatedButton(
                    onPressed: _authStore.isLoading ? null : _handleRegister,
                    child: _authStore.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Criar conta'),
                  ),
                ),

                const SizedBox(height: 20),

                // Link para login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Fazer login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de seleção de especialidade com pesquisa
  void _showSpecialtyDialog(BuildContext context) {
    String searchQuery = '';
    List<String> filteredSpecialties = AppConstants.specialties;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Selecionar Especialidade'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    // Campo de pesquisa
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar especialidade',
                        hintText: 'Digite para filtrar...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          if (value.isEmpty) {
                            filteredSpecialties = AppConstants.specialties;
                          } else {
                            filteredSpecialties = AppConstants.specialties
                                .where((specialty) => specialty
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Lista de especialidades
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSpecialties.length,
                        itemBuilder: (context, index) {
                          final specialty = filteredSpecialties[index];
                          return ListTile(
                            title: Text(specialty),
                            onTap: () {
                              _formKey.currentState?.fields['specialty']
                                  ?.didChange(specialty);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formData = _formKey.currentState!.value;

        // Remover máscara do telefone
        String phone = formData['phone'] ?? '';
        phone = phone.replaceAll(RegExp(r'[^\d]'), '');

        // Preparar dados específicos para médicos
        Map<String, dynamic> registerData = {
          'name': formData['name'],
          'email': formData['email'],
          'phone': phone,
          'password': formData['password'],
          'userType': _selectedUserType,
        };

        // Adicionar campos específicos para médicos
        if (_selectedUserType == AppConstants.doctorType) {
          registerData['specialty'] = formData['specialty'];
          registerData['crm'] = formData['crm'];
          registerData['bio'] = formData['bio'] ?? '';

          // Processar valor monetário
          if (formData['hourlyRate'] != null &&
              formData['hourlyRate'].isNotEmpty) {
            final cleanValue =
                formData['hourlyRate'].replaceAll(RegExp(r'[^\d]'), '');
            if (cleanValue.isNotEmpty) {
              registerData['hourlyRate'] = double.parse(cleanValue);
            }
          }
        }

        // Chamar AuthStore para registro
        final success = await _authStore.register(
          name: registerData['name'],
          email: registerData['email'],
          phone: registerData['phone'],
          password: registerData['password'],
          userType: registerData['userType'],
          specialty: registerData['specialty'],
          crm: registerData['crm'],
          bio: registerData['bio'],
          hourlyRate: registerData['hourlyRate'],
        );

        if (mounted) {
          if (!success && _authStore.errorMessage != null) {
            ToastUtils.showErrorToast(
                'Registro falhou: ${_authStore.errorMessage ?? 'Erro desconhecido'}');
            return;
          }

          if (success) {
            ToastUtils.showSuccessToast('Conta criada com sucesso!');

            // Navegar para a tela principal baseada no tipo de usuário
            if (_selectedUserType == AppConstants.doctorType) {
              context.go('/doctor');
            } else {
              context.go('/patient');
            }
          }
        }
      } catch (e) {
        if (mounted) {
          ToastUtils.showErrorToast(
              'Erro ao criar conta: ${_authStore.errorMessage ?? e}');
        }
      }
    }
  }

  // Validação de senha
  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
            .hasMatch(password);
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

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/features/profile/domain/stores/profile_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileStore _profileStore = getIt<ProfileStore>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _emergencyPhoneController;

  // Campos específicos para médicos
  late TextEditingController _specialtyController;
  late TextEditingController _crmController;
  late TextEditingController _crmStateController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;

  // Campos específicos para pacientes
  late TextEditingController _bloodTypeController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicationsController;
  late TextEditingController _conditionsController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfile();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _emergencyPhoneController = TextEditingController();

    // Campos específicos para médicos
    _specialtyController = TextEditingController();
    _crmController = TextEditingController();
    _crmStateController = TextEditingController();
    _educationController = TextEditingController();
    _experienceController = TextEditingController();

    // Campos específicos para pacientes
    _bloodTypeController = TextEditingController();
    _allergiesController = TextEditingController();
    _medicationsController = TextEditingController();
    _conditionsController = TextEditingController();
  }

  Future<void> _loadProfile() async {
    await _profileStore.loadProfile();
    _populateControllers();
  }

  void _populateControllers() {
    final profile = _profileStore.profile;
    if (profile != null) {
      _nameController.text = profile.name;
      _phoneController.text = profile.phone ?? '';
      _bioController.text = profile.bio ?? '';
      _addressController.text = profile.address ?? '';
      _cityController.text = profile.city ?? '';
      _stateController.text = profile.state ?? '';
      _zipCodeController.text = profile.zipCode ?? '';
      _emergencyContactController.text = profile.emergencyContact ?? '';
      _emergencyPhoneController.text = profile.emergencyPhone ?? '';

      // Campos específicos para médicos
      _specialtyController.text = profile.specialty ?? '';
      _crmController.text = profile.crm ?? '';
      _crmStateController.text = profile.crmState ?? '';
      _educationController.text = profile.education ?? '';
      _experienceController.text = profile.experience ?? '';

      // Campos específicos para pacientes
      _bloodTypeController.text = profile.bloodType ?? '';
      _allergiesController.text = profile.allergies?.join(', ') ?? '';
      _medicationsController.text = profile.medications?.join(', ') ?? '';
      _conditionsController.text = profile.conditions?.join(', ') ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _specialtyController.dispose();
    _crmController.dispose();
    _crmStateController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'zipCode': _zipCodeController.text.trim(),
        'emergencyContact': _emergencyContactController.text.trim(),
        'emergencyPhone': _emergencyPhoneController.text.trim(),
      };

      await _profileStore.updateProfile(data);

      if (_profileStore.errorMessage == null && mounted) {
        ToastUtils.showSuccessToast('Perfil atualizado com sucesso!');
        context.pop();
      } else if (mounted) {
        ToastUtils.showErrorToast(_profileStore.errorMessage ?? 'Erro ao atualizar perfil');
      }
    }
  }

  Future<void> _saveMedicalInfo() async {
    if (_profileStore.isPatient) {
      final data = <String, dynamic>{
        'bloodType': _bloodTypeController.text.trim(),
        'allergies': _allergiesController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'medications': _medicationsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'conditions': _conditionsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      };

      await _profileStore.updateMedicalInfo(data);

      if (_profileStore.errorMessage == null && mounted) {
        ToastUtils.showSuccessToast('Informações médicas atualizadas com sucesso!');
      } else if (mounted) {
        ToastUtils.showErrorToast(_profileStore.errorMessage ?? 'Erro ao atualizar informações médicas');
      }
    }
  }

  Future<void> _saveProfessionalInfo() async {
    if (_profileStore.isDoctor) {
      final data = <String, dynamic>{
        'specialty': _specialtyController.text.trim(),
        'crm': _crmController.text.trim(),
        'crmState': _crmStateController.text.trim(),
        'education': _educationController.text.trim(),
        'experience': _experienceController.text.trim(),
      };

      await _profileStore.updateProfessionalInfo(data);

      if (_profileStore.errorMessage == null && mounted) {
        ToastUtils.showSuccessToast('Informações profissionais atualizadas com sucesso!');
      } else if (mounted) {
        ToastUtils.showErrorToast(_profileStore.errorMessage ?? 'Erro ao atualizar informações profissionais');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        elevation: 0,
        actions: [
          Observer(
            builder: (_) => _profileStore.isUpdating
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _saveProfile,
                    child: const Text('Salvar'),
                  ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_profileStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPersonalInfoSection(),
                  const SizedBox(height: 24),
                  if (_profileStore.isPatient) ...[
                    _buildMedicalInfoSection(),
                    const SizedBox(height: 24),
                  ],
                  if (_profileStore.isDoctor) ...[
                    _buildProfessionalInfoSection(),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações Pessoais',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Biografia',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _zipCodeController,
              decoration: const InputDecoration(
                labelText: 'CEP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(
                labelText: 'Contato de Emergência',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyPhoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone de Emergência',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informações Médicas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _saveMedicalInfo,
                  child: const Text('Salvar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bloodTypeController,
              decoration: const InputDecoration(
                labelText: 'Tipo Sanguíneo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _allergiesController,
              decoration: const InputDecoration(
                labelText: 'Alergias (separadas por vírgula)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicationsController,
              decoration: const InputDecoration(
                labelText: 'Medicamentos (separados por vírgula)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _conditionsController,
              decoration: const InputDecoration(
                labelText: 'Condições Médicas (separadas por vírgula)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informações Profissionais',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _saveProfessionalInfo,
                  child: const Text('Salvar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(
                labelText: 'Especialidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _crmController,
                    decoration: const InputDecoration(
                      labelText: 'CRM',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _crmStateController,
                    decoration: const InputDecoration(
                      labelText: 'Estado do CRM',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _educationController,
              decoration: const InputDecoration(
                labelText: 'Formação',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Experiência',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

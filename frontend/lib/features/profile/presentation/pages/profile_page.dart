import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/features/profile/domain/stores/profile_store.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileStore _profileStore = getIt<ProfileStore>();
  final AuthStore _authStore = getIt<AuthStore>();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _profileStore.loadProfile();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        await _profileStore.uploadAvatar(image.path);
        if (mounted) {
          ToastUtils.showSuccessToast('Avatar atualizado com sucesso!');
        }
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showErrorToast('Erro ao atualizar avatar: $e');
      }
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da galeria'),
              onTap: () {
                context.pop();
                _pickImage();
              },
            ),
            if (_profileStore.avatarUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover avatar',
                    style: TextStyle(color: Colors.red)),
                onTap: () async {
                  context.pop();
                  await _profileStore.deleteAvatar();
                  if (mounted) {
                    ToastUtils.showSuccessToast('Avatar removido com sucesso!');
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_profileStore.requestStatus == RequestStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_profileStore.errorMessage != null) {
            return _buildErrorWidget();
          }

          final profile = _profileStore.profile;
          if (profile == null) {
            return const Center(child: Text('Perfil não encontrado'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(profile),
                const SizedBox(height: 24),
                _buildProfileSections(profile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(dynamic profile) {
    return Center(
      child: Column(
        children: [
          // Avatar
          GestureDetector(
            onTap: _showImageOptions,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  backgroundImage: _profileStore.avatarUrl != null
                      ? NetworkImage(_profileStore.avatarUrl!)
                      : null,
                  child: _profileStore.avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: AppTheme.primaryColor,
                        )
                      : null,
                ),
                if (_profileStore.uploadAvatarStatus ==
                    RequestStatusEnum.loading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Nome e tipo de usuário
          Text(
            _profileStore.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profileStore.isDoctor ? 'Médico' : 'Paciente',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          if (_profileStore.isDoctor && profile.doctorInfo.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              profile.doctorInfo,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileSections(dynamic profile) {
    return Column(
      children: [
        _buildInfoSection(
          title: 'Informações Pessoais',
          children: [
            _buildInfoRow('Email', _profileStore.displayEmail),
            _buildInfoRow('Telefone', profile.phone ?? 'Não informado'),
            if (profile.fullAddress.isNotEmpty)
              _buildInfoRow('Endereço', profile.fullAddress),
          ],
        ),
        const SizedBox(height: 16),
        if (_profileStore.isPatient) ...[
          _buildInfoSection(
            title: 'Informações Médicas',
            children: [
              if (profile.bloodType != null)
                _buildInfoRow('Tipo Sanguíneo', profile.bloodType!),
              if (profile.allergies != null && profile.allergies!.isNotEmpty)
                _buildInfoRow('Alergias', profile.allergies!.join(', ')),
              if (profile.medications != null &&
                  profile.medications!.isNotEmpty)
                _buildInfoRow('Medicamentos', profile.medications!.join(', ')),
              if (profile.conditions != null && profile.conditions!.isNotEmpty)
                _buildInfoRow('Condições', profile.conditions!.join(', ')),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoSection(
            title: 'Contato de Emergência',
            children: [
              if (profile.emergencyContact != null)
                _buildInfoRow('Nome', profile.emergencyContact!),
              if (profile.emergencyPhone != null)
                _buildInfoRow('Telefone', profile.emergencyPhone!),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (_profileStore.isDoctor) ...[
          _buildInfoSection(
            title: 'Informações Profissionais',
            children: [
              if (profile.education != null)
                _buildInfoRow('Formação', profile.education!),
              if (profile.experience != null)
                _buildInfoRow('Experiência', profile.experience!),
              if (profile.certifications != null &&
                  profile.certifications!.isNotEmpty)
                _buildInfoRow(
                    'Certificações', profile.certifications!.join(', ')),
            ],
          ),
          const SizedBox(height: 16),
        ],
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit,
          title: 'Editar Perfil',
          onTap: () => context.push('/profile/edit'),
        ),
        _buildActionButton(
          icon: Icons.notifications,
          title: 'Configurações de Notificação',
          onTap: () => context.push('/profile/notifications'),
        ),
        _buildActionButton(
          icon: Icons.security,
          title: 'Privacidade e Segurança',
          onTap: () => context.push('/profile/privacy'),
        ),
        _buildActionButton(
          icon: Icons.history,
          title: 'Histórico de Atividades',
          onTap: () => context.push('/profile/activity'),
        ),
        _buildActionButton(
          icon: Icons.analytics,
          title: 'Estatísticas',
          onTap: () => context.push('/profile/stats'),
        ),
        _buildActionButton(
          icon: Icons.logout,
          title: 'Sair',
          onTap: () => _showLogoutDialog(),
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppTheme.primaryColor),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _profileStore.errorMessage ?? 'Erro desconhecido',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProfile,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _authStore.logout();
              context.go('/login');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

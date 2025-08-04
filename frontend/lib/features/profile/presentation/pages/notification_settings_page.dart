import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/features/profile/domain/stores/profile_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final ProfileStore _profileStore = getIt<ProfileStore>();

  // Controles para switches
  bool _consultationReminders = true;
  bool _newMessages = true;
  bool _consultationUpdates = true;
  bool _systemNotifications = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    await _profileStore.loadNotificationSettings();
    _populateSettings();
  }

  void _populateSettings() {
    final settings = _profileStore.notificationSettings;
    _consultationReminders = settings['consultationReminders'] ?? true;
    _newMessages = settings['newMessages'] ?? true;
    _consultationUpdates = settings['consultationUpdates'] ?? true;
    _systemNotifications = settings['systemNotifications'] ?? true;
    _emailNotifications = settings['emailNotifications'] ?? true;
    _pushNotifications = settings['pushNotifications'] ?? true;
    _smsNotifications = settings['smsNotifications'] ?? false;
  }

  Future<void> _saveSettings() async {
    final settings = {
      'consultationReminders': _consultationReminders,
      'newMessages': _newMessages,
      'consultationUpdates': _consultationUpdates,
      'systemNotifications': _systemNotifications,
      'emailNotifications': _emailNotifications,
      'pushNotifications': _pushNotifications,
      'smsNotifications': _smsNotifications,
    };

    await _profileStore.updateNotificationSettings(settings);

    if (_profileStore.errorMessage == null && mounted) {
      ToastUtils.showSuccessToast('Configurações salvas com sucesso!');
    } else if (mounted) {
      ToastUtils.showErrorToast(_profileStore.errorMessage ?? 'Erro ao salvar configurações');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificação'),
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
                    onPressed: _saveSettings,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationSection(),
                const SizedBox(height: 24),
                _buildChannelSection(),
                const SizedBox(height: 24),
                _buildInfoCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipos de Notificação',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              title: 'Lembretes de Consulta',
              subtitle: 'Receber lembretes antes das consultas agendadas',
              value: _consultationReminders,
              onChanged: (value) =>
                  setState(() => _consultationReminders = value),
            ),
            _buildSwitchTile(
              title: 'Novas Mensagens',
              subtitle: 'Notificações quando receber novas mensagens no chat',
              value: _newMessages,
              onChanged: (value) => setState(() => _newMessages = value),
            ),
            _buildSwitchTile(
              title: 'Atualizações de Consulta',
              subtitle: 'Notificações sobre mudanças no status das consultas',
              value: _consultationUpdates,
              onChanged: (value) =>
                  setState(() => _consultationUpdates = value),
            ),
            _buildSwitchTile(
              title: 'Notificações do Sistema',
              subtitle: 'Notificações gerais do aplicativo',
              value: _systemNotifications,
              onChanged: (value) =>
                  setState(() => _systemNotifications = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Canais de Notificação',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              title: 'Notificações Push',
              subtitle: 'Receber notificações no dispositivo',
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              title: 'Notificações por Email',
              subtitle: 'Receber notificações por email',
              value: _emailNotifications,
              onChanged: (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchTile(
              title: 'Notificações por SMS',
              subtitle: 'Receber notificações por SMS',
              value: _smsNotifications,
              onChanged: (value) => setState(() => _smsNotifications = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'As configurações de notificação são aplicadas imediatamente. '
              'Você pode alterar essas configurações a qualquer momento.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authStore.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com informações do usuário
                _buildUserHeader(authStore),

                const SizedBox(height: 30),

                // Menu de funcionalidades
                _buildMenuGrid(context),

                const SizedBox(height: 30),

                // Consultas recentes
                _buildRecentConsultations(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserHeader(AuthStore authStore) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                authStore.userName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${authStore.userName ?? 'Usuário'}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Como podemos ajudar você hoje?',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Funcionalidades',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              title: 'Nova Consulta',
              icon: Icons.add_circle_outline,
              color: AppTheme.primaryColor,
              onTap: () {
                // TODO: Navegar para agendamento
              },
            ),
            _buildMenuCard(
              title: 'Minhas Consultas',
              icon: Icons.calendar_today,
              color: AppTheme.secondaryColor,
              onTap: () {
                // TODO: Navegar para lista de consultas
              },
            ),
            _buildMenuCard(
              title: 'Médicos',
              icon: Icons.medical_services,
              color: AppTheme.accentColor,
              onTap: () {
                // TODO: Navegar para lista de médicos
              },
            ),
            _buildMenuCard(
              title: 'Perfil',
              icon: Icons.person_outline,
              color: AppTheme.infoColor,
              onTap: () {
                // TODO: Navegar para perfil
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentConsultations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultas Recentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                _buildConsultationItem(
                  doctorName: 'Dr. Maria Silva',
                  specialty: 'Cardiologia',
                  date: '15/01/2024',
                  time: '14:00',
                  status: 'Agendada',
                  statusColor: AppTheme.successColor,
                ),
                const Divider(),
                _buildConsultationItem(
                  doctorName: 'Dr. João Santos',
                  specialty: 'Dermatologia',
                  date: '10/01/2024',
                  time: '10:30',
                  status: 'Concluída',
                  statusColor: AppTheme.infoColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultationItem({
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(
            Icons.medical_services,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                specialty,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '$date às $time',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

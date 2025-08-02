import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
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
                // Header com informações do médico
                _buildDoctorHeader(authStore),

                const SizedBox(height: 30),

                // Estatísticas rápidas
                _buildQuickStats(),

                const SizedBox(height: 30),

                // Menu de funcionalidades
                _buildMenuGrid(context),

                const SizedBox(height: 30),

                // Próximas consultas
                _buildUpcomingConsultations(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorHeader(AuthStore authStore) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                authStore.userName?.substring(0, 1).toUpperCase() ?? 'D',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
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
                    'Dr. ${authStore.userName ?? 'Médico'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cardiologia', // TODO: Buscar especialidade do médico
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.verified,
              color: AppTheme.successColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas de Hoje',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Consultas',
                value: '8',
                icon: Icons.calendar_today,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Pacientes',
                value: '12',
                icon: Icons.people,
                color: AppTheme.getCardSuccess(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Avaliações',
                value: '4.8',
                icon: Icons.star,
                color: AppTheme.getCardWarning(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              overflow: TextOverflow.ellipsis,
              fontSize: 10,
            ),
          ),
        ],
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
              title: 'Agenda',
              icon: Icons.schedule,
              color: AppTheme.getCardPrimary(),
              onTap: () {
                context.push('/appointments');
              },
            ),
            _buildMenuCard(
              title: 'Consultas',
              icon: Icons.medical_services,
              color: AppTheme.getCardSecondary(),
              onTap: () {
                context.push('/consultations');
              },
            ),
            _buildMenuCard(
              title: 'Dashboard',
              icon: Icons.analytics,
              color: AppTheme.getCardWarning(),
              onTap: () {
                context.push('/dashboard');
              },
            ),
            _buildMenuCard(
              title: 'Pacientes',
              icon: Icons.people_outline,
              color: AppTheme.getCardSuccess(),
              onTap: () {
                context.push('/patients');
              },
            ),
            _buildMenuCard(
              title: 'Encontrar Médicos',
              icon: Icons.medical_services,
              color: AppTheme.getCardSecondary(),
              onTap: () {
                context.push('/doctors');
              },
            ),
            _buildMenuCard(
              title: 'Perfil',
              icon: Icons.person_outline,
              color: AppTheme.getCardInfo(),
              onTap: () {
                context.push('/profile');
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
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final brightness = theme.brightness;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.getCardBackgroundColor(color, brightness),
                  AppTheme.getCardBackgroundColor(color, brightness)
                      .withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: AppTheme.getCardBorderColor(color, brightness),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.getCardShadowColor(color, brightness),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getCardIconBackgroundColor(color, brightness),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: AppTheme.getCardTextColor(color, brightness),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.getCardTextColor(color, brightness),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingConsultations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Próximas Consultas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navegar para agenda completa
              },
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                _buildConsultationItem(
                  patientName: 'Maria Silva',
                  time: '09:00',
                  status: 'Agendada',
                  statusColor: AppTheme.successColor,
                ),
                const Divider(),
                _buildConsultationItem(
                  patientName: 'João Santos',
                  time: '10:30',
                  status: 'Em andamento',
                  statusColor: AppTheme.primaryColor,
                ),
                const Divider(),
                _buildConsultationItem(
                  patientName: 'Ana Costa',
                  time: '14:00',
                  status: 'Agendada',
                  statusColor: AppTheme.successColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultationItem({
    required String patientName,
    required String time,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patientName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Consulta às $time',
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

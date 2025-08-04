import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/patient/domain/stores/patient_dashboard_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final authStore = getIt<AuthStore>();
  final patientStore = getIt<PatientDashboardStore>();

  @override
  void initState() {
    super.initState();
    patientStore.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();
    final patientStore = getIt<PatientDashboardStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          Observer(
            builder: (context) => IconButton(
              icon: Icon(
                patientStore.isLoading ? Icons.refresh : Icons.refresh_outlined,
                color: patientStore.isLoading ? AppTheme.primaryColor : null,
              ),
              onPressed: patientStore.isLoading
                  ? null
                  : () async {
                      await patientStore.loadDashboardData();
                    },
            ),
          ),
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
          return RefreshIndicator(
            onRefresh: () async {
              await patientStore.loadDashboardData();
            },
            child: SingleChildScrollView(
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
                    'Olá, ${(authStore.userName?.split(' ')[0]) ?? 'Usuário'}!',
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
              color: AppTheme.getCardPrimary(),
              onTap: () {
                context.push('/schedule');
              },
            ),
            _buildMenuCard(
              title: 'Minhas Consultas',
              icon: Icons.calendar_today,
              color: AppTheme.getCardSuccess(),
              onTap: () {
                context.push('/consultations');
              },
            ),
            _buildMenuCard(
              title: 'Dashboard',
              icon: Icons.analytics,
              color: AppTheme.getCardSecondary(),
              onTap: () {
                context.push('/dashboard');
              },
            ),
            _buildMenuCard(
              title: 'Encontrar Médicos',
              icon: Icons.medical_services,
              color: AppTheme.getCardWarning(),
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

  Widget _buildRecentConsultations() {
    return Observer(
      builder: (context) {
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
            if (patientStore.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (patientStore.hasError)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Text(
                    'Erro: ${patientStore.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (patientStore.hasRecentConsultations)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      for (int i = 0;
                          i < patientStore.recentConsultations.length;
                          i++)
                        Column(
                          children: [
                            if (i > 0) const Divider(),
                            _buildConsultationItem(
                              doctorName: patientStore.recentConsultations[i]
                                  ['doctorName'],
                              specialty: patientStore.recentConsultations[i]
                                  ['specialty'],
                              date: patientStore.recentConsultations[i]['date'],
                              time: patientStore.recentConsultations[i]['time'],
                              status: patientStore.recentConsultations[i]
                                  ['status'],
                              statusColor: _getStatusColor(patientStore
                                  .recentConsultations[i]['statusColor']),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: const Text(
                    'Nenhuma consulta recente',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case 'success':
        return AppTheme.successColor;
      case 'primary':
        return AppTheme.primaryColor;
      case 'warning':
        return AppTheme.warningColor;
      case 'error':
        return AppTheme.errorColor;
      default:
        return AppTheme.infoColor;
    }
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

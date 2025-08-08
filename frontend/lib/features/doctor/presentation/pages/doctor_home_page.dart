import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_dashboard_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final authStore = getIt<AuthStore>();
  final dashboardStore = getIt<DoctorDashboardStore>();

  @override
  void initState() {
    super.initState();
    dashboardStore.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Observer(
            builder: (context) => IconButton(
              icon: Icon(
                dashboardStore.requestStatus == RequestStatusEnum.loading
                    ? Icons.refresh
                    : Icons.refresh_outlined,
                color: dashboardStore.requestStatus == RequestStatusEnum.loading
                    ? AppTheme.primaryColor
                    : null,
              ),
              onPressed:
                  dashboardStore.requestStatus == RequestStatusEnum.loading
                      ? null
                      : () async {
                          await dashboardStore.refreshData();
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
              context.go('/login');
            },
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await dashboardStore.refreshData();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com informações do médico
                  _buildDoctorHeader(authStore, dashboardStore),

                  const SizedBox(height: 30),

                  // Estatísticas rápidas
                  _buildQuickStats(dashboardStore),

                  const SizedBox(height: 30),

                  // Menu de funcionalidades
                  _buildMenuGrid(context),

                  const SizedBox(height: 30),

                  // Próximas consultas
                  _buildUpcomingConsultations(dashboardStore),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorHeader(
      AuthStore authStore, DoctorDashboardStore dashboardStore) {
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
                  Observer(
                    builder: (context) => Text(
                      dashboardStore.doctorSpecialty ??
                          'Especialidade não definida',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildQuickStats(DoctorDashboardStore dashboardStore) {
    return Observer(
      builder: (context) {
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
                    value: dashboardStore.todayConsultations.toString(),
                    icon: Icons.calendar_today,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Pacientes',
                    value: dashboardStore.totalPatients.toString(),
                    icon: Icons.people,
                    color: AppTheme.getCardSuccess(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Avaliações',
                    value: dashboardStore.averageRating.toStringAsFixed(1),
                    icon: Icons.star,
                    color: AppTheme.getCardWarning(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
                context.push('/doctor/schedules?doctorId=${authStore.userId}');
              },
            ),
            _buildMenuCard(
              title: 'Consultas',
              icon: Icons.medical_services,
              color: AppTheme.getCardSecondary(),
              onTap: () {
                context.push('/doctor/appointments');
              },
            ),
            // _buildMenuCard(
            //   title: 'Prescrições',
            //   icon: Icons.receipt_long,
            //   color: AppTheme.getCardInfo(),
            //   onTap: () {
            //     context.push('/prescriptions');
            //   },
            // ),
            // _buildMenuCard(
            //   title: 'Relatórios/Exames',
            //   icon: Icons.description,
            //   color: AppTheme.getCardSecondary(),
            //   onTap: () {
            //     context.push('/reports');
            //   },
            // ),
            _buildMenuCard(
              title: 'Dashboard',
              icon: Icons.analytics,
              color: AppTheme.getCardWarning(),
              onTap: () {
                context.push('/doctor/dashboard');
              },
            ),
            _buildMenuCard(
              title: 'Pacientes',
              icon: Icons.people_outline,
              color: AppTheme.getCardSuccess(),
              onTap: () {
                context.push('/doctor/patients');
              },
            ),
            // _buildMenuCard(
            //   title: 'Encontrar Médicos',
            //   icon: Icons.medical_services,
            //   color: AppTheme.getCardSecondary(),
            //   onTap: () {
            //     context.push('/doctors');
            //   },
            // ),
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

  Widget _buildUpcomingConsultations(DoctorDashboardStore dashboardStore) {
    return Observer(
      builder: (context) {
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
                    context.push('/doctor/consultations');
                  },
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (dashboardStore.requestStatus == RequestStatusEnum.loading)
              const Center(child: CircularProgressIndicator())
            else if (dashboardStore.hasError)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Text(
                    'Erro: ${dashboardStore.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (dashboardStore.hasUpcomingConsultations)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      for (int i = 0;
                          i < dashboardStore.upcomingConsultations.length;
                          i++)
                        Column(
                          children: [
                            if (i > 0) const Divider(),
                            _buildConsultationItem(
                              patientName: dashboardStore
                                  .upcomingConsultations[i]['patientName'],
                              time: dashboardStore.upcomingConsultations[i]
                                  ['time'],
                              status: dashboardStore.upcomingConsultations[i]
                                  ['status'],
                              statusColor: _getStatusColor(dashboardStore
                                  .upcomingConsultations[i]['statusColor']),
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
                    'Nenhuma consulta agendada para hoje',
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

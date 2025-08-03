import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/register_page.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:medical_consultation_app/features/chat/presentation/pages/chat_page.dart';
import 'package:medical_consultation_app/features/patient/presentation/pages/patient_home_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_home_page.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/schedule_consultation_page.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/consultation_list_page.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/consultation_detail_page.dart';
import 'package:medical_consultation_app/features/profile/presentation/pages/profile_page.dart';
import 'package:medical_consultation_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:medical_consultation_app/features/profile/presentation/pages/notification_settings_page.dart';
import 'package:medical_consultation_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:medical_consultation_app/features/dashboard/presentation/pages/notifications_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_list_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:medical_consultation_app/features/scheduling/presentation/pages/appointment_list_page.dart';
import 'package:medical_consultation_app/features/scheduling/presentation/pages/appointment_detail_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/patient_list_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_dashboard_page.dart';
import 'package:medical_consultation_app/features/shared/splash/presentation/splash_page.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/patient',
          builder: (context, state) => const PatientHomePage(),
        ),
        GoRoute(
          path: '/doctor',
          builder: (context, state) => const DoctorHomePage(),
        ),
        GoRoute(
          path: '/chat/:consultationId',
          builder: (context, state) => ChatPage(
            consultationId: state.pathParameters['consultationId']!,
          ),
        ),
        GoRoute(
          path: '/schedule',
          builder: (context, state) => const ScheduleConsultationPage(),
        ),
        GoRoute(
          path: '/consultations',
          builder: (context, state) => const ConsultationListPage(),
        ),
        GoRoute(
          path: '/consultation/:consultationId',
          builder: (context, state) => ConsultationDetailPage(
            consultationId: state.pathParameters['consultationId']!,
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: '/profile/notifications',
          builder: (context, state) => const NotificationSettingsPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/dashboard/notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '/doctors',
          builder: (context, state) => const DoctorListPage(),
        ),
        GoRoute(
          path: '/doctors/:doctorId',
          builder: (context, state) => DoctorDetailPage(
            doctorId: state.pathParameters['doctorId']!,
          ),
        ),
        GoRoute(
          path: '/doctors/favorites',
          builder: (context, state) =>
              const DoctorListPage(), // TODO: Implementar página de favoritos
        ),
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const AppointmentListPage(),
        ),
        GoRoute(
          path: '/appointments/:appointmentId',
          builder: (context, state) => AppointmentDetailPage(
            appointmentId: state.pathParameters['appointmentId']!,
          ),
        ),
        GoRoute(
          path: '/patients',
          builder: (context, state) => const PatientListPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DoctorDashboardPage(),
        ),
      ],
    );
  }
}

// Página inicial estilizada
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.8),
              colorScheme.secondary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),

                // Logo e título
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Medical Consultation',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Consultas médicas online\n24 horas por dia',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Botões de ação
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.go('/login'),
                          child: Center(
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.go('/register'),
                          child: Center(
                            child: const Text(
                              'Criar Conta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Informações adicionais
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _FeatureItem(
                        icon: Icons.security,
                        text: 'Seguro',
                      ),
                      _FeatureItem(
                        icon: Icons.access_time,
                        text: '24/7',
                      ),
                      _FeatureItem(
                        icon: Icons.medical_services,
                        text: 'Especialistas',
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

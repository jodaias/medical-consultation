import 'package:medical_consultation_app/features/appointment/presentation/pages/doctor_appointment_detail_page.dart';
import 'package:medical_consultation_app/features/appointment/presentation/pages/doctor_appointment_list_page.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/presentation/pages/doctor_schedule_edit_page.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/presentation/pages/doctor_schedule_list_page.dart';
import 'package:medical_consultation_app/features/prescription/presentation/pages/prescription_list_page.dart';
import 'package:medical_consultation_app/features/report/presentation/pages/report_list_page.dart';
import 'package:medical_consultation_app/features/prescription/presentation/pages/prescription_detail_page.dart';
import 'package:medical_consultation_app/features/report/presentation/pages/report_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/consultation_history_page.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/register_page.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:medical_consultation_app/features/chat/presentation/pages/chat_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/favorite_doctors_page.dart';
import 'package:medical_consultation_app/features/patient/presentation/pages/patient_home_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_home_page.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/schedule_consultation_page.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/consultation_list_page.dart';
import 'package:medical_consultation_app/features/consultation/presentation/pages/consultation_detail_page.dart';
import 'package:medical_consultation_app/features/profile/presentation/pages/profile_page.dart';
import 'package:medical_consultation_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:medical_consultation_app/features/profile/presentation/pages/notification_settings_page.dart';
import 'package:medical_consultation_app/features/patient/presentation/pages/patient_dashboard_page.dart';
import 'package:medical_consultation_app/features/notification/presentation/pages/notifications_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_list_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_detail_page.dart';
import 'package:medical_consultation_app/features/appointment/presentation/pages/appointment_list_page.dart';
import 'package:medical_consultation_app/features/appointment/presentation/pages/appointment_detail_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/patient_list_page.dart';
import 'package:medical_consultation_app/features/doctor/presentation/pages/doctor_dashboard_page.dart';
import 'package:medical_consultation_app/features/shared/splash/presentation/splash_page.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/presentation/pages/doctor_schedule_create_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      navigatorKey: navigatorKey,
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

        // agendamento
        GoRoute(
          path: '/doctor/schedules/create',
          builder: (context, state) => DoctorScheduleCreatePage(
            doctorId: state.uri.queryParameters['doctorId']!,
          ),
        ),
        GoRoute(
          path: '/doctor/schedules/edit',
          builder: (context, state) => DoctorScheduleEditPage(
            doctorId: state.uri.queryParameters['doctorId']!,
            schedule: state.extra as DoctorScheduleModel,
          ),
        ),
        GoRoute(
          path: '/doctor/schedules',
          builder: (context, state) => DoctorScheduleListPage(
            doctorId: state.uri.queryParameters['doctorId']!,
          ),
        ),

        // perfil
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
          path: '/chat/:consultationId',
          builder: (context, state) => ChatPage(
            consultationId: state.pathParameters['consultationId']!,
          ),
        ),
        GoRoute(
          path: '/dashboard/notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '/reports/:reportId',
          builder: (context, state) => ReportDetailPage(
            reportId: state.pathParameters['reportId']!,
          ),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportListPage(),
        ),

        // médicos
        GoRoute(
          path: '/patient/doctors',
          builder: (context, state) => const DoctorListPage(),
        ),
        GoRoute(
          path: '/patient/doctors/:doctorId',
          builder: (context, state) => DoctorDetailPage(
            doctorId: state.pathParameters['doctorId']!,
          ),
        ),
        GoRoute(
          path: '/patient/doctors/favorites',
          builder: (context, state) => const FavoriteDoctorsPage(),
        ),
        GoRoute(
          path: '/doctor/patients',
          builder: (context, state) => const PatientListPage(),
        ),

        // consultas
        GoRoute(
          path: '/patient/schedule-consultation',
          builder: (context, state) => const ScheduleConsultationPage(),
        ),
        GoRoute(
          path: '/doctor/consultation-history',
          builder: (context, state) {
            final patientId = state.uri.queryParameters['patientId'];
            final patientName = state.uri.queryParameters['patientName'];
            return ConsultationHistoryPage(
              patientId: patientId,
              patientName: patientName,
            );
          },
        ),
        GoRoute(
          path: '/consultations',
          builder: (context, state) => const ConsultationListPage(),
        ),
        // GoRoute(
        //   path: '/patient/consultations',
        //   builder: (context, state) => const ConsultationListPage(),
        // ),
        // GoRoute(
        //   path: '/doctor/consultations',
        //   builder: (context, state) => const DoctorConsultationListPage(),
        // ),
        GoRoute(
          path: '/patient/consultation/:consultationId',
          builder: (context, state) => ConsultationDetailPage(
            consultationId: state.pathParameters['consultationId']!,
          ),
        ),
        GoRoute(
          path: '/patient/appointments',
          builder: (context, state) => const AppointmentListPage(),
        ),
        GoRoute(
          path: '/patient/appointments/:appointmentId',
          builder: (context, state) => AppointmentDetailPage(
            appointmentId: state.pathParameters['appointmentId']!,
          ),
        ),
        GoRoute(
          path: '/doctor/appointments',
          builder: (context, state) => DoctorAppointmentListPage(),
        ),
        GoRoute(
          path: '/doctor/appointments/:appointmentId',
          builder: (context, state) => DoctorAppointmentDetailPage(
            appointmentId: state.pathParameters['appointmentId']!,
          ),
        ),

        // prescrições
        GoRoute(
          path: '/patient/prescriptions/:prescriptionId',
          builder: (context, state) => PrescriptionDetailPage(
            prescriptionId: state.pathParameters['prescriptionId']!,
          ),
        ),
        GoRoute(
          path: '/patient/prescriptions',
          builder: (context, state) => const PrescriptionListPage(),
        ),

        // dashboard
        GoRoute(
          path: '/doctor/dashboard',
          builder: (context, state) => const DoctorDashboardPage(),
        ),
        GoRoute(
          path: '/patient/dashboard',
          builder: (context, state) => const PatientDashboardPage(),
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
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: ClipOval(
                            child: Image.asset(
                              AppConstants.appLogo,
                              fit: BoxFit.contain,
                            ),
                          ),
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

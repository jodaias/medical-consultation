import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_consultation_app/features/auth/presentation/pages/register_page.dart';
import 'package:medical_consultation_app/features/patient/presentation/pages/patient_home_page.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
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
      ],
    );
  }
}

// Páginas temporárias para demonstração
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Consultation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao Medical Consultation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/register'),
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Páginas temporárias
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Página de Login')),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Center(child: Text('Página de Registro')),
    );
  }
}

class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Consultas')),
      body: const Center(child: Text('Lista de consultas')),
    );
  }
}

class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Paciente')),
      body: const Center(child: Text('Perfil do paciente')),
    );
  }
}

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Médico - Início')),
      body: const Center(child: Text('Página inicial do médico')),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: const Center(child: Text('Agenda do médico')),
    );
  }
}

class DoctorConsultationsPage extends StatelessWidget {
  const DoctorConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultas do Médico')),
      body: const Center(child: Text('Consultas do médico')),
    );
  }
}

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Médico')),
      body: const Center(child: Text('Perfil do médico')),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String consultationId;

  const ChatPage({super.key, required this.consultationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat - Consulta $consultationId')),
      body: Center(child: Text('Chat da consulta $consultationId')),
    );
  }
}

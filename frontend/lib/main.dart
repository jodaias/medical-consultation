import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/models/token_model.dart';
import 'package:medical_consultation_app/core/router/app_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Se já foi inicializado, não faz nada
  }

  // Initialize Hive
  if (!Hive.isAdapterRegistered(1)) {
    await Hive.initFlutter();
    Hive.registerAdapter(TokenModelAdapter());
  }

  // Configure dependency injection
  await configureDependencies();

  // Initialize storage and check auth status
  final authStore = GetIt.instance<AuthStore>();
  await authStore.checkAuthStatus();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MedicalConsultationApp());
}

class MedicalConsultationApp extends StatelessWidget {
  const MedicalConsultationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: GetIt.instance<AppRouter>().router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

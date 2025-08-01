import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/router/app_router.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Register stores
  getIt.registerLazySingleton<AuthStore>(() => AuthStore());
}

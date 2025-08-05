import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/router/app_router.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/services/notification_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';
import 'package:medical_consultation_app/core/services/file_upload_service.dart';
import 'package:medical_consultation_app/core/services/payment_service.dart';
import 'package:medical_consultation_app/core/services/report_service.dart';
import 'package:medical_consultation_app/core/services/rating_service.dart';
import 'package:medical_consultation_app/features/auth/data/services/auth_service.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/chat/domain/stores/chat_store.dart';
import 'package:medical_consultation_app/features/consultation/domain/stores/consultation_store.dart';
import 'package:medical_consultation_app/features/patient/data/services/patient_dashboard_service.dart';
import 'package:medical_consultation_app/features/profile/data/services/profile_service.dart';
import 'package:medical_consultation_app/features/profile/domain/stores/profile_store.dart';
import 'package:medical_consultation_app/features/notification/data/services/notifications_service.dart';
import 'package:medical_consultation_app/features/notification/domain/stores/notifications_store.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_service.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_store.dart';
import 'package:medical_consultation_app/features/scheduling/data/services/scheduling_service.dart';
import 'package:medical_consultation_app/features/scheduling/domain/stores/scheduling_store.dart';
import 'package:medical_consultation_app/features/patient/domain/stores/patient_store.dart';
import 'package:medical_consultation_app/features/patient/domain/stores/patient_dashboard_store.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_dashboard_store.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize API Service
  final apiService = ApiService();
  apiService.initialize();
  getIt.registerLazySingleton<ApiService>(() => apiService);

  // Initialize Storage Service
  final storageService = StorageService();
  await storageService.initialize();
  getIt.registerLazySingleton<StorageService>(() => storageService);

  // Initialize Notification Service
  final notificationService = NotificationService(storageService, apiService);
  await notificationService.initialize();
  getIt.registerLazySingleton<NotificationService>(() => notificationService);

  // Initialize File Upload Service
  final fileUploadService = FileUploadService(apiService, storageService);
  getIt.registerLazySingleton<FileUploadService>(() => fileUploadService);

  // Initialize Payment Service
  final paymentService = PaymentService(apiService, storageService);
  getIt.registerLazySingleton<PaymentService>(() => paymentService);

  // Initialize Report Service
  final reportService = ReportService(apiService, storageService);
  getIt.registerLazySingleton<ReportService>(() => reportService);

  // Initialize Rating Service
  final ratingService = RatingService(apiService, storageService);
  getIt.registerLazySingleton<RatingService>(() => ratingService);

  // Register services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<PatientDashboardService>(
      () => PatientDashboardService());
  getIt.registerLazySingleton<DoctorService>(
      () => DoctorService(getIt<ApiService>()));
  getIt.registerLazySingleton<SchedulingService>(
      () => SchedulingService(getIt<ApiService>()));
  getIt.registerLazySingleton<NotificationsService>(
      () => NotificationsService(getIt<ApiService>()));

  // Register router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Register stores
  getIt.registerLazySingleton<AuthStore>(() => AuthStore());
  getIt.registerLazySingleton<ChatStore>(() => ChatStore());
  getIt.registerLazySingleton<ConsultationStore>(() => ConsultationStore());
  getIt.registerLazySingleton<ProfileStore>(() => ProfileStore());
  getIt.registerLazySingleton<NotificationsStore>(() => NotificationsStore());
  getIt.registerLazySingleton<DoctorStore>(
      () => DoctorStore(getIt<DoctorService>()));
  getIt.registerLazySingleton<SchedulingStore>(
      () => SchedulingStore(getIt<SchedulingService>()));
  getIt.registerLazySingleton<PatientStore>(() => PatientStore());
  getIt.registerLazySingleton<PatientDashboardStore>(
      () => PatientDashboardStore());
  getIt.registerLazySingleton<DoctorDashboardStore>(
      () => DoctorDashboardStore());
}

import 'package:medical_consultation_app/features/appointment/data/services/appointment_service.dart';
import 'package:medical_consultation_app/features/appointment/data/services/doctor_appointment_service.dart';
import 'package:medical_consultation_app/features/appointment/domain/stores/appointment_store.dart';
import 'package:medical_consultation_app/features/appointment/domain/stores/doctor_appointment_store.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_dashboard_service.dart';
import 'package:medical_consultation_app/features/chat/data/services/chat_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/router/app_router.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/services/notification_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';
import 'package:medical_consultation_app/core/services/file_upload_service.dart';
import 'package:medical_consultation_app/core/services/report_service.dart';
import 'package:medical_consultation_app/core/services/rating_service.dart';
import 'package:medical_consultation_app/features/auth/data/services/auth_service.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/chat/domain/stores/chat_store.dart';
import 'package:medical_consultation_app/features/consultation/data/services/consultation_service.dart';
import 'package:medical_consultation_app/features/consultation/domain/stores/consultation_store.dart';
import 'package:medical_consultation_app/features/patient/data/services/patient_dashboard_service.dart';
import 'package:medical_consultation_app/features/profile/data/services/profile_service.dart';
import 'package:medical_consultation_app/features/profile/domain/stores/profile_store.dart';
import 'package:medical_consultation_app/features/notification/data/services/notifications_service.dart';
import 'package:medical_consultation_app/features/notification/domain/stores/notifications_store.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_service.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_store.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/services/doctor_scheduling_service.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/domain/stores/doctor_scheduling_store.dart';
import 'package:medical_consultation_app/features/patient/domain/stores/patient_store.dart';
import 'package:medical_consultation_app/features/patient/domain/stores/patient_dashboard_store.dart';
import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_dashboard_store.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize API Service
  getIt.registerLazySingleton<ApiService>(() => ApiService.instance);

  // Initialize Storage Service
  final storageService = StorageService();
  await storageService.initialize();
  getIt.registerLazySingleton<StorageService>(() => storageService);

  // Initialize Notification Service
  final notificationService =
      NotificationService(storageService, ApiService.instance);
  await notificationService.initialize();
  getIt.registerLazySingleton<NotificationService>(() => notificationService);

  // Refatoração dos services para padrão centralizado via ApiService
  // Remover instâncias diretas e garantir que todos usem ApiService.instance
  getIt.registerLazySingleton<ConsultationService>(
      () => ApiService.instance.consultationService);
  getIt.registerLazySingleton<ReportService>(
      () => ApiService.instance.reportService);
  getIt.registerLazySingleton<RatingService>(
      () => ApiService.instance.ratingService);
  getIt.registerLazySingleton<AuthService>(
      () => ApiService.instance.authService);
  getIt.registerLazySingleton<PatientDashboardService>(
      () => ApiService.instance.patientDashboardService);
  getIt.registerLazySingleton<DoctorService>(
      () => ApiService.instance.doctorService);
  getIt.registerLazySingleton<DoctorSchedulingService>(
      () => ApiService.instance.schedulingService);
  getIt.registerLazySingleton<NotificationsService>(
      () => ApiService.instance.notificationsService);
  getIt.registerLazySingleton<FileUploadService>(
      () => ApiService.instance.fileUploadService);
  getIt.registerLazySingleton<ChatService>(
      () => ApiService.instance.chatService);
  getIt.registerLazySingleton<DoctorDashboardService>(
    () => ApiService.instance.doctorDashboardService,
  );
  getIt.registerLazySingleton<ProfileService>(
    () => ApiService.instance.profileService,
  );
  getIt.registerLazySingleton<AppointmentService>(
    () => ApiService.instance.appointmentService,
  );
  getIt.registerLazySingleton<DoctorAppointmentService>(
    () => ApiService.instance.doctorAppointmentService,
  );

  // Register router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Register stores
  getIt.registerLazySingleton<AuthStore>(() => AuthStore());
  getIt.registerLazySingleton<ChatStore>(() => ChatStore());
  getIt.registerLazySingleton<ConsultationStore>(() => ConsultationStore());
  getIt.registerLazySingleton<ProfileStore>(() => ProfileStore());
  getIt.registerLazySingleton<NotificationsStore>(() => NotificationsStore());
  getIt.registerLazySingleton<DoctorStore>(() => DoctorStore());
  getIt.registerLazySingleton<DoctorSchedulingStore>(
      () => DoctorSchedulingStore());
  getIt.registerLazySingleton<PatientStore>(() => PatientStore());
  getIt.registerLazySingleton<PatientDashboardStore>(
      () => PatientDashboardStore());
  getIt.registerLazySingleton<DoctorDashboardStore>(
      () => DoctorDashboardStore());
  getIt.registerLazySingleton<AppointmentStore>(() => AppointmentStore());
  getIt.registerLazySingleton<DoctorAppointmentStore>(
      () => DoctorAppointmentStore());
}

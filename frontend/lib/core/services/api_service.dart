import 'package:medical_consultation_app/features/profile/data/services/profile_service.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_dashboard_service.dart';
import 'package:medical_consultation_app/features/consultation/data/services/consultation_service.dart';
import 'package:medical_consultation_app/features/chat/data/services/chat_service.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/auth/data/services/auth_service.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';
import 'package:medical_consultation_app/core/services/rating_service.dart';
import 'package:medical_consultation_app/core/services/report_service.dart';
import 'package:medical_consultation_app/features/patient/data/services/patient_dashboard_service.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_service.dart';
import 'package:medical_consultation_app/features/scheduling/data/services/scheduling_service.dart';
import 'package:medical_consultation_app/features/notification/data/services/notifications_service.dart';
import 'package:medical_consultation_app/core/services/file_upload_service.dart';

class ApiService extends Rest {
  @override
  String get restUrl => AppConstants.baseUrl;

  static ApiService instance = ApiService._();

  late final ProfileService _profileService;
  ProfileService get profileService => _profileService;

  late final ChatService _chatService;
  ChatService get chatService => _chatService;

  late final AuthService _authService;
  AuthService get authService => _authService;

  late final RatingService _ratingService;
  RatingService get ratingService => _ratingService;

  late final ReportService _reportService;
  ReportService get reportService => _reportService;

  late final ConsultationService _consultationService;
  ConsultationService get consultationService => _consultationService;

  late final PatientDashboardService _patientDashboardService;
  PatientDashboardService get patientDashboardService =>
      _patientDashboardService;

  late final DoctorService _doctorService;
  DoctorService get doctorService => _doctorService;

  late final SchedulingService _schedulingService;
  SchedulingService get schedulingService => _schedulingService;

  late final NotificationsService _notificationsService;
  NotificationsService get notificationsService => _notificationsService;

  late final FileUploadService _fileUploadService;
  FileUploadService get fileUploadService => _fileUploadService;

  late final DoctorDashboardService _doctorDashboardService;
  DoctorDashboardService get doctorDashboardService => _doctorDashboardService;

  ApiService._() {
    _profileService = ProfileService(this);
    _authService = AuthService(this);
    _ratingService = RatingService(this);
    _reportService = ReportService(this);
    _patientDashboardService = PatientDashboardService(this);
    _doctorDashboardService = DoctorDashboardService(this);
    _doctorService = DoctorService(this);
    _schedulingService = SchedulingService(this);
    _notificationsService = NotificationsService(this);
    _fileUploadService = FileUploadService(this);
    _chatService = ChatService(this);
    _consultationService = ConsultationService(this);
  }

  Future<bool> refreshToken() async {
    try {
      final storageService = getIt<StorageService>();
      final refreshToken = await storageService.getRefreshToken();

      if (refreshToken == null) return false;

      final result = await postModel('/users/refresh', {
        'refreshToken': refreshToken,
      });

      if (result.success) {
        final newToken = result.data['data']['token'];
        final newRefreshToken = result.data['data']['refreshToken'];

        await storageService.saveToken(newToken);
        await storageService.saveRefreshToken(newRefreshToken);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}

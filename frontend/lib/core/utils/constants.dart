class AppConstants {
  static const String appName = 'Medical Consultation';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String socketUrl = 'http://localhost:3000';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;

  // Image Constants
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String appLogo = 'assets/images/app_logo.png';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPassword =
      'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String invalidPhone = 'Please enter a valid phone number';

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String sessionExpired = 'Session expired. Please login again.';

  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String profileUpdated = 'Profile updated successfully';
  static const String consultationScheduled =
      'Consultation scheduled successfully';
  static const String messageSent = 'Message sent successfully';

  // User Types
  static const String patientType = 'PATIENT';
  static const String doctorType = 'DOCTOR';

  // Consultation Status
  static const String scheduledStatus = 'SCHEDULED';
  static const String inProgressStatus = 'IN_PROGRESS';
  static const String completedStatus = 'COMPLETED';
  static const String cancelledStatus = 'CANCELLED';
  static const String noShowStatus = 'NO_SHOW';

  // Message Types
  static const String textMessage = 'TEXT';
  static const String imageMessage = 'IMAGE';
  static const String fileMessage = 'FILE';
  static const String audioMessage = 'AUDIO';

  // Gender Options
  static const String maleGender = 'MALE';
  static const String femaleGender = 'FEMALE';
  static const String otherGender = 'OTHER';

  // Days of Week
  static const List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Specialties
  static const List<String> specialties = [
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'General Medicine',
    'Gynecology',
    'Neurology',
    'Oncology',
    'Ophthalmology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Pulmonology',
    'Radiology',
    'Urology',
  ];
}

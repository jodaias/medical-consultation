class AppConstants {
  static const String appName = 'Medical Consultation';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl =
      'https://medical-consultation-api.onrender.com/api';
  static const String socketUrl =
      'https://medical-consultation-api.onrender.com';

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
  static const String requiredField = 'Este campo é obrigatório';
  static const String invalidEmail = 'Digite um email válido';
  static const String invalidPassword =
      'Senha deve ter pelo menos 8 caracteres, uma letra maiúscula, uma letra minúscula, um número e um caractere especial';
  static const String passwordMismatch = 'As senhas não coincidem';
  static const String invalidPhone = 'Digite um telefone válido';
  static const String invalidSpecialty =
      'Especialidade inválida. Selecione da lista.';

  // Error Messages
  static const String networkError = 'Erro de conexão. Verifique sua internet.';
  static const String serverError = 'Erro do servidor. Tente novamente.';
  static const String unknownError = 'Ocorreu um erro desconhecido.';
  static const String sessionExpired = 'Sessão expirada. Faça login novamente.';

  // Success Messages
  static const String loginSuccess = 'Login realizado com sucesso';
  static const String registerSuccess = 'Conta criada com sucesso';
  static const String profileUpdated = 'Perfil atualizado com sucesso';
  static const String consultationScheduled = 'Consulta agendada com sucesso';
  static const String messageSent = 'Mensagem enviada com sucesso';

  // User Types
  static const String patientType = 'PATIENT';
  static const String doctorType = 'DOCTOR';

  // Consultation Status
  static const String scheduledStatus = 'SCHEDULED';
  static const String inProgressStatus = 'IN_PROGRESS';
  static const String completedStatus = 'COMPLETED';
  static const String cancelledStatus = 'CANCELLED';
  static const String noShowStatus = 'NO_SHOW';
  static const String allStatus = 'ALL';

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
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  // Specialties
  static const List<String> specialties = [
    'Acupuntura',
    'Alergologia',
    'Anestesiologia',
    'Angiologia',
    'Cardiologia',
    'Cirurgia Cardiovascular',
    'Cirurgia da Mão',
    'Cirurgia de Cabeça e Pescoço',
    'Cirurgia do Aparelho Digestivo',
    'Cirurgia Geral',
    'Cirurgia Pediátrica',
    'Cirurgia Plástica',
    'Cirurgia Torácica',
    'Cirurgia Vascular',
    'Clínica Médica',
    'Coloproctologia',
    'Dermatologia',
    'Endocrinologia e Metabologia',
    'Endoscopia',
    'Gastroenterologia',
    'Genética Médica',
    'Geriatria',
    'Ginecologia e Obstetrícia',
    'Hematologia e Hemoterapia',
    'Homeopatia',
    'Infectologia',
    'Mastologia',
    'Medicina de Família e Comunidade',
    'Medicina do Trabalho',
    'Medicina de Tráfego',
    'Medicina Esportiva',
    'Medicina Física e Reabilitação',
    'Medicina Intensiva',
    'Medicina Legal e Perícia Médica',
    'Medicina Nuclear',
    'Medicina Preventiva e Social',
    'Nefrologia',
    'Neurocirurgia',
    'Neurologia',
    'Nutrologia',
    'Oftalmologia',
    'Oncologia Clínica',
    'Ortopedia e Traumatologia',
    'Otorrinolaringologia',
    'Patologia',
    'Patologia Clínica/Medicina Laboratorial',
    'Pediatria',
    'Pneumologia',
    'Psiquiatria',
    'Radiologia e Diagnóstico por Imagem',
    'Radioterapia',
    'Reumatologia',
    'Urologia',
  ];
}

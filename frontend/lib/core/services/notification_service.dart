import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

@injectable
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StorageService _storageService;
  final ApiService _apiService;

  NotificationService(this._storageService, this._apiService);

  // Stream para notificações recebidas
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  Future<void> initialize() async {
    try {
      // Inicializar Firebase
      await Firebase.initializeApp();

      // Configurar notificações locais
      await _setupLocalNotifications();

      // Configurar Firebase Messaging
      await _setupFirebaseMessaging();

      // Solicitar permissões
      await _requestPermissions();

      // Configurar handlers
      _setupMessageHandlers();

      print('NotificationService inicializado com sucesso');
    } catch (e) {
      print('Erro ao inicializar NotificationService: $e');
    }
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _setupFirebaseMessaging() async {
    // Configurar handlers para diferentes estados do app
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Obter token FCM
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
      await sendTokenToServer(token);
    }

    // Listener para mudanças no token
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _saveFCMToken(newToken);
      await sendTokenToServer(newToken);
    });
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Permissões de notificação: ${settings.authorizationStatus}');
  }

  void _setupMessageHandlers() {
    // Handler para mensagens em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Handler para quando o app é aberto através da notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundMessage(message);
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Notificação recebida em primeiro plano: ${message.data}');

    // Mostrar notificação local
    await _showLocalNotification(message);

    // Adicionar à stream para que o app possa reagir
    _notificationController.add(message.data);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Notificação recebida em segundo plano: ${message.data}');

    // Navegar para a tela apropriada baseada no tipo de notificação
    _handleNotificationNavigation(message.data);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medical_consultation_channel',
      'Consultas Médicas',
      channelDescription: 'Notificações de consultas médicas',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Nova notificação',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final data = json.decode(response.payload!);
      _handleNotificationNavigation(data);
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    final context = navigatorKey.currentContext;
    if (context == null) return;

    switch (type) {
      case 'new_message':
        final consultationId = data['consultationId'];
        if (consultationId != null) {
          context.go('/chat/$consultationId');
        }
        break;
      case 'consultation':
      case 'consultation_update':
      case 'consultation_cancel':
        final consultationId = data['consultationId'];
        if (consultationId != null) {
          context.go('/consultation/$consultationId');
        }
        break;
      case 'prescription':
        final prescriptionId = data['prescriptionId'];
        if (prescriptionId != null) {
          context.go('/prescriptions/$prescriptionId');
        } else {
          context.go('/profile');
        }
        break;
      case 'report':
        final reportId = data['reportId'];
        if (reportId != null) {
          context.go('/reports/$reportId');
        } else {
          context.go('/profile');
        }
        break;
      default:
        context.go('/');
        break;
    }
  }

  Future<void> _saveFCMToken(String token) async {
    await _storageService.saveFCMToken(token);
  }

  // Enviar token FCM para o servidor seguindo novo padrão
  Future<RestResult<dynamic>> sendTokenToServer(String token) async {
    final userId = await _storageService.getUserId();
    if (userId != null) {
      return await _apiService.postModel(
        '/notifications/register-token',
        {
          'userId': userId,
          'token': token,
          'platform': 'mobile',
        },
      );
    }
    return RestResult<dynamic>()..error = Exception('Usuário não encontrado');
  }

  // Métodos públicos para gerenciar notificações
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> subscribeToUserNotifications(String userId) async {
    await subscribeToTopic('user_$userId');
  }

  Future<void> subscribeToConsultationNotifications(
      String consultationId) async {
    await subscribeToTopic('consultation_$consultationId');
  }

  Future<void> unsubscribeFromConsultationNotifications(
      String consultationId) async {
    await unsubscribeFromTopic('consultation_$consultationId');
  }

  // Enviar notificação local
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medical_consultation_channel',
      'Consultas Médicas',
      channelDescription: 'Notificações de consultas médicas',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Limpar todas as notificações
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Obter token FCM atual
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Verificar se as notificações estão habilitadas
  Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  void dispose() {
    _notificationController.close();
  }
}

// Handler para mensagens em background (deve ser uma função top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Mensagem em background: ${message.data}');
}

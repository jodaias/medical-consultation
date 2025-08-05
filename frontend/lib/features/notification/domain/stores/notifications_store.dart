import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/notification/data/services/notifications_service.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/notification/data/models/notification_model.dart';

part 'notifications_store.g.dart';

@injectable
class NotificationsStore = NotificationsStoreBase with _$NotificationsStore;

abstract class NotificationsStoreBase with Store {
  final _notificationService = getIt<NotificationsService>();

  @observable
  ObservableList<NotificationModel> notifications =
      ObservableList<NotificationModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get hasNotifications => notifications.isNotEmpty;

  @computed
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  @computed
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  @computed
  List<NotificationModel> get recentNotifications =>
      notifications.take(5).toList();

  @action
  Future<void> loadNotifications({int? limit, int? offset}) async {
    try {
      isLoading = true;
      errorMessage = null;

      final notificationsList = await _notificationService.getNotifications(
          limit: limit, offset: offset);
      notifications.clear();
      notifications.addAll(notificationsList);
    } catch (e) {
      errorMessage = 'Erro ao carregar notificações: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationService.markNotificationAsRead(notificationId);

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = notifications[index];
        notifications[index] = notification.copyWith(isRead: true);
      }
    } catch (e) {
      errorMessage = 'Erro ao marcar notificação como lida: $e';
    }
  }

  @action
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _notificationService.markAllNotificationsAsRead();

      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    } catch (e) {
      errorMessage = 'Erro ao marcar todas as notificações como lidas: $e';
    }
  }

  @action
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      notifications.removeWhere((n) => n.id == notificationId);
    } catch (e) {
      errorMessage = 'Erro ao deletar notificação: $e';
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void reset() {
    notifications.clear();
    isLoading = false;
    errorMessage = null;
  }
}

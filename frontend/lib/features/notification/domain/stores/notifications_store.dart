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
    isLoading = true;
    errorMessage = null;
    final result = await _notificationService.getNotifications(
        limit: limit, offset: offset);
    if (result.success) {
      notifications.clear();
      notifications.addAll(result.data);
    } else {
      errorMessage =
          'Erro ao carregar notificações: ${result.error?.toString() ?? ''}';
    }
    isLoading = false;
  }

  @action
  Future<void> markNotificationAsRead(String notificationId) async {
    final result =
        await _notificationService.markNotificationAsRead(notificationId);
    if (result.success) {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = notifications[index];
        notifications[index] = notification.copyWith(isRead: true);
      }
    } else {
      errorMessage =
          'Erro ao marcar notificação como lida: ${result.error?.toString() ?? ''}';
    }
  }

  @action
  Future<void> markAllNotificationsAsRead() async {
    final result = await _notificationService.markAllNotificationsAsRead();
    if (result.success) {
      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    } else {
      errorMessage =
          'Erro ao marcar todas as notificações como lidas: ${result.error?.toString() ?? ''}';
    }
  }

  @action
  Future<void> deleteNotification(String notificationId) async {
    final result =
        await _notificationService.deleteNotification(notificationId);
    if (result.success) {
      notifications.removeWhere((n) => n.id == notificationId);
    } else {
      errorMessage =
          'Erro ao deletar notificação: ${result.error?.toString() ?? ''}';
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationsStore on NotificationsStoreBase, Store {
  Computed<bool>? _$hasNotificationsComputed;

  @override
  bool get hasNotifications => (_$hasNotificationsComputed ??= Computed<bool>(
          () => super.hasNotifications,
          name: 'NotificationsStoreBase.hasNotifications'))
      .value;
  Computed<int>? _$unreadNotificationsCountComputed;

  @override
  int get unreadNotificationsCount => (_$unreadNotificationsCountComputed ??=
          Computed<int>(() => super.unreadNotificationsCount,
              name: 'NotificationsStoreBase.unreadNotificationsCount'))
      .value;
  Computed<List<NotificationModel>>? _$unreadNotificationsComputed;

  @override
  List<NotificationModel> get unreadNotifications =>
      (_$unreadNotificationsComputed ??= Computed<List<NotificationModel>>(
              () => super.unreadNotifications,
              name: 'NotificationsStoreBase.unreadNotifications'))
          .value;
  Computed<List<NotificationModel>>? _$recentNotificationsComputed;

  @override
  List<NotificationModel> get recentNotifications =>
      (_$recentNotificationsComputed ??= Computed<List<NotificationModel>>(
              () => super.recentNotifications,
              name: 'NotificationsStoreBase.recentNotifications'))
          .value;

  late final _$notificationsAtom =
      Atom(name: 'NotificationsStoreBase.notifications', context: context);

  @override
  ObservableList<NotificationModel> get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(ObservableList<NotificationModel> value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'NotificationsStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'NotificationsStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadNotificationsAsyncAction =
      AsyncAction('NotificationsStoreBase.loadNotifications', context: context);

  @override
  Future<void> loadNotifications({int? limit, int? offset}) {
    return _$loadNotificationsAsyncAction
        .run(() => super.loadNotifications(limit: limit, offset: offset));
  }

  late final _$markNotificationAsReadAsyncAction = AsyncAction(
      'NotificationsStoreBase.markNotificationAsRead',
      context: context);

  @override
  Future<void> markNotificationAsRead(String notificationId) {
    return _$markNotificationAsReadAsyncAction
        .run(() => super.markNotificationAsRead(notificationId));
  }

  late final _$markAllNotificationsAsReadAsyncAction = AsyncAction(
      'NotificationsStoreBase.markAllNotificationsAsRead',
      context: context);

  @override
  Future<void> markAllNotificationsAsRead() {
    return _$markAllNotificationsAsReadAsyncAction
        .run(() => super.markAllNotificationsAsRead());
  }

  late final _$deleteNotificationAsyncAction = AsyncAction(
      'NotificationsStoreBase.deleteNotification',
      context: context);

  @override
  Future<void> deleteNotification(String notificationId) {
    return _$deleteNotificationAsyncAction
        .run(() => super.deleteNotification(notificationId));
  }

  late final _$NotificationsStoreBaseActionController =
      ActionController(name: 'NotificationsStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$NotificationsStoreBaseActionController.startAction(
        name: 'NotificationsStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$NotificationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$NotificationsStoreBaseActionController.startAction(
        name: 'NotificationsStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$NotificationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
notifications: ${notifications},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasNotifications: ${hasNotifications},
unreadNotificationsCount: ${unreadNotificationsCount},
unreadNotifications: ${unreadNotifications},
recentNotifications: ${recentNotifications}
    ''';
  }
}

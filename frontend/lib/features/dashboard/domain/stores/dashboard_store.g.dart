// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardStore on DashboardStoreBase, Store {
  Computed<bool>? _$hasStatsComputed;

  @override
  bool get hasStats =>
      (_$hasStatsComputed ??= Computed<bool>(() => super.hasStats,
              name: 'DashboardStoreBase.hasStats'))
          .value;
  Computed<bool>? _$hasNotificationsComputed;

  @override
  bool get hasNotifications => (_$hasNotificationsComputed ??= Computed<bool>(
          () => super.hasNotifications,
          name: 'DashboardStoreBase.hasNotifications'))
      .value;
  Computed<int>? _$unreadNotificationsCountComputed;

  @override
  int get unreadNotificationsCount => (_$unreadNotificationsCountComputed ??=
          Computed<int>(() => super.unreadNotificationsCount,
              name: 'DashboardStoreBase.unreadNotificationsCount'))
      .value;
  Computed<List<NotificationModel>>? _$unreadNotificationsComputed;

  @override
  List<NotificationModel> get unreadNotifications =>
      (_$unreadNotificationsComputed ??= Computed<List<NotificationModel>>(
              () => super.unreadNotifications,
              name: 'DashboardStoreBase.unreadNotifications'))
          .value;
  Computed<List<NotificationModel>>? _$recentNotificationsComputed;

  @override
  List<NotificationModel> get recentNotifications =>
      (_$recentNotificationsComputed ??= Computed<List<NotificationModel>>(
              () => super.recentNotifications,
              name: 'DashboardStoreBase.recentNotifications'))
          .value;

  late final _$statsAtom =
      Atom(name: 'DashboardStoreBase.stats', context: context);

  @override
  DashboardStatsModel? get stats {
    _$statsAtom.reportRead();
    return super.stats;
  }

  @override
  set stats(DashboardStatsModel? value) {
    _$statsAtom.reportWrite(value, super.stats, () {
      super.stats = value;
    });
  }

  late final _$notificationsAtom =
      Atom(name: 'DashboardStoreBase.notifications', context: context);

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
      Atom(name: 'DashboardStoreBase.isLoading', context: context);

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
      Atom(name: 'DashboardStoreBase.errorMessage', context: context);

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

  late final _$chartDataAtom =
      Atom(name: 'DashboardStoreBase.chartData', context: context);

  @override
  Map<String, dynamic> get chartData {
    _$chartDataAtom.reportRead();
    return super.chartData;
  }

  @override
  set chartData(Map<String, dynamic> value) {
    _$chartDataAtom.reportWrite(value, super.chartData, () {
      super.chartData = value;
    });
  }

  late final _$reportsAtom =
      Atom(name: 'DashboardStoreBase.reports', context: context);

  @override
  Map<String, dynamic> get reports {
    _$reportsAtom.reportRead();
    return super.reports;
  }

  @override
  set reports(Map<String, dynamic> value) {
    _$reportsAtom.reportWrite(value, super.reports, () {
      super.reports = value;
    });
  }

  late final _$realTimeMetricsAtom =
      Atom(name: 'DashboardStoreBase.realTimeMetrics', context: context);

  @override
  Map<String, dynamic> get realTimeMetrics {
    _$realTimeMetricsAtom.reportRead();
    return super.realTimeMetrics;
  }

  @override
  set realTimeMetrics(Map<String, dynamic> value) {
    _$realTimeMetricsAtom.reportWrite(value, super.realTimeMetrics, () {
      super.realTimeMetrics = value;
    });
  }

  late final _$alertsAndInsightsAtom =
      Atom(name: 'DashboardStoreBase.alertsAndInsights', context: context);

  @override
  List<Map<String, dynamic>> get alertsAndInsights {
    _$alertsAndInsightsAtom.reportRead();
    return super.alertsAndInsights;
  }

  @override
  set alertsAndInsights(List<Map<String, dynamic>> value) {
    _$alertsAndInsightsAtom.reportWrite(value, super.alertsAndInsights, () {
      super.alertsAndInsights = value;
    });
  }

  late final _$selectedPeriodAtom =
      Atom(name: 'DashboardStoreBase.selectedPeriod', context: context);

  @override
  String get selectedPeriod {
    _$selectedPeriodAtom.reportRead();
    return super.selectedPeriod;
  }

  @override
  set selectedPeriod(String value) {
    _$selectedPeriodAtom.reportWrite(value, super.selectedPeriod, () {
      super.selectedPeriod = value;
    });
  }

  late final _$isRefreshingAtom =
      Atom(name: 'DashboardStoreBase.isRefreshing', context: context);

  @override
  bool get isRefreshing {
    _$isRefreshingAtom.reportRead();
    return super.isRefreshing;
  }

  @override
  set isRefreshing(bool value) {
    _$isRefreshingAtom.reportWrite(value, super.isRefreshing, () {
      super.isRefreshing = value;
    });
  }

  late final _$loadDashboardStatsAsyncAction =
      AsyncAction('DashboardStoreBase.loadDashboardStats', context: context);

  @override
  Future<void> loadDashboardStats({String? period}) {
    return _$loadDashboardStatsAsyncAction
        .run(() => super.loadDashboardStats(period: period));
  }

  late final _$loadNotificationsAsyncAction =
      AsyncAction('DashboardStoreBase.loadNotifications', context: context);

  @override
  Future<void> loadNotifications({int? limit, int? offset}) {
    return _$loadNotificationsAsyncAction
        .run(() => super.loadNotifications(limit: limit, offset: offset));
  }

  late final _$markNotificationAsReadAsyncAction = AsyncAction(
      'DashboardStoreBase.markNotificationAsRead',
      context: context);

  @override
  Future<void> markNotificationAsRead(String notificationId) {
    return _$markNotificationAsReadAsyncAction
        .run(() => super.markNotificationAsRead(notificationId));
  }

  late final _$markAllNotificationsAsReadAsyncAction = AsyncAction(
      'DashboardStoreBase.markAllNotificationsAsRead',
      context: context);

  @override
  Future<void> markAllNotificationsAsRead() {
    return _$markAllNotificationsAsReadAsyncAction
        .run(() => super.markAllNotificationsAsRead());
  }

  late final _$deleteNotificationAsyncAction =
      AsyncAction('DashboardStoreBase.deleteNotification', context: context);

  @override
  Future<void> deleteNotification(String notificationId) {
    return _$deleteNotificationAsyncAction
        .run(() => super.deleteNotification(notificationId));
  }

  late final _$loadChartDataAsyncAction =
      AsyncAction('DashboardStoreBase.loadChartData', context: context);

  @override
  Future<void> loadChartData({String? chartType}) {
    return _$loadChartDataAsyncAction
        .run(() => super.loadChartData(chartType: chartType));
  }

  late final _$loadReportsAsyncAction =
      AsyncAction('DashboardStoreBase.loadReports', context: context);

  @override
  Future<void> loadReports({String? reportType}) {
    return _$loadReportsAsyncAction
        .run(() => super.loadReports(reportType: reportType));
  }

  late final _$loadRealTimeMetricsAsyncAction =
      AsyncAction('DashboardStoreBase.loadRealTimeMetrics', context: context);

  @override
  Future<void> loadRealTimeMetrics() {
    return _$loadRealTimeMetricsAsyncAction
        .run(() => super.loadRealTimeMetrics());
  }

  late final _$loadAlertsAndInsightsAsyncAction =
      AsyncAction('DashboardStoreBase.loadAlertsAndInsights', context: context);

  @override
  Future<void> loadAlertsAndInsights() {
    return _$loadAlertsAndInsightsAsyncAction
        .run(() => super.loadAlertsAndInsights());
  }

  late final _$exportDashboardDataAsyncAction =
      AsyncAction('DashboardStoreBase.exportDashboardData', context: context);

  @override
  Future<void> exportDashboardData({String? format}) {
    return _$exportDashboardDataAsyncAction
        .run(() => super.exportDashboardData(format: format));
  }

  late final _$refreshDashboardAsyncAction =
      AsyncAction('DashboardStoreBase.refreshDashboard', context: context);

  @override
  Future<void> refreshDashboard() {
    return _$refreshDashboardAsyncAction.run(() => super.refreshDashboard());
  }

  late final _$DashboardStoreBaseActionController =
      ActionController(name: 'DashboardStoreBase', context: context);

  @override
  void setPeriod(String period) {
    final _$actionInfo = _$DashboardStoreBaseActionController.startAction(
        name: 'DashboardStoreBase.setPeriod');
    try {
      return super.setPeriod(period);
    } finally {
      _$DashboardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$DashboardStoreBaseActionController.startAction(
        name: 'DashboardStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$DashboardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$DashboardStoreBaseActionController.startAction(
        name: 'DashboardStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$DashboardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
stats: ${stats},
notifications: ${notifications},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
chartData: ${chartData},
reports: ${reports},
realTimeMetrics: ${realTimeMetrics},
alertsAndInsights: ${alertsAndInsights},
selectedPeriod: ${selectedPeriod},
isRefreshing: ${isRefreshing},
hasStats: ${hasStats},
hasNotifications: ${hasNotifications},
unreadNotificationsCount: ${unreadNotificationsCount},
unreadNotifications: ${unreadNotifications},
recentNotifications: ${recentNotifications}
    ''';
  }
}

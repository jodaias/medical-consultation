import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/features/notification/data/models/notification_model.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/notification/domain/stores/notifications_store.dart';
import 'package:medical_consultation_app/features/patient/domain/stores/patient_dashboard_store.dart';
import 'package:medical_consultation_app/features/shared/dashboard/models/dashboard_stats_model.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  final _patientDashboardStore = getIt<PatientDashboardStore>();
  final _notificationsStore = getIt<NotificationsStore>();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    await _patientDashboardStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/dashboard/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_patientDashboardStore.requestStatus ==
              RequestStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_patientDashboardStore.errorMessage != null) {
            return _buildErrorWidget();
          }

          return RefreshIndicator(
            onRefresh: _loadDashboardData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 24),
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  _buildChartsSection(),
                  const SizedBox(height: 24),
                  _buildRecentActivity(),
                  const SizedBox(height: 24),
                  _buildAlertsAndInsights(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Período',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Observer(
              builder: (_) => Row(
                children: [
                  _buildPeriodChip('week', 'Semana'),
                  const SizedBox(width: 8),
                  _buildPeriodChip('month', 'Mês'),
                  const SizedBox(width: 8),
                  _buildPeriodChip('quarter', 'Trimestre'),
                  const SizedBox(width: 8),
                  _buildPeriodChip('year', 'Ano'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String period, String label) {
    return Observer(
      builder: (_) => FilterChip(
        label: Text(label),
        selected: _patientDashboardStore.selectedPeriod == period,
        onSelected: (selected) {
          if (selected) {
            _patientDashboardStore.setPeriod(period);
          }
        },
        selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildStatsCards() {
    return Observer(
      builder: (_) {
        final stats = _patientDashboardStore.stats;
        if (stats == null) return const SizedBox.shrink();

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total de Consultas',
              stats.totalConsultations.toString(),
              Icons.medical_services,
              AppTheme.primaryColor,
            ),
            _buildStatCard(
              'Consultas Concluídas',
              stats.completedConsultations.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              'Taxa de Conclusão',
              '${stats.completionRate.toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.blue,
            ),
            _buildStatCard(
              'Avaliação Média',
              stats.averageRating.toStringAsFixed(1),
              Icons.star,
              Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gráficos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                final stats = _patientDashboardStore.stats;
                if (stats == null) return const SizedBox.shrink();

                return Column(
                  children: [
                    _buildConsultationsChart(stats),
                    const SizedBox(height: 24),
                    _buildRatingsChart(stats),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationsChart(DashboardStatsModel stats) {
    final data = stats.consultationsByMonth.entries.toList();
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultas por Mês',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: data
                      .map((e) => e.value.toDouble())
                      .reduce((a, b) => a > b ? a : b) *
                  1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return Text(
                          data[value.toInt()].key,
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: item.value.toDouble(),
                      color: AppTheme.primaryColor,
                      width: 20,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingsChart(DashboardStatsModel stats) {
    final data = stats.ratingsByMonth.entries.toList();
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avaliações por Mês',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return Text(
                          data[value.toInt()].key,
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: data.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.value);
                  }).toList(),
                  isCurved: true,
                  color: AppTheme.secondaryColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Atividade Recente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.push('/dashboard/activity'),
                  child: const Text('Ver Todas'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                final notifications = _notificationsStore.recentNotifications;
                if (notifications.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Nenhuma atividade recente'),
                    ),
                  );
                }

                return Column(
                  children: notifications.map((notification) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            _getNotificationColor(notification.type),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notification.message),
                      trailing: Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      onTap: () => _onNotificationTap(notification),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsAndInsights() {
    return Observer(
      builder: (_) {
        final alerts = _patientDashboardStore.alertsAndInsights;
        if (alerts.isEmpty) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alertas e Insights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...alerts.map((alert) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getAlertColor(alert['type'] ?? 'info')
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getAlertColor(alert['type'] ?? 'info'),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getAlertIcon(alert['type'] ?? 'info'),
                          color: _getAlertColor(alert['type'] ?? 'info'),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert['title'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              if (alert['message'] != null)
                                Text(
                                  alert['message'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Observer(
            builder: (_) => Text(
              _patientDashboardStore.errorMessage ?? 'Erro desconhecido',
              style: TextStyle(color: AppTheme.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDashboardData,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'consultation':
        return AppTheme.primaryColor;
      case 'new_message':
        return Colors.blue;
      case 'system':
        return Colors.grey;
      case 'reminder':
        return Colors.orange;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'consultation':
        return Icons.medical_services;
      case 'message':
        return Icons.message;
      case 'system':
        return Icons.info;
      case 'reminder':
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }

  Color _getAlertColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
      default:
        return Icons.info;
    }
  }

  void _onNotificationTap(NotificationModel notification) {
    _notificationsStore.markNotificationAsRead(notification.id);

    if (notification.consultationId != null) {
      context.push('/consultation/${notification.consultationId}');
    }
  }
}

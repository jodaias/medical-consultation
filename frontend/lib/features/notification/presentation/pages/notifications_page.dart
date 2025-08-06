import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/features/notification/domain/stores/notifications_store.dart';
import 'package:medical_consultation_app/features/notification/data/models/notification_model.dart';
import 'package:medical_consultation_app/core/di/injection.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _notificationsStore = getIt<NotificationsStore>();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await _notificationsStore.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        elevation: 0,
        actions: [
          Observer(
            builder: (_) {
              if (_notificationsStore.unreadNotificationsCount > 0) {
                return TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text('Marcar Todas'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_notificationsStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_notificationsStore.errorMessage != null) {
            return _buildErrorWidget();
          }

          if (_notificationsStore.notifications.isEmpty) {
            return _buildEmptyWidget();
          }

          return RefreshIndicator(
            onRefresh: _loadNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notificationsStore.notifications.length,
              itemBuilder: (context, index) {
                final notification = _notificationsStore.notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              notification.timeAgo,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _onMenuAction(value, notification),
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16),
                    SizedBox(width: 8),
                    Text('Marcar como lida'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16),
                  SizedBox(width: 8),
                  Text('Deletar'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _onNotificationTap(notification),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma notificação',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você não tem notificações no momento',
            style: TextStyle(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
            'Erro ao carregar notificações',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Observer(
            builder: (_) => Text(
              _notificationsStore.errorMessage ?? 'Erro desconhecido',
              style: TextStyle(color: AppTheme.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadNotifications,
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
      case 'message':
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

  void _onNotificationTap(NotificationModel notification) {
    if (!notification.isRead) {
      _notificationsStore.markNotificationAsRead(notification.id);
    }

    if (notification.consultationId != null) {
      context.push('/consultation/${notification.consultationId}');
    }
  }

  void _onMenuAction(String action, NotificationModel notification) {
    switch (action) {
      case 'mark_read':
        _notificationsStore.markNotificationAsRead(notification.id);
        break;
      case 'delete':
        _showDeleteDialog(notification);
        break;
    }
  }

  void _markAllAsRead() {
    _notificationsStore.markAllNotificationsAsRead();
  }

  void _showDeleteDialog(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Notificação'),
        content:
            Text('Tem certeza que deseja deletar "${notification.title}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _notificationsStore.deleteNotification(notification.id);
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}

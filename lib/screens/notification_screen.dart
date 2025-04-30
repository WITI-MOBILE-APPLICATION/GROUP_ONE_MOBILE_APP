// @dart=2.17

import 'package:flutter/material.dart';
import 'app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
    });

    // Simulate loading notifications from an API or database
    await Future.delayed(const Duration(milliseconds: 800));

    // Sample notification data
    setState(() {
      notifications = [
        NotificationItem(
          id: '1',
          title: 'New Content Available',
          message: 'Check out the latest updates in your favorite category!',
          time: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: false,
          type: NotificationType.content,
        ),
        NotificationItem(
          id: '2',
          title: 'Subscription Reminder',
          message:
              'Your subscription will expire in 3 days. Renew now to avoid interruption.',
          time: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
          type: NotificationType.subscription,
        ),
        NotificationItem(
          id: '3',
          title: 'Download Complete',
          message: 'Your download has been completed successfully.',
          time: DateTime.now().subtract(const Duration(days: 1)),
          isRead: false,
          type: NotificationType.download,
        ),
        NotificationItem(
          id: '4',
          title: 'Account Security',
          message: 'We noticed a new login to your account. Was this you?',
          time: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
          type: NotificationType.security,
        ),
        NotificationItem(
          id: '5',
          title: 'New Feature Available',
          message: 'Try our new search feature to find content faster!',
          time: DateTime.now().subtract(const Duration(days: 4)),
          isRead: true,
          type: NotificationType.system,
        ),
      ];
      isLoading = false;
    });
  }

  Future<void> _refreshNotifications() async {
    await _loadNotifications();
  }

  void _markAsRead(String id) {
    setState(() {
      final index =
          notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
  }

  void _markAllAsRead() {
    setState(() {
      notifications = notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.translate('all_marked_read') ??
              'All notifications marked as read',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B2E),
        title: Text(
          AppLocalizations.of(context)!.translate('delete_all_confirm_title') ??
              'Clear All Notifications',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!
                  .translate('delete_all_confirm_message') ??
              'Are you sure you want to delete all notifications? This action cannot be undone.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.translate('cancel') ?? 'Cancel',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!
                            .translate('all_notifications_deleted') ??
                        'All notifications deleted',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.translate('delete') ?? 'Delete',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06041F),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.translate('notification') ??
              'Notification',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            color: const Color(0xFF1A1B2E),
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'mark_all') {
                _markAllAsRead();
              } else if (value == 'delete_all') {
                _deleteAllNotifications();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'mark_all',
                child: Text(
                  AppLocalizations.of(context)!.translate('mark_all_read') ??
                      'Mark all as read',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete_all',
                child: Text(
                  AppLocalizations.of(context)!.translate('delete_all') ??
                      'Delete all',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_off_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!
                                .translate('no_notifications') ??
                            'No notifications yet',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!
                                .translate('check_back_later') ??
                            'Check back later for updates',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Dismissible(
                        key: Key(notification.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteNotification(notification.id);
                        },
                        child: GestureDetector(
                          onTap: () {
                            _markAsRead(notification.id);
                            // You can add navigation to specific screens based on notification type here
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1B2E),
                              borderRadius: BorderRadius.circular(12),
                              border: notification.isRead
                                  ? null
                                  : Border.all(color: Colors.orange, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildNotificationIcon(notification.type),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification.title,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      notification.isRead
                                                          ? FontWeight.w500
                                                          : FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            if (!notification.isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          notification.message,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _getTimeAgo(notification.time),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.content:
        icon = Icons.article_outlined;
        color = Colors.blue;
        break;
      case NotificationType.subscription:
        icon = Icons.calendar_today_outlined;
        color = Colors.purple;
        break;
      case NotificationType.download:
        icon = Icons.download_done_outlined;
        color = Colors.green;
        break;
      case NotificationType.security:
        icon = Icons.security_outlined;
        color = Colors.red;
        break;
      case NotificationType.system:
        icon = Icons.settings_outlined;
        color = Colors.amber;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

enum NotificationType {
  content,
  subscription,
  download,
  security,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? time,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

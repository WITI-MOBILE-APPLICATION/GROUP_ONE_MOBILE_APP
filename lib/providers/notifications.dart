import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../models/notifications.dart';
import '../services/notification_services.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationService> _notifications = [];

  List<NotificationService> get notifications => _notifications;

  NotificationProvider() {
    // Initialize OneSignal
    NotificationService.initialize();

    // Listen for push notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = Notifications(
        id: event.notification.notificationId,
        title: event.notification.title ?? 'No Title',
        message: event.notification.body ?? 'No Message',
        timestamp: DateTime.now(),
      );
      _notifications.add(notification as NotificationService);
      notifyListeners();
    });
  }

  void addNotification(NotificationService notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
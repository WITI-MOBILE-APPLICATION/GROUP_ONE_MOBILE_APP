import 'package:flutter/material.dart';
import '../models/notifications.dart';

class NotificationProvider with ChangeNotifier {
  List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  void addNotification(Notification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import '../models/notifications.dart';
import '../services/notification_services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notification> notifications = [];

  @override
  void initState() {
    super.initState();
    // Listen for push notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = Notification(
        id: event.notification.notificationId,
        title: event.notification.title ?? 'No Title',
        message: event.notification.body ?? 'No Message',
        timestamp: DateTime.now(),
      );
      setState(() {
        notifications.add(notification);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.message),
            trailing: Text(notification.timestamp.toString()),
          );
        },
      ),
    );
  }
}
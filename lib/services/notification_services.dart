import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static Future<void> initialize() async {
    // Initialize OneSignal
    OneSignal.initialize("YOUR_ONESIGNAL_APP_ID");

    // Request permission for notifications
    await OneSignal.Notifications.requestPermission(true);

    // Handle foreground notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print("Notification received: ${event.notification.title} - ${event.notification.body}");
      // You can display an in-app alert here
    });
  }

  static Future<String?> getUserId() async {
    return OneSignal.User.getOnesignalId();
  }

  static void sendNotification(String title, String message, String playerId) {
    // This is a placeholder; actual sending happens server-side
    print("Sending notification to $playerId: $title - $message");
  }
}
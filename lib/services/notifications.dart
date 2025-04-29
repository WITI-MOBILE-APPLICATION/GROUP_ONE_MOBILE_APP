import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static void initialize() {
    OneSignal.initialize("YOUR_ONESIGNAL_APP_ID");
    OneSignal.Notifications.requestPermission(true);
  }
}
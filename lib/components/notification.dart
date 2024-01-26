import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CustomNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Initialize FCM
    await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );

    // Configure FCM message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Got a message whilst in the foreground!");

      // Extract data from the message
      String title = message.notification?.title ?? "No Title";
      String body = message.notification?.body ?? "No Body";

      // Trigger your custom notification
      triggerNotification(body);
    });
  }

  void triggerNotification(String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        channelKey: 'Basic_Channel',
        id: 1,
        body: body,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN',
          label: 'Open',
        ),
      ],
    );
  }
}

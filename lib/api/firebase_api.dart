import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  FirebaseApi(BuildContext context) : _scaffoldKey = GlobalKey<ScaffoldState>() {
    _initMessaging(context);
  }

  void _initMessaging(BuildContext context) {
    initNotifications();

    // Listen for incoming messages in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message Received');
      if (message.notification != null) {
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
      } else if (message.data.isNotEmpty) {
        // Extract title and body from data payload
        print('Title: ${message.data['title']}');
        print('Body: ${message.data['body']}');

        // Show a SnackBar with the received message
        final snackBar = SnackBar(
          content: Text(message.data['body'] ?? 'New Message'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      print('Payload: ${message.data}');
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      if (fCMToken != null) {
        print("Token: $fCMToken");
      } else {
        print("Firebase Cloud Messaging token is null.");
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      // print("Background Message Received");
      // print('Title: ${message.notification!.title}');
      // print('Body: ${message.notification!.body}');
    }
    print('Payload: ${message.data}');
  }
}

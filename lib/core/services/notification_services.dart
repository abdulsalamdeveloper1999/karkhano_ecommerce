import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token
  Future<String> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  getToken() {
    _fcm.getToken();
  }

  Future<void> init(BuildContext context) async {
    debugPrint('new api call');
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
      'User granted notifications permission: ${settings.authorizationStatus}',
    );

    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');

    // Initialize flutter_local_notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      "@drawable/ic_stat_ic_notification",
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          final screen = notificationData['screen'];

          // Show a notification at the top of the app
          final AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(
            'your_channel_id', // Replace with your channel ID
            'your_channel_name', // Replace with your channel name
            channelDescription:
                'your_channel_description', // Replace with your channel description
            importance: Importance.max,
            color: kblack,
            icon: "@drawable/ic_stat_ic_notification",
            priority: Priority.high,
          );

          final NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);

          flutterLocalNotificationsPlugin.show(
            0, // Notification ID, you can use different IDs for different notifications
            message.notification!.title!,
            message.notification!.body!,
            platformChannelSpecifics,
          );
        }
      }
    });

    // Handling the initial message received when the app is launched from dead (killed state)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }

  Future<void> sendNotification(adminToken) async {
    try {
      var data = {
        'to': adminToken['token'],
        'notification': {
          'priority': 'high',
          'title': 'New Order Alert',
          'body': 'A new order has been placed.', // Updated body
        }
      };
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAL49qLD4:APA91bFnWbXLqWpqByF5BikKsQuQXMPRSa8yYX8ven1GtfBdEPWBTYOuqhRpQsYGBOOPKLEYWdecIuWu3EM4t-yBoaXjHM7as6QRyCT9Jiru2wwAvXYRndmKzxL4lS3GwaM8n4O2vOT0',
        },
      );
      // getDeviceToken().then(
      //   (value) async {
      //
      //   },
      // );
    } catch (e) {
      // debgprint(e.toString());
      debugPrint(e.toString());
    }
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
}

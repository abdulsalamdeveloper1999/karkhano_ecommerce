import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('User granted permission');
        }
      } else {
        AppSettings.openNotificationSettings();
        if (kDebugMode) {
          print('User declined permission');
        }
      }
    } catch (e) {
      // Handle the exception here, e.g., log the error.
      print('Error requesting notification permission: $e');
    }
  }

  Future<String> getDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      return token!;
    } catch (e) {
      // Handle the exception here, e.g., log the error.
      print('Error getting device token: $e');
      return ''; // Return a default value or handle the error as needed.
    }
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      try {
        event.toString();
        if (kDebugMode) {
          print('Refresh token: $event');
        }
      } catch (e) {
        // Handle the exception here, e.g., log the error.
        print('Error handling token refresh: $e');
      }
    });
  }

  void firebaseInit() async {
    await FirebaseMessaging.onMessage.listen(
      (message) {
        try {
          if (kDebugMode) {
            print('Received message: ${message.notification!.title}');
            print('Received message: ${message.notification!.body}');
          }
          showNotification(message);
        } catch (e) {
          // Handle the exception here, e.g., log the error.
          print('Error handling Firebase message: $e');
        }
      },
    );
  }

  void initLocalNoti(BuildContext context, RemoteMessage message) async {
    try {
      var androidInit = AndroidInitializationSettings('ic_launcher');
      var iosInit = DarwinInitializationSettings();

      var initSetting = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _notificationsPlugin.initialize(
        initSetting,
        onDidReceiveBackgroundNotificationResponse: (payload) {},
      );
    } catch (e) {
      // Handle the exception here, e.g., log the error.
      print('Error initializing local notifications: $e');
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100).toString(),
        'High Importance Notification',
        importance: Importance.max,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'Your Channel Description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
      );

      DarwinNotificationDetails darwinInitializationSettings =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinInitializationSettings,
      );

      print('Showing Title: ${message.notification!.title}');
      print('Showing body: ${message.notification!.body}');

      await _notificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    } catch (e) {
      // Handle the exception here, e.g., log the error.
      print('Error showing notification: $e');
    }
  }
}

// class FirebaseApi {
//   // create an instance of Firebase Messaging
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
// // function to initialize notifications
//   Future<void> initNotifications() async {
// // request permission from user (will prompt user)
//     await _firebaseMessaging.requestPermission();
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//     // / fetch the FCM token for this device
//     final fCMToken = await _firebaseMessaging.getToken();
//     // print the token (normally you would send this to your server)
//     print('Token: $fCMToken');
//     initPushNotifications();
//   }
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     navigatorKey.currentState?.push(
//       MaterialPageRoute(
//         builder: (BuildContext context) {
//           return BottombarPage();
//         },
//       ),
//     );
//   }
//
//   Future initPushNotifications() async {
//     FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
//
//     FirebaseMessaging.onMessageOpenedApp.listen((handleMessage));
//   }
// }

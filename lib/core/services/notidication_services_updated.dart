import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FcmServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initInfo() async {
    // Local Notification Setup
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = DarwinInitializationSettings();
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        log('${notificationResponse.notificationResponseType}.');

        // switch (notificationResponse.notificationResponseType) {
        //   case NotificationResponseType.selectedNotification:
        //     log('${notificationResponse.payload}');
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const Scaffold(
        //           body: Center(child: Text('Taps')),
        //         ),
        //       ),
        //     );
        //     break;
        //   case NotificationResponseType.selectedNotificationAction:
        //     print(notificationResponse);
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const Scaffold(
        //           body: Center(child: Text('Action')),
        //         ),
        //       ),
        //     );
        //     break;
        // }
      },
    );

    // Firebase Message Recieving Code
    FirebaseMessaging.onMessage.listen((event) async {
      print("--------Message-----------");
      print("1 onMessage: ${event.notification!.title}/${event.data}");
      // Preparing to show notification on local device
      // BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      //   event.notification!.body.toString(),
      //   htmlFormatBigText: true,
      //   contentTitle: event.notification!.title.toString(),
      //   htmlFormatContentTitle: true,
      // );
      final http.Response response = await http.get(
        Uri.parse(
          event.data['image'],
        ),
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'basic',
        'messages',
        importance: Importance.max,
        // styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: true,
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(
            response.bodyBytes,
          ),
        ),
        actions: [
          const AndroidNotificationAction(
            '1',
            'Done',
            allowGeneratedReplies: true,
          )
        ],
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        event.notification!.title,
        event.notification!.body,
        platformChannelSpecifics,
        payload: event.data['body'],
      );
    });
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('provisional');
    } else {
      print("failed");
    }
  }

  Future<String> getDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      await FirebaseFirestore.instance
          .collection('adminToken')
          .doc('1999')
          .set({
        'token': token,
      });

      return token!;
    } catch (e) {
      // Handle the exception here, e.g., log the error.
      print('Error getting device token: $e');
      return ''; // Return a default value or handle the error as needed.
    }
  }

  // getToken() async {
  //   await FirebaseMessaging.instance.getToken().then(
  //     (value) async {
  //       log(value!);
  //       // token = value;
  //       // setState(() {});
  //       // await FirebaseFirestore.instance
  //       //     .collection('users')
  //       //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //       //     .update(
  //       //   {'token': value},
  //       // );
  //     },
  //   );
  // }

  void isTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
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

  sendNotification(
      {required String title,
      required String body,
      required String to,
      required String icon}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAL49qLD4:APA91bFnWbXLqWpqByF5BikKsQuQXMPRSa8yYX8ven1GtfBdEPWBTYOuqhRpQsYGBOOPKLEYWdecIuWu3EM4t-yBoaXjHM7as6QRyCT9Jiru2wwAvXYRndmKzxL4lS3GwaM8n4O2vOT0",
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            "to": to,
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "basic",
              'image': icon,
            },
            "data": <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'image': icon,
              "url": icon,
            }
          },
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

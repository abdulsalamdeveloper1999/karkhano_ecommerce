import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String token = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    requestPermission();
    getToken();
    initInfo();
    super.initState();
  }

  // onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title!),
  //       content: Text(body!),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: const Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const Scaffold(
  //                   body: Text('Second Screen'),
  //                 ),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  initInfo() async {
    // Local Notification Setup
    const androidInitialize = AndroidInitializationSettings(
        'assets/icons_images/logo_forgoround.png');
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

  getToken() async {
    await FirebaseMessaging.instance.getToken().then(
      (value) async {
        log(value!);
        token = value;
        setState(() {});
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .update(
        //   {'token': value},
        // );
      },
    );
  }

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

  _incrementCounter() {
    setState(() {
      _counter++;
    });
    sendNotification(
      title: 'hi',
      body: 'increment : $_counter',
      to: 'f1TiUsHbRmuT-YYrCNEYjx:APA91bGKKG8v2hXnC9rsHhWFpmIl8J5z7Y6nKjfkrhoEota0tQ_CIAFas6NE3Eev_4CJdpAZMQiQsOz4PhR8nQLvMVEv1EuUTLtmio87L4ANnIghv7kpyLLqTcUIxirI5N6vtM_zxR48',
      icon:
          'https://images.unsplash.com/photo-1688607932382-f01b0987c897?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=988&q=80',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This Device Token:',
            ),
            Text(
              token,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

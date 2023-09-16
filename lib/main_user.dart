import 'dart:developer';

import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/logic.dart';
import 'package:e_commerce_store_karkhano/ui/profie/profile_controller.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(ProfileController()).getUser();
    Get.put(OrderStatusLogic()).fetchData('pending');
    Get.put(ShoppingCartController());
  });
  await FirebaseMessaging.instance.getInitialMessage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  log(
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission()
        .toString(),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // _notificationServices.getDeviceToken();
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => HomeCubit()..fetchData('All'),
//         ),
//       ],
//       child: ScreenUtilInit(
//         child: GetMaterialApp(
//           theme: ThemeData(
//             useMaterial3: true,
//             fontFamily: 'EncodeSansMedium',
//             primarySwatch: generateMaterialColor(kblack),
//           ),
//           debugShowCheckedModeBanner: false,
//
//           home: SplashPage(), //User UI
//         ),
//       ),
//     );
//   }
// }

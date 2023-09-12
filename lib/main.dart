import 'dart:developer';

import 'package:e_commerce_store_karkhano/ui/admin_login.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/logic.dart';
import 'package:e_commerce_store_karkhano/ui/home/cubit.dart';
import 'package:e_commerce_store_karkhano/ui/profie/profile_controller.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/constants.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Handle background messages here
//   await Firebase.initializeApp();
//   if (kDebugMode) {
//     print(message.notification!.title.toString());
//   }
// }

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..fetchData('All'),
        ),
        // BlocProvider(
        //   create: (context) => AdminGetDataCubit()..fetchData(),
        // )
      ],
      child: ScreenUtilInit(
        child: GetMaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'EncodeSansMedium',
            primarySwatch: generateMaterialColor(kblack),
          ),
          debugShowCheckedModeBanner: false,
          // home: Add_dataPage(),
          // home: SplashPage(),
          home: AdminLogin(),
          // home: MyHomePage(
          //   title: 'Home',
          // ),
        ),
      ),
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

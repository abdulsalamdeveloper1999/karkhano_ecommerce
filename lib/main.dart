import 'package:e_commerce_store_karkhano/ui/admin_login.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/order_status/logic.dart';
import 'package:e_commerce_store_karkhano/ui/home/cubit.dart';
import 'package:e_commerce_store_karkhano/ui/profie/profile_controller.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/controller.dart';
import 'package:e_commerce_store_karkhano/ui/splash/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'core/constants.dart';
import 'core/services/notification_services.dart';
import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log('Handling a background message ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(ProfileController()).getUser();
    Get.put(OrderStatusLogic()).fetchData('pending');
    Get.put(ShoppingCartController());
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _messagingService = MessagingService();
  @override
  void initState() {
    super.initState();
    _messagingService.init(
      context,
    ); // Initialize MessagingService to handle notifications
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..fetchData('All'),
        ),
      ],
      child: ScreenUtilInit(
        child: GetMaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'EncodeSansMedium',
            primarySwatch: generateMaterialColor(kblack),
          ),
          debugShowCheckedModeBanner: false,

          // home: SplashPage(), //User UI
          home: AppConfig.isAdminApp ? AdminLogin() : SplashPage(), //Admin Ui
        ),
      ),
    );
  }
}

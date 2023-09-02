import 'dart:async';

import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:e_commerce_store_karkhano/ui/home/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        // initialRoute:
        //     FirebaseAuth.instance.currentUser == null ? Welcome.id : ChatApp.id,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'EncodeSansMedium',
          primarySwatch: generateMaterialColor(kblack),
        ),
        debugShowCheckedModeBanner: false,
        // home: DropDownAndData(),
        home: BlocProvider(
          create: (context) => HomeCubit(),
          child: BottombarPage(),
        ),
        // home: FirebaseAuth.instance.currentUser == null
        //     ? SplashPage()
        //     : Add_dataPage()
        // MultiBlocProvider(
        //   providers: [
        //     BlocProvider(
        //       create: (context) => SplashCubit()..loadSplashData(),
        //     ),
        //     BlocProvider(
        //       create: (context) => LoginCubit(),
        //     )
        //   ],
        //   child: BlocBuilder<SplashCubit, SplashState>(
        //     builder: (context, state) {
        //       if (state is SplashLoaded) {
        //         // Check authentication status and navigate accordingly
        //         return BlocBuilder<LoginCubit, LoginState>(
        //           builder: (context, loginState) {
        //             if (loginState.status ==
        //                 AuthenticationStatus.authenticated) {
        //               return Add_dataPage();
        //             } else {
        //               return SplashPage();
        //             }
        //           },
        //         );
        //       } else {
        //         return SplashPage(); // Show splash until data is loaded
        //       }
        //     },
        //   ),
        // ),
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

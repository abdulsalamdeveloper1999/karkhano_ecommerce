// import 'package:e_commerce_store_karkhano/core/constants.dart';
// import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'cubit.dart';
//
// class SplashPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => SplashCubit(),
//       child: Builder(builder: (context) => _buildPage(context)),
//     );
//   }
//
//   Widget _buildPage(BuildContext context) {
//     final cubit = BlocProvider.of<SplashCubit>(context);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: kblack,
//         body: BlocBuilder<SplashCubit, SplashState>(
//           builder: (context, state) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   MyText(
//                     text: 'Welcome To',
//                     color: kwhite,
//                     size: 22.sp,
//                     fontFamily: 'EncodeSansRegular',
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/icons_images/shopping-bag.png',
//                         height: 32,
//                         color: kwhite,
//                       ),
//                       SizedBox(width: 5.w),
//                       MyText(
//                         text: 'DiscountDirect',
//                         color: kwhite,
//                         size: 32.sp,
//                         fontFamily: 'EncodeSans',
//                         weight: FontWeight.normal,
//                       ),
//                     ],
//                   ),
//                   MyText(
//                     text: 'The New World',
//                     color: kwhite,
//                     size: 22.sp,
//                     fontFamily: 'EncodeSans',
//                     weight: FontWeight.normal,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// // DiscountDirect
// splash_page.dart
import 'dart:async';

import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:e_commerce_store_karkhano/ui/splash/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'cubit.dart';
// Import the SplashCubit class

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<SplashCubit>(context);
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        cubit.loadSplashData();
        return SplashView();
        // if (state is SplashInitial) {
        //   // Display loading animation or image
        //   return SplashView();
        // } else if (state is SplashLoaded) {
        //   // Navigate to the main content screen
        //   return LoginPage();
        // }
        // return Container(); // Handle other states if needed
      },
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Future.delayed(Duration(seconds: 3)).then((value) {
          Get.offAll(() => BottombarPage());
        });
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
    return Scaffold(
      backgroundColor: kblack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
              text: 'Welcome To',
              color: kwhite,
              size: 22.sp,
              fontFamily: 'EncodeSansRegular',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons_images/shopping-bag.png',
                  color: kwhite,
                  height: 32,
                ),
                SizedBox(width: 5),
                MyText(
                  text: 'DiscountDirect',
                  color: kwhite,
                  size: 32.sp,
                  fontFamily: 'EncodeSansMedium',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CircularProgressIndicator(
              color: kwhite,
            ),
            // ThreeDotLoadingAnimation()
          ],
        ),
      ),
    );
  }
}

class ThreeDotLoadingAnimation extends StatefulWidget {
  @override
  _ThreeDotLoadingAnimationState createState() =>
      _ThreeDotLoadingAnimationState();
}

class _ThreeDotLoadingAnimationState extends State<ThreeDotLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    _animationController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
          _startLoadingAnimation();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          ScaleTransition(
            scale:
                Tween<double>(begin: 1, end: 0.6).animate(_animationController),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dotCount == i ? Colors.white : Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}

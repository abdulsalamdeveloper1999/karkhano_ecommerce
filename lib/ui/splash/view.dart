import 'dart:ui';

import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/splash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cubit.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..loadSplashData(),
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          return SplashView();
        },
      ),
    );
  }
}

class SplashView extends StatelessWidget {
  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/icons_images/wallpaperflare.com_wallpaper.jpg'),
                // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blurred Glass Morphism Overlay
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10), // Adjust blur intensity
            child: Container(
              color: Colors.black
                  .withOpacity(0.5), // Adjust opacity for the glass effect
              child: Center(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

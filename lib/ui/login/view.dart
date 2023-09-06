import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/elevated_button.dart';
import '../../core/widgets/textformfield.dart';
import '../signup/view.dart';
import 'cubit.dart';

class LoginPage extends StatelessWidget {
  var klogin = Color(0xff414141);
  // LoginPage({required this.value});
  // int value;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<LoginCubit>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffDCDBDC),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // widget(child: Icon(Icons.arrow_back_ios)),

                  SizedBox(height: Get.height * 0.1),
                  Icon(
                    Icons.android,
                    size: 100,
                    color: kblack,
                  ),
                  MyText(
                    text: 'Hello There!',
                    size: 52.sp,
                    fontFamily: 'EncodeSansBold',
                  ),
                  MyText(
                    text: 'Welcome To DD',
                    size: 20.sp,
                    fontFamily: 'EncodeSansBold',
                  ),
                  SizedBox(height: 16.h),
                  MyField(
                    controller: cubit.emailController,
                    hintText: 'Email',
                  ),
                  SizedBox(height: 16.sp),
                  MyField(
                    controller: cubit.passwordController,
                    visibile: true,
                    hintText: 'Password',
                  ),

                  SizedBox(height: Get.height * 0.14),
                  MyButton(
                    bdcolor: kblack,
                    bgcolor: kblack,
                    text: 'Login',
                    onPress: () {
                      cubit.signUp(context);
                    },
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SignupPage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: 'Not a member?',
                          fontFamily: 'EncodeSansSemiBold',
                          size: 16.sp,
                        ),
                        MyText(
                          text: ' Register Now',
                          fontFamily: 'EncodeSansBold',
                          size: 16.sp,
                          color: klogin,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

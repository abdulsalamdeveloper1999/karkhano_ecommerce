import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/elevated_button.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/core/widgets/textformfield.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../signup/view.dart';
import 'cubit.dart';

class LoginPage extends StatelessWidget {
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
        backgroundColor: Color(0xffF9F9F9),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // widget(child: Icon(Icons.arrow_back_ios)),
                SizedBox(height: 40.sp),
                MyText(
                  text: 'Login',
                  size: 32.sp,
                  fontFamily: 'EncodeSansBold',
                ),
                SizedBox(height: Get.height * 0.18),
                MyField(
                  hintText: 'Email',
                ),
                SizedBox(height: 16.sp),
                MyField(
                  visibile: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 16.sp),
                GestureDetector(
                  onTap: () {
                    Get.to(() => SignupPage());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyText(
                        text: 'Don\'t have an account?',
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        color: kblack,
                      )
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.32),
                MyButton(
                  text: 'Login',
                  onPress: () {
                    Get.offAll(() => BottombarPage());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

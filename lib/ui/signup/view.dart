import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/widgets/elevated_button.dart';
import '../../core/widgets/mytext.dart';
import '../../core/widgets/textformfield.dart';
import 'cubit.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignupCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<SignupCubit>(context);

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
                // Icon(Icons.arrow_back_ios),
                SizedBox(height: 40.sp),
                MyText(
                  text: 'Sign Up',
                  size: 32.sp,
                  fontFamily: 'EncodeSansBold',
                ),
                SizedBox(height: Get.height * 0.18),
                MyField(
                  controller: cubit.nameController,
                  hintText: 'Name',
                ),
                SizedBox(height: 16.sp),
                MyField(
                  controller: cubit.emailController,
                  hintText: 'Email',
                ),
                SizedBox(height: 16.sp),
                MyField(
                  controller: cubit.passController,
                  visibile: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 16.sp),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyText(
                        text: 'Already have an account?',
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        color: kblack,
                      )
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.24),
                MyButton(
                  text: 'SIGN UP',
                  onPress: () {
                    cubit.createUser();
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

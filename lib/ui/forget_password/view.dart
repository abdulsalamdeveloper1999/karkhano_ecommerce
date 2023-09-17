import 'package:e_commerce_store_karkhano/core/widgets/elevated_button.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/core/widgets/textformfield.dart';
import 'package:e_commerce_store_karkhano/ui/forget_password/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'cubit.dart';

class ForgetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ForgetPasswordCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<ForgetPasswordCubit>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_outlined),
          ),
          elevation: 0,
        ),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.05,
                right: Get.width * 0.05,
              ),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: 'Discount Direct',
                          size: 14.sp,
                          color: Colors.grey[800],
                        ),
                        MyText(
                          text: 'Forgot\nPassword?',
                          size: 32.sp,
                          weight: FontWeight.w700,
                          fontFamily: 'EncodeSansBold',
                        ),
                      ],
                    ),
                    MyField(
                      controller: cubit.emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email address'; // Validation error message
                        }
                        if (!isValidEmail(value)) {
                          return 'Please enter a valid email address'; // Custom validation error message
                        }
                        return null; // Returning null means the input is valid.
                      },
                      hintText: 'Email',
                      labelText: 'Email',
                    ),
                    MyButton(
                      text: 'Continue',
                      onPress: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.resetPassword(cubit.emailController.text);
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

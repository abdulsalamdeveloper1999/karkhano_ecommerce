import 'package:e_commerce_store_karkhano/ui/signup/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            // backgroundColor: Color(0xffDCDBDC),
            body: BlocConsumer<SignupCubit, SignupState>(
              listener: (context, state) {},
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.arrow_back_ios),
                          SizedBox(height: Get.height * 0.015),
                          MyText(
                            text: 'Sign Up',
                            size: 32.sp,
                            fontFamily: 'EncodeSansBold',
                          ),
                          SizedBox(height: Get.height * 0.055),
                          MyField(
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Required';
                            //   }
                            //   null;
                            // },
                            controller: cubit.nameController,
                            hintText: 'Name',
                          ),
                          SizedBox(height: 16.sp),
                          MyField(
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Required';
                            //   }
                            //   null;
                            // },
                            controller: cubit.emailController,
                            hintText: 'Email',
                          ),
                          SizedBox(height: 16.sp),
                          MyField(
                            visibile: cubit.isVisible,
                            suffixIcon: InkWell(
                                onTap: () {
                                  cubit.updateVisibilty();
                                },
                                child: Icon(Icons.visibility_off)),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Required';
                            //   }
                            //   null;
                            // },
                            controller: cubit.passController,
                            hintText: 'Password',
                          ),
                          SizedBox(height: 16.sp),
                          MyField(
                            keyboardType: TextInputType.number,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Required';
                            //   }
                            //   null;
                            // },
                            controller: cubit.numberController,
                            hintText: 'Contact No.',
                          ),
                          SizedBox(height: 16.sp),
                          MyField(
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Required';
                            //   }
                            //   null;
                            // },
                            controller: cubit.addressController,
                            hintText: 'Address',
                          ),

                          SizedBox(height: Get.height * 0.045),
                          BlocConsumer<SignupCubit, SignupState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return MyButton(
                                text: 'SIGN UP',
                                onPress: () async {
                                  cubit.createUserAndLogin(context);
                                },
                              );
                            },
                          ),
                          SizedBox(height: 16.sp),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

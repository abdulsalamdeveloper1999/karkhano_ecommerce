import 'package:e_commerce_store_karkhano/ui/login/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/widgets/elevated_button.dart';
import '../../core/widgets/mytext.dart';
import '../../core/widgets/textformfield.dart';
import '../profie/profile_controller.dart';
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Image.asset(
                  'assets/icons_images/back.png',
                  height: 25.w,
                  width: 25.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                indicatorColor: kblack,
                labelColor: kblack,
                labelStyle: TextStyle(
                  color: kblack,
                  fontSize: 16.sp,
                  fontFamily: 'EncodeSansBold',
                ),
                unselectedLabelColor: kblack.withOpacity(0.5),
                tabs: [
                  Tab(
                    text: 'Login',
                  ),
                  Tab(
                    text: 'SignUp',
                  )
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  LoginCard(cubit: cubit),
                  SignupPage(),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.cubit,
  });

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return MyField(
                    controller: cubit.passwordController,
                    visibile: cubit.isVisible,
                    suffixIcon: InkWell(
                      onTap: () {
                        cubit.updateVisibilty();
                      },
                      child: Icon(Icons.visibility_off),
                    ),
                    hintText: 'Password',
                  );
                },
              ),
              SizedBox(height: Get.height * 0.09),
              MyButton(
                bdcolor: kblack,
                bgcolor: kblack,
                text: 'Login',
                onPress: () {
                  cubit.loginUser(context);
                  Get.put(ProfileController());
                  // cubit.signUp(context);
                },
              ),
              SizedBox(height: 16.sp),

              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => SignupPage());
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       MyText(
              //         text: 'Not a member?',
              //         fontFamily: 'EncodeSansSemiBold',
              //         size: 16.sp,
              //       ),
              //       MyText(
              //         text: ' Register Now',
              //         fontFamily: 'EncodeSansBold',
              //         size: 16.sp,
              //         color: klogin,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../profie/profile_controller.dart';
import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  void updateVisibilty() {
    isVisible = !isVisible;
    emit(LoginLoaded());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  clearController() {
    emailController.clear();
    passwordController.clear();
  }

  showCustomProgress(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: ListTile(
                leading: CircularProgressIndicator(
                  color: kblack,
                ),
                title: Text(
                  'Signing In',
                  style: TextStyle(
                    fontFamily: '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Please Wait',
                  style: TextStyle(
                    fontFamily: '',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )),
        );
      },
    );
    emit(LoginLoaded());
  }

  hideCustomProgress(context) {
    Navigator.pop(context);
    emit(LoginLoaded());
  }

  void loginUser(context) async {
    try {
      showCustomProgress(context);
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        hideCustomProgress(context);
        Get.snackbar(
          'Registration error',
          '',
          messageText: Text(
            'All fields are required',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          titleText: Text(
            'Oops!',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );

        return;
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        Get.find<ProfileController>().getUser();
        hideCustomProgress(context);
        Get.back();
      });
      Get.snackbar(
        'Alert',
        'User has logged in',
        backgroundColor: kblack,
        colorText: kwhite,
      );

      emit(LoginLoaded());
      // The user is now logged in

      // After successful login, navigate back to the previous screen
      Get.back();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Get.snackbar(
        '',
        e.message!,
        titleText: MyText(
          text: 'Error',
          color: Colors.red,
          size: 16.sp,
        ),
        backgroundColor: kblack,
        colorText: kwhite,
      );
      hideCustomProgress(context);
      emit(LoginLoaded());
      // Handle specific FirebaseAuth exceptions
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(LoginLoaded());
    }
  }
}

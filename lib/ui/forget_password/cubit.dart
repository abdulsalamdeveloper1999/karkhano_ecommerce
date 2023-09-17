import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/services/firebase_auth.dart';
import 'package:e_commerce_store_karkhano/core/widgets/custom_progress_dialog.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetInitial());

  AuthService authService = AuthService();

  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> close() {
    emailController.dispose();

    return super.close();
  }

  bool isValidEmail(String email) {
    // Add your email validation logic here
    // For a basic check, you can use a regular expression
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void showCircle() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return CustomProgressDialogWidget(
          title: 'Sending a password reset link to your email...',
        );
      },
    );
  }

  void hideCircle() {
    Navigator.pop(Get.context!);
  }

  Future<void> resetPassword(email) async {
    try {
      showCircle();

      await authService.resetPassword(email).then((value) {
        return hideCircle();
      });
      emailController.clear();
      Get.snackbar(
        'Password Reset',
        'A password reset email has been sent to $email.',
        backgroundColor: kblack,
        colorText: kwhite,
      );
      Get.off(() => BottombarPage());

      emit(ForgetLoaded());
    } catch (e) {
      Get.snackbar(
        'Ops!',
        e.toString(),
        backgroundColor: kblack,
        colorText: kwhite,
      );
    }
  }
}

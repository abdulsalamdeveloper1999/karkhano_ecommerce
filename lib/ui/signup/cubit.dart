import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/models/user_model.dart';
import '../../core/widgets/mytext.dart';
import '../profie/profile_controller.dart';
import 'state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignUpInitial());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  bool isVisible = true;

  void updateVisibilty() {
    isVisible = !isVisible;
    emit(SignUpLoaded());
  }

  @override
  Future<void> close() {
    addressController.dispose();
    numberController.dispose();
    emailController.dispose();
    passController.dispose();
    nameController.dispose();

    return super.close();
  }

  void showCustomProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  'Signing Up',
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
  }

  //
  void hideCustomProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  clearControllers() {
    emailController.clear();
    passController.clear();
    nameController.clear();
  }

  void createUserAndLogin(context) async {
    try {
      showCustomProgressDialog(context);

      final email = emailController.text.trim();
      final password = passController.text.trim();
      final name = nameController.text.trim();

      if (email.isEmpty ||
          password.isEmpty ||
          name.isEmpty ||
          numberController.text.isEmpty ||
          addressController.text.isEmpty) {
        // Check if email, password, or name is empty and handle it
        hideCustomProgressDialog(context);
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

      if (!RegExp(emailPattern).hasMatch(email)) {
        // Check if email is valid
        if (kDebugMode) {
          print('Email: $email');
          print('Is Valid Email: ${RegExp(emailPattern).hasMatch(email)}');
        }
        hideCustomProgressDialog(context);
        Get.snackbar(
          '',
          'Invalid email format',
          titleText: MyText(
            text: 'Registration Error',
            color: Colors.red,
            size: 16.sp,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: kblack,
          colorText: kwhite,
        );
        return;
      }

      if (!RegExp(passwordPattern).hasMatch(password)) {
        // Check if password is valid
        hideCustomProgressDialog(context);
        Get.snackbar(
          '',
          'Password must be at least 8 characters long and contain letters and numbers',
          titleText: MyText(
            text: 'Registration Error',
            color: Colors.red,
            size: 16.sp,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: kblack,
          colorText: kwhite,
        );
        return;
      }

      // Create a user account using Firebase Authentication
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String userId = authResult.user!.uid;
      String uid = FirebaseFirestore.instance.collection('users').doc().id;

      UserModel data = UserModel(
          name: nameController.text,
          email: email,
          uid: uid,
          userId: userId,
          address: addressController.text.trim(),
          phoneNumber: numberController.text.trim());

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(data.toMap());

      hideCustomProgressDialog(context);
      clearControllers();
      Get.back();
      Get.snackbar(
        'Done',
        'User registered successfully',
        duration: Duration(seconds: 2),
        backgroundColor: kblack,
        colorText: kwhite,
      );
      if (kDebugMode) {
        debugPrint('User registered successfully');
      }

      // Now, you can explicitly log the user in
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        Get.find<ProfileController>().getUser();
      });

      // The user is now logged in
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      hideCustomProgressDialog(context);

      Get.snackbar(
        '',
        e.message!,
        titleText: MyText(
          text: 'Registration error',
          size: 16.sp,
          color: Colors.red,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: kblack,
        colorText: kwhite,
      );

      if (kDebugMode) {
        debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      }
    } catch (error) {
      // Handle other exceptions (non-Firebase Auth exceptions)
      hideCustomProgressDialog(context);
      Get.snackbar(
        '',
        '$error',
        titleText: MyText(
          text: 'Registration error',
          size: 16.sp,
          color: Colors.red,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: kblack,
        colorText: kwhite,
      );
      if (kDebugMode) {
        debugPrint('Registration error: $error');
      }
    }
  }
}

const emailPattern = r'^[a-zA-Z0-9_.+-]+@gmail.com$';

const passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';

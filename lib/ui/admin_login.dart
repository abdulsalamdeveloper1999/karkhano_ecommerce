import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/custom_progress_dialog.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/add_data/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

AdminLoginController ad = Get.put(AdminLoginController());

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    var kb = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.transparent),
    );
    return SafeArea(
      child: Container(
        color: kwhite,
        child: Scaffold(
          backgroundColor: Colors.blue.withOpacity(0.1),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: ad.gKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  SizedBox(height: 26.h),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    controller: ad.emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: kb,
                      enabledBorder: kb,
                      focusedBorder: kb,
                      errorBorder: kb,
                      focusedErrorBorder: kb,
                    ),
                  ),
                  SizedBox(height: 26.h),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: ad.passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: kb,
                      enabledBorder: kb,
                      focusedBorder: kb,
                      focusedErrorBorder: kb,
                      errorBorder: kb,
                    ),
                  ),
                  SizedBox(height: 26.h),
                  GestureDetector(
                    onTap: () {
                      if (ad.gKey.currentState!.validate()) {
                        ad.loginUser();
                      }
                    },
                    child: Container(
                      height: 55.h,
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kblack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: MyText(
                          text: 'LOGIN',
                          color: kwhite,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminLoginController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> gKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void show() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return CustomProgressDialogWidget();
      },
    );
    update();
  }

  void hide() {
    Get.back();
    update();
  }

  void loginUser() async {
    try {
      show();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        Get.offAll(() => Add_dataPage());
        hide();
      });

      update();
    } on FirebaseAuthException catch (error) {
      Get.snackbar('Error', error.toString());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

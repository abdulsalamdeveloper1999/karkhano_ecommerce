import 'package:e_commerce_store_karkhano/core/constants.dart';
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
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kblack,
                        borderRadius: BorderRadius.circular(30),
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
  TextEditingController emailController =
      TextEditingController(text: 'admin@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  GlobalKey<FormState> gKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void show() {
    showDialog(
      context: Get.context!,
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
                'Signing',
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
            ),
          ),
        );
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
          .then(
        (value) {
          Get.offAll(() => Add_dataPage());
          hide();
        },
      );

      update();
    } on FirebaseAuthException catch (error) {
      Get.snackbar('Error', error.message!);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

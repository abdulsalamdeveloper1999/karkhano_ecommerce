import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/add_data/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

import '../../core/models/admin_model_auth.dart';
import '../../core/services/firebase_auth.dart';
import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState(AuthenticationStatus.unknown));

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setUserLoggedIn(bool isLoggedIn) {
    final status = isLoggedIn
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated;
    emit(LoginState(status));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  final authService = AuthService();

  clearController() {
    emailController.clear();
    passwordController.clear();
  }

  Future<Object> signUp(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      ProgressDialog pD = ProgressDialog(
        context,
        message: const Text('Please wait...'),
        title: const Text('Login in'),
        dismissable: false,
      );

      Admin admin =
          Admin(email: emailController.text, password: passwordController.text);
      pD.show();

      AuthResponse response =
          await authService.SignInAccount(admin.email, admin.password!, admin);

      if (response.status) {
        pD.dismiss();
        Get.offAll(() => Add_dataPage());
        debugPrint('Successfully account creat');
      } else {
        Future.delayed(Duration(seconds: 1)).then((value) {
          pD.dismiss();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.message}'),
          ),
        );
      }

      print('response is ' + response.toString());

      return response;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please enter email and password'),
        ),
      );
      return true;
    }
  }
}

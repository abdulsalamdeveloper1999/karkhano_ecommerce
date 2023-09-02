import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState().init());

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Future<void> close() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    return super.close();
  }

  void createUser() async {
    try {
      UserCredential _user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passController.text);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/admin_model_auth.dart';
import '../string.dart';

abstract class AuthBase {
  Future<AuthResponse> loginWithEmailAndPassword(
    String email,
    String password,
  );

  Future<AuthResponse> createAccount(
    String email,
    String password,
    Admin admin,
  );

  Future<void> registerUser(String name, String email, String password);
}

class AuthService extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  //final _dbService = DatabaseService();

  @override
  Future<void> registerUser(String name, String email, String password) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String uid = authResult.user!.uid;

      UserModel data = UserModel(
        name: name,
        email: email,
        uid: uid,
      );

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(data.toMap());
      // Registration was successful
      Get.snackbar('Done', 'User registered successfully',
          duration: Duration(seconds: 2));
      print('User registered successfully');
    } catch (error) {
      Get.snackbar('Registration error', '$error',
          duration: Duration(seconds: 2));
      // Handle registration errors here
      print('Registration error: $error');
    }
  }

  @override
  Future<AuthResponse> createAccount(
    String email,
    String password,
    Admin admin,
  ) async {
    try {
      print('call user ${email} ${password}');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('call user does');
      if (userCredential.user != null) {
        //Account Created Successfully
        //updating unique id of person
        //_dbService.saveAccountData(admin, userCredential.user!.uid);

        //admin side data
        return AuthResponse(status: true, message: '');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.weakPassword) {
        return AuthResponse(
          status: false,
          message: AppStrings.passwordTooWeak,
        );
      } else if (e.code == AppStrings.emailAlreadyInUse) {
        return AuthResponse(
          status: false,
          message: AppStrings.accountAlreadyExists,
        );
      }
    } catch (e) {
      return AuthResponse(
        status: false,
        message: AppStrings.somethingWentWrong,
      );
    }

    return AuthResponse(
      status: false,
      message: AppStrings.somethingWentWrong,
    );
  }

  @override
  Future<AuthResponse> SignInAccount(
    String email,
    String password,
    Admin admin,
  ) async {
    try {
      print('call user ${email} ${password}');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('call user does');
      if (userCredential.user != null) {
        //Account Created Successfully
        //updating unique id of person
        //_dbService.saveAccountData(admin, userCredential.user!.uid);

        //admin side data
        return AuthResponse(status: true, message: '');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.weakPassword) {
        return AuthResponse(status: false, message: AppStrings.passwordTooWeak);
      } else if (e.code == AppStrings.emailAlreadyInUse) {
        return AuthResponse(
            status: false, message: AppStrings.accountAlreadyExists);
      }
    } catch (e) {
      return AuthResponse(
          status: false, message: AppStrings.somethingWentWrong);
    }

    return AuthResponse(status: false, message: AppStrings.somethingWentWrong);
  }

  @override
  Future<AuthResponse> loginWithEmailAndPassword(
      String email, String password) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }
}

class AuthResponse {
  bool status;
  String message;

  AuthResponse({required this.status, required this.message});
}

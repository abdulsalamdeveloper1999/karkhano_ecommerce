import 'package:firebase_auth/firebase_auth.dart';

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
}

class AuthService extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  //final _dbService = DatabaseService();

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

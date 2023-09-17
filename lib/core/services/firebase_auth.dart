import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      // Password reset email sent successfully.
      // You can provide a success message or navigate to a confirmation screen.
    } catch (e) {
      // Handle any errors that occur during the password reset request.
      log('Password reset failed: $e');
      // You can display an error message to the user.
    }
  }
}

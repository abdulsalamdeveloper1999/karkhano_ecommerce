import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/user_model.dart';
import '../../core/services/database.dart';

class ProfileController extends GetxController {
  List<UserModel> userList = [];
  RxList<UserModel> currentUserInfoList =
      <UserModel>[].obs; // Use RxList for reactivity
  // Add an isLoading flag
  bool isLoading = false;
  String currentUserUID = '';
  UserModel? currentUser;
  @override
  void onInit() {
    super.onInit();
    // Call getUser() when the controller is initialized
    getUser();
    ever(currentUserInfoList, (_) {
      update();
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getUser();
    ever(currentUserInfoList, (_) {
      update();
    });
  }

  Future<void> updateUserProfile(UserModel currentUser, String name,
      String phoneNumber, String address) async {
    try {
      isLoading = true; // Set isLoading to true when data loading starts
      // Update the user's data in Firestore
      await DataBaseServices().updateUserProfile(
        currentUser.userId!,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
      );

      // Update the local user object
      currentUser.name = name;
      currentUser.phoneNumber = phoneNumber;
      currentUser.address = address;

      // Notify the UI to update
      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
    }
  }

  Future<void> getUser() async {
    try {
      userList = await DataBaseServices().getUsers();
      currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

      bool currentUserExists =
          userList.any((user) => user.userId == currentUserUID);

      if (currentUserExists) {
        if (kDebugMode) {
          print('Current user UID: $currentUserUID');
        }

        // Find and print the current user's info
        UserModel? currentUserInfo = userList.firstWhere(
          (user) => user.userId == currentUserUID,
        );

        if (currentUserInfo != null) {
          if (kDebugMode) {
            print('Current User Info:');
            print('User ID: ${currentUserInfo.userId}');
            print('User Name: ${currentUserInfo.name}');
            print('User Number: ${currentUserInfo.phoneNumber}');
            print('User Address: ${currentUserInfo.address}');
          }
          // Clear the list before adding to ensure only one user's data is stored

          currentUserInfoList.clear();

          // Add current user info to the list
          currentUserInfoList.add(currentUserInfo);
          isLoading = false;
        } else {
          if (kDebugMode) {
            print('Current user info not found in userList');
          }
          isLoading = false;
        }
      } else {
        if (kDebugMode) {
          print('Current user not found in userList');
        }
        isLoading = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      isLoading = false;
    }
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      currentUser = null; // Set userModel to null after signing out
      currentUserInfoList.clear();
      currentUserUID = '';

      update(); // Notify the UI to update
    } catch (e) {
      print(e.toString());
    }
  }
}

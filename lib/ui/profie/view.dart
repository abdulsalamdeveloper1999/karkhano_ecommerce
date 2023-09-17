import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/models/user_model.dart';
import 'package:e_commerce_store_karkhano/ui/login/view.dart';
import 'package:e_commerce_store_karkhano/ui/profie/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/mytext.dart';
import '../history/view.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileController>(builder: (logic) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileInfoWidget(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ProfileInfoWidget extends StatelessWidget {
  void showEditProfileDialog(BuildContext context, UserModel currentUser) {
    TextEditingController nameController = TextEditingController(
      text: currentUser.name,
    );
    TextEditingController phoneNumberController = TextEditingController(
      text: currentUser.phoneNumber,
    );
    TextEditingController addressController = TextEditingController(
      text: currentUser.address,
    );

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Update the user's data in Firestore
                Get.find<ProfileController>().updateUserProfile(
                  currentUser,
                  nameController.text,
                  phoneNumberController.text,
                  addressController.text,
                );

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(), // Initialize the controller here
      builder: (logic) {
        final currentUserInfoList = logic.currentUserInfoList;
        if (currentUserInfoList.isEmpty) {
          return _notSignIn();
        }

        final userModel = currentUserInfoList[0];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.2),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/icons_images/avatar.png'),
                      // Set the user's avatar here
                    ),
                    SizedBox(width: 19.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: userModel.name.toString().capitalizeFirst ?? '',
                          fontFamily: 'EncodeSansSemiBold',
                          size: 18.sp,
                          color: Colors.black,
                        ),
                        MyText(
                          text: userModel.email ?? '',
                          fontFamily: 'EncodeSansMedium',
                          size: 14.sp,
                          color: Color(0xff9B9B9B),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                    onTap: () {
                      Get.to(() => HistoryPage());
                    },
                    child: _buildInfo('My Orders')),
                _buildDivider(),
                GestureDetector(
                    onTap: () {
                      _showUserInfo(userModel, context);
                    },
                    child: _buildInfo('Shipping Address')),
                _buildDivider(),
                GestureDetector(
                    onTap: () {
                      if (currentUserInfoList.isNotEmpty) {
                        showEditProfileDialog(context, currentUserInfoList[0]);
                      }
                    },
                    child: _buildInfo('Edit Profile')),
                _buildDivider(),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildDialog();
                        },
                      );
                      Future.delayed(Duration(seconds: 1)).then((value) {
                        Navigator.pop(context);
                      });
                      logic.signOut();
                    },
                    child: _buildInfo('Sign Out')),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _notSignIn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(
          text: 'Welcome',
          size: 34,
          weight: FontWeight.w700,
        ),
        MyText(
          text: 'Login to Explore the app!',
          size: 14,
          weight: FontWeight.normal,
        ),
        SizedBox(height: Get.height * 0.05),
        GestureDetector(
          onTap: () {
            Get.to(() => LoginPage());
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.09),
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kblack,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: 'LOGIN',
                  color: kwhite,
                  letterSpacing: Get.width * 0.02,
                  size: 16.sp,
                  weight: FontWeight.w700,
                  fontFamily: 'EncodeSansBold',
                ),
                SizedBox(width: 25),
                Icon(
                  Icons.arrow_forward,
                  color: kwhite,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(),
    );
  }

  Row _buildInfo(label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: label,
          fontFamily: 'EncodeSansSemiBold',
          size: 14.sp,
          color: Color(0xff222222),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
        ),
      ],
    );
  }

  // Function to show the user information in an alert dialog
  void _showUserInfo(UserModel userModel, context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: MyText(
            text: 'User Information',
            weight: FontWeight.w700,
            size: 16.sp,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(text: 'Name: ${userModel.name}'),
              _buildDivider(),
              MyText(text: 'Email: ${userModel.email}'),
              _buildDivider(),
              MyText(text: 'Phone Number: ${userModel.phoneNumber}'),
              _buildDivider(),
              MyText(text: 'Address: ${userModel.address}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Dialog _buildDialog() {
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
              'Signing Out',
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
  }
}

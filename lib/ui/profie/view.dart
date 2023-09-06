import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/mytext.dart';
import 'cubit.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProfieCubit.ProfileCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<ProfieCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  'assets/icons_images/dummyimg.png',
                ), // Replace with actual image path
              ),
              SizedBox(height: 20),
              _buildProfileInfoRow('Name', 'John Doe'),
              SizedBox(height: 10),
              _buildProfileInfoRow(
                  'Email', '${FirebaseAuth.instance.currentUser!.email}'),
              SizedBox(height: 10),
              _buildProfileInfoRow('Address', 'Peshawar Gul Bahar street 7'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kblack,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: MyText(
                  text: 'Edit Address',
                  color: kwhite,
                  size: 16.sp,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kblack,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: MyText(
                  text: 'Log Out',
                  color: kwhite,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

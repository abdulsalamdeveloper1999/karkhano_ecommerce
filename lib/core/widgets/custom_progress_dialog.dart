import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProgressDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              'Uploading Data',
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

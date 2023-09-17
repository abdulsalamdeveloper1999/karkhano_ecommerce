import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProgressDialogWidget extends StatelessWidget {
  CustomProgressDialogWidget({
    this.title = 'Uploading Data',
    this.subTitle = 'Please wait',
  });
  final String title;
  final String subTitle;
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
              title,
              style: TextStyle(
                fontFamily: '',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subTitle,
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

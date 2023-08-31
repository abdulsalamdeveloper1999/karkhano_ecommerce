import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mytext.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  var bgcolor;
  final text;
  var textColor;
  var bdcolor;
  VoidCallback? onPress;
  bool loading;
  final double textSize;

  MyButton({
    Key? key,
    this.textSize = 14,
    required this.text,
    this.loading = false,
    this.bdcolor = kblack,
    this.bgcolor = kblack,
    this.textColor = Colors.white,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 4),
            blurRadius: 24,
            spreadRadius: 0,
            color: kblack.withOpacity(0.2),
          ),
        ],
      ),
      width: w,
      height: h * 0.065,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(width: 1.0, color: bdcolor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: bgcolor,
        ),
        onPressed: onPress,
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : MyText(
                  align: TextAlign.center,
                  text: '$text',
                  size: 16.sp,
                  fontFamily: 'Montserrat',
                  weight: FontWeight.w700,
                  color: textColor,
                ),
        ),
      ),
    );
  }
}

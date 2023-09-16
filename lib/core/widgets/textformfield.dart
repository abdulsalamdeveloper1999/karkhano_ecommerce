// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

// ignore: must_be_immutable
class MyField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var hintText,
      prefixIcon,
      suffixIcon,
      hintstyle,
      controller,
      visibile,
      keyboardType;

  String? Function(String?)? validator;
  MyField({
    this.suffixIcon,
    this.visibile = false,
    this.controller,
    this.hintText,
    this.hintstyle,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    var kborder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.transparent),
    );
    var kTextFormFieldStyle = TextStyle(
      color: kblack,
      fontSize: 14.sp,
      fontFamily: 'EncodeSansRegular',
    );

    var kLighGreyStyle = TextStyle(
      color: Color(0xff878787),
      fontFamily: 'EncodeSansRegular',
    );
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: visibile,
      style: kTextFormFieldStyle,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: kblack.withOpacity(0.09),
        // contentPadding: EdgeInsets.symmetric(
        //   horizontal: 20,
        //   vertical: 5,
        // ),
        focusedBorder: kborder,
        enabledBorder: kborder,
        border: kborder,
        hintText: hintText,
        hintStyle: kLighGreyStyle,
        // labelStyle: kLighGreyStyle,
        // labelText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

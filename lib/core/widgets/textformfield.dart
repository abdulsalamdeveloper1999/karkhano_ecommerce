// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants.dart';

// ignore: must_be_immutable
class MyField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var hintText,
      prefixIcon,
      suffixIcon,
      hintstyle,
      controller,
      validator,
      visibile;
  MyField({
    Key? key,
    this.suffixIcon,
    this.visibile = false,
    this.controller,
    this.hintText,
    this.hintstyle,
    this.prefixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kTextFormFieldStyle = TextStyle(
      color: kblack,
      fontFamily: 'EncodeSansRegular',
    );

    var kLighGreyStyle = TextStyle(
      color: Color(0xff878787),
      fontFamily: 'EncodeSansRegular',
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kblack.withOpacity(0.2),
            blurRadius: 5,
          ),
        ],
        color: kwhite,
      ),
      child: TextFormField(
        obscureText: visibile,
        style: kTextFormFieldStyle,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: kwhite.withOpacity(0.4),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: kLighGreyStyle,
          // labelStyle: kLighGreyStyle,
          // labelText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}

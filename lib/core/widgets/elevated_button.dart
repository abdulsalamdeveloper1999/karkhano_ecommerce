import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:flutter/material.dart';

import 'mytext.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  var bgcolor;
  double width;
  final text;
  var textColor;
  var bdcolor;
  VoidCallback? onPress;
  bool loading;
  final double textSize;

  MyButton({
    Key? key,
    this.textSize = 14,
    this.width = 335,
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

    return SizedBox(
      height: h * 0.085,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(bgcolor),
            side: MaterialStatePropertyAll(BorderSide(color: bdcolor))),
        onPressed: onPress,
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : MyText(
                  align: TextAlign.center,
                  text: '$text',
                  size: textSize,
                  fontFamily: 'Montserrat',
                  weight: FontWeight.w700,
                  color: textColor,
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? size;
  final weight;
  final color;
  final align;
  final decoration;
  final fontFamily;
  final maxLines;
  final overflow;
  final fontStyle;

  const MyText({
    super.key,
    this.fontStyle,
    this.overflow,
    required this.text,
    this.size = 14.0,
    this.weight = FontWeight.normal,
    this.color = Colors.black,
    this.align = TextAlign.left,
    this.decoration,
    this.fontFamily = 'EncodeSansMedium',
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        fontStyle: fontStyle,
        fontSize: size,
        fontWeight: weight,
        color: color,
        decoration: decoration,
        fontFamily: fontFamily,
      ),
      textAlign: align,
      maxLines: maxLines,
    );
  }
}

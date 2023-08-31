import 'package:flutter/material.dart';

import '../constants.dart';

class MyBackButtonWidget extends StatelessWidget {
  const MyBackButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: CircleAvatar(
        child: Image.asset(
          'assets/icons_images/back.png',
          height: 25,
          width: 25,
          fit: BoxFit.cover,
        ),
        backgroundColor: kwhite,
      ),
    );
  }
}

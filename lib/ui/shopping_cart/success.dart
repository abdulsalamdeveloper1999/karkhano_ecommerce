import 'package:e_commerce_store_karkhano/core/widgets/elevated_button.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Order Placed Successfully'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                'assets/icons_images/bags.png',
                height: 213.h,
                width: 208.w,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                'Your order will be delivered soon.\nThank you for choosing our app!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              SizedBox(
                height: 55.h,
                child: MyButton(
                  text: 'Continue Shopping',
                  onPress: () {
                    Get.off(() => BottombarPage());
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

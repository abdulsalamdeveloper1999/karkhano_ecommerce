import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/mytext.dart';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Order Placed Successfully'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 16),
            Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(kblack),
              ),
              onPressed: () {
                Get.off(() => BottombarPage());
              },
              child: MyText(
                text: 'Back to Home',
                color: kwhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

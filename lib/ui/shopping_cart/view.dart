import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/models/shopping_cart_model.dart';
import '../../core/services/notidication_services_updated.dart';
import 'cartWidget.dart';
import 'controller.dart';

FcmServices _fcm = FcmServices();
ShoppingCartController _controller = Get.put(ShoppingCartController());
// NotificationServices _notificationServices = NotificationServices();

class ShoppingCartPage extends StatelessWidget {
  int pageValue;

  ShoppingCartPage({this.pageValue = 0});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: _buildBackButton(context),
          title: MyText(
            text: 'Checkout',
            size: 18.sp,
            fontFamily: 'EncodeSansSemiBold',
          ),
        ),
        body: GetBuilder<ShoppingCartController>(
          init: _controller,
          builder: (logic) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 24.h),
                  Obx(() {
                    final cartItems = _controller.cartItems;
                    return cartItems.isNotEmpty
                        ? _buildCartList(cartItems)
                        : Center(
                            child: Text('No Items In Cart'),
                          );
                  }),
                  _controller.cartItems.isNotEmpty ? Spacer() : SizedBox(),
                  _controller.cartItems.isNotEmpty
                      ? _buildTotal()
                      : Container(),
                  _controller.cartItems.isNotEmpty
                      ? _buildProceedButton(context)
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildCartList(List<ShoppingCartItemModel> cartItems) {
    return GetBuilder<ShoppingCartController>(
      builder: (logic) {
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final cartItem = cartItems[index];
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: kwhite,
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerLeft,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: kwhite,
                ),
              ),
              onDismissed: (direction) {
                _controller.removedItem(index);
              },
              child: CardCheckOutWidget(
                cartItem: cartItem,
                index: cartItems.indexOf(cartItem), // Pass the index here
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                color: Color(0xffEDEDED),
              ),
            );
          },
          itemCount: cartItems.length,
        );
      },
    );
  }

  Widget _buildTotal() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Total Price',
                size: 14.sp,
                weight: FontWeight.bold,
              ),
              Obx(() {
                return MyText(
                  text:
                      '${_controller.totalPrice}', // Display the total price here
                  size: 14.sp,
                  weight: FontWeight.bold,
                );
              }),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Shipping Charges',
                size: 14.sp,
                weight: FontWeight.bold,
              ),
              MyText(
                text: '150',
                size: 14.sp,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final cartItems = _controller.cartItems;
        DocumentSnapshot adminToken = await FirebaseFirestore.instance
            .collection('adminToken')
            .doc('1999')
            .get();
        if (cartItems.isNotEmpty) {
          print(adminToken['token']);
          try {
            _controller.uploadHistory(cartItems.first, context);
            _fcm.sendNotification(
              title: 'New Order Alert', // Updated title
              body: 'A new order has been placed.', // Updated body
              to: adminToken['token'],
              icon:
                  'https://firebasestorage.googleapis.com/v0/b/karkhanodropshipping.appspot.com/o/ic_launcher.png?alt=media&token=8ea1bc22-790a-49ca-8fdf-1054daf008a7',
            );
          } catch (e) {
            e.toString();
          }
        }
      },
      child: Container(
        height: 56.h,
        width: Get.width,
        margin: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          color: kblack,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: MyText(
            text: 'Proceed',
            color: kwhite,
            size: 14.sp,
            fontFamily: 'EncodeSansBold',
          ),
        ),
      ),
    );
  }

  InkWell _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pageValue == 1) {
          // Use Navigator to navigate to the BottombarPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottombarPage()),
          );
        }
      },
      child: CircleAvatar(
        child: Image.asset(
          'assets/icons_images/back.png',
          height: 25,
          width: 25,
          fit: BoxFit.cover,
          color: pageValue == 1 ? kblack : Colors.transparent,
        ),
        backgroundColor: kwhite,
      ),
    );
  }
}

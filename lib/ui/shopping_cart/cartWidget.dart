import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../core/models/shopping_cart_model.dart';

class CardCheckOutWidget extends StatefulWidget {
  final ShoppingCartItemModel cartItem;
  int? index; // Add the index parameter

  CardCheckOutWidget(
      {required this.cartItem,
      this.index}); // Pass the index when creating the widget

  @override
  State<CardCheckOutWidget> createState() => _CardCheckOutWidgetState();
}

class _CardCheckOutWidgetState extends State<CardCheckOutWidget> {
  @override
  Widget build(BuildContext context) {
    ShoppingCartController _controller =
        Get.find(); // Use Get.find to retrieve the correct instance

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CachedNetworkImage(
            height: 70,
            width: 70,
            fit: BoxFit.cover,
            imageUrl: widget.cartItem.adminImages[0],
          ),
        ),
        SizedBox(width: Get.width * 0.04),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: widget.cartItem.productName,
              size: 14.sp,
              fontFamily: 'EncodeSansSemiBold',
            ),
            MyText(
              text: 'Dress modern',
              size: 10.sp,
              color: Color(0xffA4AAAD),
              fontFamily: 'EncodeSansRegular',
            ),
            Container(
              width: Get.width / 1.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GetBuilder<ShoppingCartController>(builder: (logic) {
                      return MyText(
                        text: '${widget.cartItem.productPrice}',
                        size: 14.sp,
                        fontFamily: 'EncodeSansSemiBold',
                      );
                    }),
                  ),
                  Container(
                    height: 28.h,
                    width: 85.w,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: kblack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.decreaseQuantity(widget.cartItem);
                          },
                          child: Icon(
                            LineIcons.minus,
                            color: kwhite,
                            size: 15,
                          ),
                        ),
                        MyText(
                          text: widget.cartItem.quantity.toString(),
                          color: kwhite,
                          size: 14.sp,
                          fontFamily: 'EncodeSansSemiBold',
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Increasing quantity');
                            _controller.increaseQuantity(widget.cartItem);
                          },
                          child: Icon(
                            LineIcons.plus,
                            color: kwhite,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

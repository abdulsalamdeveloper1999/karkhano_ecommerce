import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/back_button.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import 'cubit.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShoppingCartCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<ShoppingCartCubit>(context);

    return Scaffold(
      bottomSheet: Container(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 22.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyBackButtonWidget(),
                MyText(
                  text: 'Checkout',
                  size: 16.sp,
                  fontFamily: 'EncodeSansSemiBold',
                ),
                Icon(LineIcons.heart),
              ],
            ),
            SizedBox(height: 24.h),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CardCheckOutWidget();
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Divider(
                    color: Color(0xffEDEDED),
                  ),
                );
              },
              itemCount: 3,
            )
          ],
        ),
      ),
    );
  }
}

class CardCheckOutWidget extends StatelessWidget {
  const CardCheckOutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _cubit = BlocProvider.of<ShoppingCartCubit>(context);
    return BlocConsumer<ShoppingCartCubit, ShoppingCartState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/icons_images/img2.png',
                height: 70,
                width: 70,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: 'Modern light clothes',
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
                        child: MyText(
                          text: '\$212.99',
                          size: 14.sp,
                          fontFamily: 'EncodeSansSemiBold',
                        ),
                      ),
                      AddRemoveContainer(),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class AddRemoveContainer extends StatefulWidget {
  @override
  _AddRemoveContainerState createState() => _AddRemoveContainerState();
}

class _AddRemoveContainerState extends State<AddRemoveContainer> {
  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    // final _cubit = BlocProvider.of<ShoppingCartCubit>(context);
    return Container(
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
            onTap: _itemCount != 0
                ? () => setState(
                      () => _itemCount--,
                    )
                : null,
            child: Icon(
              LineIcons.minus,
              color: kwhite,
              size: 15,
            ),
          ),
          MyText(
            text: _itemCount.toString(),
            color: kwhite,
            size: 14.sp,
            fontFamily: 'EncodeSansSemiBold',
          ),
          GestureDetector(
            onTap: () => setState(
              () => _itemCount++,
            ),
            child: Icon(
              LineIcons.plus,
              color: kwhite,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}

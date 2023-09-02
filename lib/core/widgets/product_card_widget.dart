import 'package:e_commerce_store_karkhano/ui/home/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../ui/home/cubit.dart';
import '../constants.dart';
import 'mytext.dart';

class ProductCardWidget extends StatelessWidget {
  ProductCardWidget(
      {super.key,
      this.onTap,
      this.imageUri,
      this.price,
      this.title,
      this.column});

  void Function()? onTap;
  var imageUri, title, price, column;

  @override
  Widget build(BuildContext context) {
    final _cubit = BlocProvider.of<HomeCubit>(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, adminData) {
        return Container(
          decoration: BoxDecoration(
            color: kwhite,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      InkWell(
                        onTap: onTap,
                        child:
                            // column
                            // Column(
                            // children: [
                            //   CachedNetworkImage(
                            //     imageUrl: imageUri,
                            //     placeholder: (context, url) =>
                            //         CircularProgressIndicator(),
                            //     errorWidget: (context, url, error) =>
                            //         Icon(Icons.error),
                            //   ),
                            // ],
                            // children: [
                            Image.asset(
                          'assets/icons_images/dummyimg.png',
                          height: Get.height / 3,
                          fit: BoxFit.cover,
                          width: Get.width,
                        ),
                        // ],
                        // ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: kblack,
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: kwhite,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    MyText(
                      text: 'Modern light clothes',
                      size: 14.sp,
                      fontFamily: 'EncodeSansSemiBold',
                    ),
                    SizedBox(height: 4.h),
                    MyText(
                      text: 'Dress modern',
                      size: 10.sp,
                      fontFamily: 'EncodeSansRegular',
                      color: Color(0xffA4AAAD),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: '\$212.99',
                          size: 14.sp,
                          fontFamily: 'EncodeSansSemiBold',
                        ),
                        Row(
                          children: [
                            MyText(
                              text: '5.0',
                              size: 12.sp,
                              fontFamily: 'EncodeSansRegular',
                              color: Color(0xffA4AAAD),
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xffFFD33C),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

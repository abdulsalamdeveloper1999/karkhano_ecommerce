import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/product_detail/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../core/widgets/back_button.dart';
import 'cubit.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProductDetailCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<ProductDetailCubit>(context);

    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          height: 60.h,
          margin: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
          ),
          decoration: BoxDecoration(
            color: kblack,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: kwhite,
              ),
              MyText(
                text: 'Add to Cart | \$100.99',
                color: kwhite,
                size: 14.sp,
                fontFamily: 'EncodeSansBold',
              )
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 22.h),
                PageViewWidget(),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyText(
                        text: 'Modern light clothes',
                        fontFamily: 'EncodeSansSemiBold',
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 50.w),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            cubit.countDecrement();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.remove),
                          ),
                        ),
                        SizedBox(width: 18.w),
                        BlocConsumer<ProductDetailCubit, ProductDetailState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return SizedBox(
                              width: 20,
                              child: MyText(
                                text: '${state.count}',
                                fontFamily: 'EncodeSansBold',
                                size: 16.sp,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 18.w),
                        GestureDetector(
                          onTap: () {
                            cubit.countIncrement();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      glow: false,
                      itemSize: 20,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 25,
                      ),
                      onRatingUpdate: (rating) {
                        cubit.updateRating(rating);
                        print(cubit.ratingText);
                      },
                    ),
                    SizedBox(width: 8),
                    BlocConsumer<ProductDetailCubit, ProductDetailState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return MyText(
                          text: '${cubit.ratingText}',
                          fontFamily: 'EncodeSansRegular',
                          color: Colors.grey,
                          size: 12.sp,
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ReadMoreText(
                  'Its simple and elegant shape makes it perfect for those of you who like you who want minimalistclothes Its simple and elegant shape makes it perfect for those of you who like you who want minimalistclothes ',
                  trimLines: 3,
                  style: TextStyle(
                    fontFamily: 'EncodeSansRegular',
                    fontSize: 12.sp,
                    color: Color(0xff878787),
                  ),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read more...',
                  trimExpandedText: 'Show less...',
                  lessStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'EncodeSansBold',
                    color: kblack,
                  ),
                  moreStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'EncodeSansBold',
                    color: kblack,
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: 'Choose Size',
                          size: 12.sp,
                          fontFamily: 'EncodeSansBold',
                          color: kblack,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            ...List.generate(
                              cubit.sizeList.length,
                              (index) => Container(
                                margin: EdgeInsets.only(right: 8),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Center(
                                  child: MyText(
                                    text: cubit.sizeList[index],
                                    size: 12.sp,
                                    fontFamily: 'EncodeSansRegular',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: 'Color',
                          size: 12.sp,
                          fontFamily: 'EncodeSansBold',
                          color: kblack,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            ...List.generate(
                              cubit.colorList.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: cubit.colorList[index],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: Get.height * 0.13),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final _cubit = BlocProvider.of<ProductDetailCubit>(context);
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      width: double.infinity,
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: kwhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              _cubit.updatePageView(page);
            },
            itemCount: _cubit.totalPages,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  _cubit.listImages[index],
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _cubit.totalPages,
                (index) {
                  return BlocConsumer<ProductDetailCubit, ProductDetailState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _cubit.currentPage == index
                              ? kwhite
                              : kwhite.withOpacity(0.4),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: MyBackButtonWidget(),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: CircleAvatar(
              backgroundColor: kwhite,
              child: Icon(
                Icons.favorite,
                color: kblack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

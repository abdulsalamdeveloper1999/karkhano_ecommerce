import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/login/view.dart';
import 'package:e_commerce_store_karkhano/ui/product_detail/state.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../core/models/shopping_cart_model.dart';
import '../../core/widgets/back_button.dart';
import '../shopping_cart/controller.dart';
import 'cubit.dart';

ShoppingCartController _controller = Get.put(ShoppingCartController());

class ProductDetailPage extends StatelessWidget {
  AdminModel? adminData; // Change the type to match your data type

  ProductDetailPage({this.adminData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProductDetailCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<ProductDetailCubit>(context);

    cubit.currentPrice = adminData!.adminPrice!;

    cubit.increasePrice = adminData!.adminPrice!;

    List<String> imageUrls =
        adminData!.adminImages!.map((file) => file.path).toList();

    return SafeArea(
      child: Scaffold(
        bottomSheet: GestureDetector(
          onTap: () async {
            List<String> imageUrls = [];
            if (adminData != null &&
                adminData!.adminImages != null &&
                adminData!.adminImages!.isNotEmpty) {
              // Select the first image URL from the adminImages list
              String firstImageUrl = adminData!.adminImages![0].path;

              // Add the selected image URL to the imageUrls list
              imageUrls.add(firstImageUrl);
            }

            if (FirebaseAuth.instance.currentUser != null) {
              final selectedProduct = ShoppingCartItemModel(
                productName: adminData!.adminTitle!,
                productPrice: adminData!.adminPrice!,
                quantity: cubit.state.count,
                adminImages: imageUrls,
                uid: adminData!.adminUid!,
              );

              await Future.delayed(Duration.zero);

              _controller.addToShoppingCart(selectedProduct);

              // print(
              //     'this images are in shopping cart ${selectedProduct.adminImages}');

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShoppingCartPage(
                    pageValue: 1,
                  ),
                ),
              );
            } else {
              Get.to(() => LoginPage());
            }
          },
          child: Container(
            height: 60.h,
            width: double.infinity,
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
                  text: 'Add to Cart | Rs. ${cubit.currentPrice}',
                  color: kwhite,
                  size: 14.sp,
                  fontFamily: 'EncodeSansBold',
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 22.h),
                PageViewWidget(
                  length: imageUrls.length,
                  imageUri: imageUrls,
                  adminData: adminData,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyText(
                        text: adminData!.adminTitle!.capitalizeFirst!,
                        fontFamily: 'EncodeSansSemiBold',
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 50.w),
                  ],
                ),
                SizedBox(height: 8.h),
                SizedBox(height: 10.h),
                ReadMoreText(
                  '${adminData!.adminDescription}',
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
  int length;
  var imageUri;
  AdminModel? adminData;
  final PageController _pageController = PageController(viewportFraction: 1.0);

  PageViewWidget(
      {required this.adminData, required this.length, required this.imageUri});

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
            itemCount: length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  // Use CachedNetworkImage here
                  imageUrl: imageUri[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                length,
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
          BlocConsumer<ProductDetailCubit, ProductDetailState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<ProductDetailCubit>()
                        .uploadFavorites(adminData!);
                  },
                  child: CircleAvatar(
                    backgroundColor: kwhite,
                    child: Icon(
                      // Change the icon based on the isInFavorites flag
                      context.read<ProductDetailCubit>().isInFavorites
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      color: kblack,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

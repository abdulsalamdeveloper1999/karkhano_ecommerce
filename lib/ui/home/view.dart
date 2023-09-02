import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_store_karkhano/ui/home/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/models/admin_model_data.dart';
import '../../core/widgets/mytext.dart';
import '../../core/widgets/staggered_widget.dart';
import '../product_detail/view.dart';
import 'cubit.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit()..fetchData('All'),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildUserHeader(cubit),
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return _buildSelectCategory(cubit);
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 32, left: 24, right: 24),
                height: Get.height,
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoaded) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: kblack,
                        ),
                      );
                    } else if (state is HomeGetLoaded) {
                      final adminData = state.data;
                      return StaggeredDualView(
                        mainAxisSpacing: 20.0,
                        aspectRatio: 0.45,
                        spacing: 20.0,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            adminData: adminData,
                            index: index,
                          );
                        },
                        itemCount: adminData.length,
                      );
                    } else if (state is HomeDataError) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(color: kblack),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Unknown state',
                          style: TextStyle(color: kblack),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Padding _buildUserHeader(HomeCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: 'Hello, Welcome',
                    size: 14.sp,
                    fontFamily: 'EncodeSansRegular',
                  ),
                  MyText(
                    text: 'Albert Stevano',
                    size: 16.sp,
                    fontFamily: 'EncodeSansBold',
                  ),
                ],
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/icons_images/avatar.png'),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          _buildSearch(cubit),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  _buildSelectCategory(HomeCubit cubit) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            ...List.generate(
              cubit.categories.length,
              (index) => InkWell(
                onTap: () {
                  cubit.updateContainerColor(
                      index, cubit.categories[index]['text']);
                  print(cubit.selectedContainer);
                  print(cubit.category);
                  // print(cubit.selectedContainer);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cubit.selectedContainer == index
                        ? kblack
                        : Colors.white,
                    border: Border.all(color: kblack),
                  ),
                  child: Row(
                    children: [
                      Image.asset(cubit.categories[index]['icon'],
                          height: 25,
                          color: cubit.selectedContainer == index
                              ? Colors.white
                              : kblack),
                      SizedBox(width: 15.w),
                      MyText(
                          text: cubit.categories[index]['text'],
                          color: cubit.selectedContainer == index
                              ? Colors.white
                              : kblack),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSearch(HomeCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: cubit.searchController,
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 49),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/icons_images/search.png',
                  height: 5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Image.asset(
          'assets/icons_images/Filter.png',
          height: 50,
        )
      ],
    );
  }
}

class ProductWidget extends StatelessWidget {
  ProductWidget({
    super.key,
    required this.adminData,
    required this.index,
  });

  final List<AdminModel> adminData;
  int index;

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      Get.to(() => ProductDetailPage(
                            adminData: adminData[index],
                          ));
                    },
                    child: Column(
                      children: [
                        // Access the first image from adminData[0].adminImages
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            height: Get.height / 3,
                            fit: BoxFit.cover,
                            imageUrl: adminData[index]
                                .adminImages![0]
                                .path, // Assuming adminImages is a list of File objects
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
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
                  text: adminData[index].adminTitle!,
                  size: 14.sp,
                  fontFamily: 'EncodeSansSemiBold',
                ),
                // SizedBox(height: 4.h),
                // MyText(
                //   text: 'Dress modern',
                //   size: 10.sp,
                //   fontFamily: 'EncodeSansRegular',
                //   color: Color(0xffA4AAAD),
                // ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Rs. ${adminData[index].adminPrice}',
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
  }
}

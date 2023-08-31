import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/home/crockery_widget.dart';
import 'package:e_commerce_store_karkhano/ui/home/dresses_widget.dart';
import 'package:e_commerce_store_karkhano/ui/home/electronics_widget.dart';
import 'package:e_commerce_store_karkhano/ui/home/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'all_items.dart';
import 'cubit.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                          backgroundImage:
                              AssetImage('assets/icons_images/avatar.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Row(
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
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {},
                builder: (context, state) {
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
                                cubit.updateContainerColor(index);
                                // print(cubit.selectedContainer);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                padding: EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 12),
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
                },
              ),
              cubit.selectedContainer == 0
                  ? AllItemsWidget()
                  : cubit.selectedContainer == 1
                      ? DressesWidget()
                      : cubit.selectedContainer == 2
                          ? ElectronicsWidget()
                          : CrockeryWidget()
            ],
          ),
        );
      },
    );
  }
}

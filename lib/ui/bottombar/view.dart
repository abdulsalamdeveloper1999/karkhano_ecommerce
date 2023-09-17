import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/state.dart';
import 'package:e_commerce_store_karkhano/ui/favorites/view.dart';
import 'package:e_commerce_store_karkhano/ui/home/view.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/mytext.dart';
import '../profie/view.dart';
import '../shopping_cart/controller.dart';
import 'cubit.dart';

class BottombarPage extends StatelessWidget {
  BottombarPage({currentIndex});

  var currentIndex;

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.shopping_bag_outlined,
    Icons.favorite_outline_rounded,
    Icons.person_2_outlined,
  ];

  final List<IconData> fillIcons = [
    Icons.home_rounded,
    Icons.shopping_bag_rounded,
    Icons.favorite_rounded,
    Icons.person_2_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BottombarCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    List<Widget> _widgetOptions = [
      HomePage(),
      ShoppingCartPage(),
      FavoritesPage(),
      ProfilePage(),
    ];

    final cubit = BlocProvider.of<BottombarCubit>(context);

    return SafeArea(
      child: Container(
        color: kwhite,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<BottombarCubit, BottombarState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Center(
                child: _widgetOptions.elementAt(cubit.currentIndex),
              );
            },
          ),
          bottomNavigationBar: BlocConsumer<BottombarCubit, BottombarState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Container(
                height: 64.h,
                margin: EdgeInsets.only(left: 24, right: 24, bottom: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.green,
                      primaryColor: Colors.red,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      // clipBehavior: Clip.hardEdge,
                      children: [
                        BottomNavigationBar(
                          elevation: 20,
                          backgroundColor: Color(0xff292526),
                          fixedColor: Color(0xff292526),
                          selectedFontSize: 0,
                          unselectedFontSize: 0,
                          type: BottomNavigationBarType.fixed,
                          currentIndex: cubit.currentIndex,
                          onTap: (index) {
                            cubit.changeBottomNavBar(index);
                          },
                          items: List.generate(
                            icons.length,
                            (index) => _buildBottomNavigationBarItem(
                              icon: cubit.currentIndex == index
                                  ? fillIcons[index]
                                  : icons[index],
                              currentIndex: cubit.currentIndex,
                              index: index,
                            ),
                          ),
                        ),
                        Get.find<ShoppingCartController>().cartItems.isNotEmpty
                            ? GetBuilder<ShoppingCartController>(
                                builder: (logic) {
                                return Positioned(
                                  top: Get.height * 0.015,
                                  left: Get.height * 0.167,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Center(
                                      child: MyText(
                                        text: Get.find<ShoppingCartController>()
                                            .cartItems
                                            .length
                                            .toString(),
                                        size: 12.sp,
                                        color: kwhite,
                                      ),
                                    ),
                                  ),
                                );
                              })
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required int currentIndex,
    required int index,
  }) {
    return BottomNavigationBarItem(
      activeIcon: CircleAvatar(
        backgroundColor: Color(0xffFFFFFF).withOpacity(0.05),
        radius: 20,
        child: Icon(
          icon,
          color: kwhite,
        ),
      ),
      icon: CircleAvatar(
        backgroundColor: Color(0xffFFFFFF).withOpacity(0.05),
        radius: 20,
        child: Icon(
          icons[index],
          color: kwhite,
        ),
      ),
      label: '',
    );
  }
}

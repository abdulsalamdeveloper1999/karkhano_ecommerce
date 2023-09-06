import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:e_commerce_store_karkhano/ui/bottombar/state.dart';
import 'package:e_commerce_store_karkhano/ui/favorites/view.dart';
import 'package:e_commerce_store_karkhano/ui/home/view.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../profie/view.dart';
import '../shopping_cart/controller.dart';
import 'cubit.dart';

class BottombarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BottombarCubit(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    ShoppingCartController _controller = Get.put(ShoppingCartController());
    List<Widget> _widgetOptions = [
      HomePage(),
      ShoppingCartPage(),
      FavoritesPage(),
      ProfilePage(),
    ];

    final cubit = BlocProvider.of<BottombarCubit>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<BottombarCubit, BottombarState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Center(
              child: _widgetOptions.elementAt(cubit.currentIndex),
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xff0E0E0E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    child: GNav(
                      rippleColor: Colors.grey[600]!,
                      hoverColor: Colors.grey[600]!,
                      gap: 8,
                      activeColor: Colors.white,
                      iconSize: 24,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      duration: Duration(milliseconds: 400),
                      tabBackgroundColor: Color(0xff1D1B1E),
                      color: Colors.white,
                      tabs: [
                        GButton(
                          icon: LineIcons.home,
                          text: 'Home',
                        ),
                        GButton(
                          icon: LineIcons.shoppingBag,
                          text: 'Cart',
                        ),
                        GButton(
                          icon: LineIcons.heart,
                          text: 'Favorites',
                        ),
                        GButton(
                          icon: LineIcons.user,
                          text: 'Profile',
                        ),
                      ],
                      selectedIndex: cubit.currentIndex,
                      onTabChange: (index) {
                        cubit.changeBottomNavBar(index);
                      },
                    ),
                  ),
                  BlocConsumer<BottombarCubit, BottombarState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Positioned(
                        left: cubit.currentIndex == 0
                            ? 165
                            : cubit.currentIndex == 1
                                ? 170
                                : 110,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: MyText(
                            text: '${_controller.cartItems.length}',
                            color: kwhite,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

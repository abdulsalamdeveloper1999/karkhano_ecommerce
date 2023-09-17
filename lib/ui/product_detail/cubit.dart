import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:e_commerce_store_karkhano/core/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/models/shopping_cart_model.dart';
import '../../core/services/database.dart';
import '../profie/profile_controller.dart';
import 'state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(InitialState());
  var sizeList = ['S', 'M', 'L', 'XL'];

  var colorList = [
    Color(0xff1B2028).withOpacity(0.30),
    Color(0xff1B2028),
    Color(0xff292526),
  ];
  double ratingText = 0.0;

  int currentPrice = 0;
  int increasePrice = 0;

  void countIncrement() {
    final count = state.count + 1;
    var updateState = ProductDetailState(count: count);
    currentPrice += increasePrice; // Add the current price to itself
    emit(updateState);
  }

  void countDecrement() {
    if (state.count > 1) {
      // Check if count is greater than 0 before decrementing
      final count = state.count - 1;
      var updateState = ProductDetailState(count: count);
      currentPrice -= increasePrice; // Add the current price to itself
      emit(updateState);
    }
  }

  void updateRating(value) {
    ratingText = value;
    emit(LoadedState());
  }

  int currentPage = 0;

  final int totalPages = 3; // Total number of pages

  void updatePageView(page) {
    currentPage = page;
    emit(LoadedState());
  }

  var listImages = [
    'assets/icons_images/dummyimg.png',
    'assets/icons_images/img2.png',
    'assets/icons_images/img3.png',
  ];

  List<ShoppingCartItemModel> cartItems = [];

  void addToShoppingCart(selectedProduct) {
    cartItems.add(selectedProduct);
    emit(LoadedState());
  }

  void uploadFavorites(AdminModel adminData) async {
    try {
      final logic = Get.find<ProfileController>();

      if (!logic.currentUserInfoList.isNotEmpty) {
        // If the user is not signed in, show an error message
        Get.snackbar(
          '',
          'Please sign in to add products to favorites',
          titleText: MyText(
            text: 'Error',
            color: Colors.red,
            size: 16.sp,
          ),
          colorText: kwhite,
          backgroundColor:
              kblack, // You can use a different color for error messages
          duration: Duration(seconds: 2),
        );
        return; // Exit the function without performing any actions
      }

      if (isInFavorites) {
        // If the product is already in favorites, remove it
        await DataBaseServices().deleteFav(adminData.adminUid!);
        print('Removed from favorites ${adminData.adminUid}');
        Get.snackbar(
          'Done',
          'Product removed from favorites',
          colorText: kwhite,
          backgroundColor: kblack,
          duration: Duration(seconds: 2),
        );
      } else {
        // If the product is not in favorites, add it
        await DataBaseServices().addfav(adminData.toMap(), adminData.adminUid!);
        Get.snackbar(
          'Done',
          'Product added to favorites',
          colorText: kwhite,
          backgroundColor: kblack,
          duration: Duration(seconds: 2),
        );
        print('Added to favorites ${adminData.adminUid}');
      }

      // Toggle the isInFavorites flag
      isInFavorites = !isInFavorites;
      emit(LoadedState());
    } catch (e) {
      print(e.toString());
    }
  }

  bool isInFavorites = false; // Initialize as false initially
}

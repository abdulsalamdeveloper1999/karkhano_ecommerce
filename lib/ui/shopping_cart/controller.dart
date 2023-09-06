import 'package:e_commerce_store_karkhano/ui/shopping_cart/success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/history_model.dart';
import '../../core/models/shopping_cart_model.dart';
import '../../core/services/database.dart';
import '../../core/widgets/custom_progress_dialog.dart';

class ShoppingCartController extends GetxController {
  RxList<ShoppingCartItemModel> cartItems = RxList<ShoppingCartItemModel>();
  RxDouble totalPrice = RxDouble(0.0);
  List<InitialValuesModel> initialValuesList = [];
  void increaseQuantity(ShoppingCartItemModel cartItem) {
    final index = cartItems.indexOf(cartItem);

    if (index != -1) {
      // Increase the quantity by one
      cartItems[index].quantity++;

      cartItems[index].productPrice += initialValuesList[index].initialPrice;

      // Update the total price of the shopping cart
      calculateTotalPrice();
    }
    update();
  }

  void decreaseQuantity(ShoppingCartItemModel cartItem) {
    final index = cartItems.indexOf(cartItem);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index].quantity--;

      cartItems[index].productPrice -= initialValuesList[index].initialPrice;

      calculateTotalPrice();
    }
    update();
  }

  // void calculateTotalPrice() {
  //   for (var item in cartItems) {
  //     print("total prices in list ${item.productPrice}");
  //   }
  // }
  void calculateTotalPrice() {
    double total = 0.0;

    for (var item in cartItems) {
      total += item.productPrice;
    }

    totalPrice.value = total;

    // Debug print statement for the final total
    print("Final Total: $total");
  }

  void addToShoppingCart(ShoppingCartItemModel selectedProduct) {
    // Check if the selected product already exists in the cart by uid
    bool alreadyExists =
        cartItems.any((item) => item.uid == selectedProduct.uid);

    if (alreadyExists) {
      Get.snackbar(
        'Warning',
        'This product is already in your cart.',
        maxWidth: Get.width / 1.5,
        margin: EdgeInsets.only(bottom: 100),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM, // Change the position if needed
        duration: Duration(seconds: 1), // Adjust the duration as needed
      );

      // If it exists, show a Snackbar
      // ...
    } else {
      // If it doesn't exist, add it to the cart
      cartItems.add(selectedProduct);

      // Check if the uid is already in initialValuesList
      bool uidExists =
          initialValuesList.any((item) => item.uid == selectedProduct.uid);

      if (!uidExists) {
        // Create a new InitialValuesModel and add it to the initialValuesList
        initialValuesList.add(InitialValuesModel(
          initialPrice: selectedProduct.productPrice,
          uid: selectedProduct.uid,
        ));
      }

      calculateTotalPrice(); // Update the total price
      print(initialValuesList.map((e) => e.initialPrice));
    }
  }

  // Function to remove an item from the cart
  void removedItem(int index) {
    if (index >= 0 && index < cartItems.length)
      initialValuesList.removeAt(index);
    cartItems.removeAt(index);
    calculateTotalPrice(); // Update the total price
  }

  void showCustomProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomProgressDialogWidget();
      },
    );
  }

  void hideCustomProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void uploadHistory(
      ShoppingCartItemModel cartItem, BuildContext context) async {
    showCustomProgressDialog(context);
    DateTime currentDate = DateTime.now();

    // Format the date as a string (e.g., "2023-09-04")
    String formattedDate =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    try {
      HistoryModel data = HistoryModel(
        status: 'pending',
        title: cartItems.map((element) => element.productName).toList(),
        price: cartItems.map((element) => element.productPrice).toList(),
        quantity: cartItems.map((element) => element.quantity).toList(),
        date: formattedDate,
        time: '${DateTime.now()}',
        images:
            cartItem.adminImages, // Make sure you define cartItem correctly.
      );

      // Printing the HistoryModel data
      // print('Status: ${data.status}');
      // print('Title: ${data.title}');
      // print('Price: ${data.price}');
      // print('Quantity: ${data.quantity}');
      // print('Date: ${data.date}');
      // print('Time: ${data.time}');
      // print('Images: ${data.images}');
      await DataBaseServices().addHistory(data.toMap());
      hideCustomProgressDialog(context);
      // Navigate to the success screen
      Get.to(OrderSuccessScreen()); // Use Get.to() to navigate

      // Clear the cart and other lists if needed
      cartItems.clear();
      initialValuesList.clear();
      totalPrice.value = 0.0;
      // Get.snackbar('Alert', 'Data Uploaded Successfully');
    } catch (e) {
      hideCustomProgressDialog(context);
      print(e.toString());
    }
  }
}

class InitialValuesModel {
  int initialPrice;
  var uid;

  InitialValuesModel({required this.initialPrice, required this.uid});
}

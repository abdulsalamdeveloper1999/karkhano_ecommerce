import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/ui/profie/profile_controller.dart';
import 'package:e_commerce_store_karkhano/ui/shopping_cart/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../core/constants.dart';
import '../../core/models/history_model.dart';
import '../../core/models/shopping_cart_model.dart';
import '../../core/services/database.dart';

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

  void calculateTotalPrice() {
    double total = 0.0;

    for (var item in cartItems) {
      total += item.productPrice;
    }

    totalPrice.value = total;
    update();
    // Debug print statement for the final total
    if (kDebugMode) {
      print("Final Total: $total");
    }
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
        snackPosition: SnackPosition.BOTTOM,
        // Change the position if needed
        duration: Duration(seconds: 1), // Adjust the duration as needed
      );

      update();
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
      update();
    }
  }

  // Function to remove an item from the cart
  void removedItem(int index) {
    if (index >= 0 && index < cartItems.length)
      initialValuesList.removeAt(index);
    cartItems.removeAt(index);
    calculateTotalPrice(); // Update the total price
    update();
  }

  void showCustomProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: ListTile(
                leading: CircularProgressIndicator(
                  color: kblack,
                ),
                title: Text(
                  'Placing Order',
                  style: TextStyle(
                    fontFamily: '',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Please Wait',
                  style: TextStyle(
                    fontFamily: '',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )),
        );
      },
    );
  }

  void hideCustomProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> uploadHistory(
    ShoppingCartItemModel cartItem,
    BuildContext context,
  ) async {
    showCustomProgressDialog(context);
    var userId = FirebaseAuth.instance.currentUser!.uid;
    DateTime currentDate = DateTime.now();

    // Create a Firestore Timestamp from the current date and time
    Timestamp timestamp = Timestamp.fromDate(currentDate);

    try {
      HistoryModel data = HistoryModel(
        trackingCode: '',
        userAddress:
            Get.find<ProfileController>().currentUserInfoList.first.address,
        userEmail:
            Get.find<ProfileController>().currentUserInfoList.first.email,
        userName: Get.find<ProfileController>().currentUserInfoList.first.name,
        userId: userId,
        status: 'pending',
        title: cartItems.map((element) => element.productName).toList(),
        price: cartItems.map((element) => element.productPrice).toList(),
        quantity: cartItems.map((element) => element.quantity).toList(),
        date: timestamp, // Use the Firestore Timestamp here
        // time: timestamp, // Use the Firestore Timestamp here
        images: cartItem.adminImages,
      );

      await DataBaseServices().addHistory(data.toMap());
      await sendEmailToUserAndAdmin();
      hideCustomProgressDialog(context);

      Get.to(() => OrderSuccessScreen());
      cartItems.clear();
      initialValuesList.clear();
      totalPrice.value = 0.0;
      print(DateTime.now());
    } catch (e) {
      hideCustomProgressDialog(context);
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> sendEmailToUserAndAdmin() async {
    // Get the current user's email and name
    String signInUserEmail = '${FirebaseAuth.instance.currentUser!.email}';
    String signInUserName =
        "${Get.find<ProfileController>().currentUserInfoList.first.name}";

    // Define the administrator's email and password
    String adminEmail = 'abdulsalamdeveloper1999@gmail.com';
    String adminPassword = 'qjrjqktsxgklwmoa';

    // Create an SMTP server configuration
    final smtpServer = gmail(adminEmail, adminPassword);

    // Create an email message for the user
    final userMessage = Message()
      ..from = Address(adminEmail) // Set the sender as the admin's email
      ..recipients.add(signInUserEmail) // Send the email to the user
      ..subject = 'Order Confirmation'
      ..html = '''
    <html>
      <body>
        <p style="text-align: left;">Hello ${signInUserName},</p>

        <p style="text-align: left;">Your order has been successfully placed with the following details:</p>
        
        <ul style="text-align: left;">
          <li>Product(s): ${cartItems.map((element) => element.productName).toList().join(', ')}</li>
          <li>Quantity: ${cartItems.map((element) => element.quantity).toList().join(', ')}</li>
          <li>Total Price: Rs. ${totalPrice.value.toStringAsFixed(2)}</li>
        </ul>
        
        <p style="text-align: left;">Your tracking code will be sent to your email when shipped.</p>

        <p style="text-align: left;">Best regards,<br>Discount Direct</p>
      </body>
    </html>
  ''';

    // Create an email message for the admin
    final adminMessage = Message()
      ..from = Address(signInUserEmail) // Set the sender as the user's email
      ..recipients.add(adminEmail) // Send the email to the admin
      ..subject = 'New Order Notification'
      ..html = '''
    <html>
      <body>
        <p style="text-align: left;">Hello,</p>

        <p style="text-align: left;">A new order has been placed with the following details:</p>
        
        <ul style="text-align: left;">
          <li>Product(s): ${cartItems.map((element) => element.productName).toList().join(', ')}</li>
          <li>Quantity: ${cartItems.map((element) => element.quantity).toList().join(', ')}</li>
          <li>Total Price: Rs. ${totalPrice.value.toStringAsFixed(2)}</li>
        </ul>
        
        <p style="text-align: left;">Customer Information:</p>
        <ul style="text-align: left;">
          <li>Name: ${signInUserName}</li>
          <li>Email: ${signInUserEmail}</li>
           <li>Address: ${Get.find<ProfileController>().currentUserInfoList.first.address}</li>
           <li>Contact No: ${Get.find<ProfileController>().currentUserInfoList.first.phoneNumber}</li>
        </ul>
        
        <p style="text-align: left;">Please take the necessary actions to process this order.</p>

        <p style="text-align: left;">Best regards,<br>Discount Direct</p>
      </body>
    </html>
  ''';

    try {
      // Send the email to the user
      final userSendReport = await send(userMessage, smtpServer);

      // Send the email to the admin
      final adminSendReport = await send(adminMessage, smtpServer);

      // Capture relevant information about the email send operations
      var userEmailReport = {
        'sentDate': DateTime.now().toUtc().toString(),
        'status': userSendReport.toString(),
        'Name': signInUserName,
        'Email': signInUserEmail,
      };

      var adminEmailReport = {
        'sentDate': DateTime.now().toUtc().toString(),
        'status': adminSendReport.toString(),
        'Name': 'Zayn',
        'Email': adminEmail,
      };

      // Store the email reports in Firestore
      var userUid =
          FirebaseFirestore.instance.collection('user_emails').doc().id;
      await FirebaseFirestore.instance
          .collection('user_emails')
          .doc(userUid)
          .set(userEmailReport);

      var adminUid =
          FirebaseFirestore.instance.collection('admin_emails').doc().id;
      await FirebaseFirestore.instance
          .collection('admin_emails')
          .doc(adminUid)
          .set(adminEmailReport);

      if (kDebugMode) {
        print('User Email sent successfully');
        print('Admin Email sent successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending email: $e');
      }
    }
  }
}

class InitialValuesModel {
  int initialPrice;
  var uid;

  InitialValuesModel({required this.initialPrice, required this.uid});
}

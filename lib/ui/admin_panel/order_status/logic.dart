import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/models/history_model.dart';
import '../../../core/widgets/mytext.dart';
import 'state.dart';

class OrderStatusLogic extends GetxController {
  final OrderStatusState state = OrderStatusState();

  TextEditingController trackingController = TextEditingController();

  RxList<HistoryModel> historyData = <HistoryModel>[].obs;

  RxList<HistoryModel> pendingHistory = <HistoryModel>[].obs;
  RxList<HistoryModel> processingHistory = <HistoryModel>[].obs;
  RxList<HistoryModel> deliveredHistory = <HistoryModel>[].obs;

  String selectedStatus = "pending";

  int selectedContainer = 0;

  StreamSubscription<QuerySnapshot>? historyDataSubscription;

  @override
  void onInit() {
    super.onInit();
    startHistoryDataListener();
  }

  @override
  void onClose() {
    historyDataSubscription?.cancel();
    trackingController.dispose();
    super.onClose();
  }

  void startHistoryDataListener() {
    historyDataSubscription = FirebaseFirestore.instance
        .collection('history')
        .where('status', isEqualTo: selectedStatus)
        .snapshots()
        .listen((querySnapshot) {
      final historyList = querySnapshot.docs
          .map(
            (doc) => HistoryModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();

      historyData.assignAll(historyList);

      // if (kDebugMode) {
      //   print('Real-time update: $selectedStatus');
      //   print(
      //       'Updated data: ${historyData.map((element) => element.collectionUid)}');
      // }
    });
  }

  void showCircular() {
    showDialog(
      context: Get.context!,
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
                  'Updating Status',
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
    update();
  }

  void hideCircle() {
    Get.back();
    update();
  }

  List status = ['pending', 'processing', 'delivered'];

  void fetchData(String selectedStatus) async {
    // selectedContainer = index;
    selectedStatus = selectedStatus;
    try {
      final data = await FirebaseFirestore.instance
          .collection('history')
          .where('status', isEqualTo: selectedStatus)
          .get();

      final historyList = data.docs
          .map(
              (doc) => HistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      historyData.assignAll(historyList);

      // if (kDebugMode) {
      //   print('pending');
      //   print(historyData.map((e) => e.title));
      // }
      update();
    } catch (e) {
      Get.snackbar(
        '',
        e.toString(),
        titleText: MyText(
          text: 'Ops!',
          size: 16.sp,
        ),
      );
      // if (kDebugMode) {
      //   print(e.toString())
      // }
    }
  }

  void fetchPendingData() async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('history')
          .where('status', isEqualTo: 'pending')
          .get();

      final historyList = data.docs
          .map(
              (doc) => HistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      pendingHistory.assignAll(historyList);

      // if (kDebugMode) {
      //   print('pending');
      //   print(pendingHistory.map((e) => e.title));
      // }
      update();
    } catch (e) {
      Get.snackbar(
        '',
        e.toString(),
        titleText: MyText(
          text: 'Ops!',
          size: 16.sp,
        ),
      );
    }
  }

  void fetchProcessingData() async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('history')
          .where('status', isEqualTo: 'processing')
          .get();

      final historyList = data.docs
          .map(
              (doc) => HistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      processingHistory.assignAll(historyList);

      // if (kDebugMode) {
      //   print('processingHistory');
      //   print(processingHistory.map((e) => e.title));
      // }

      update();
    } catch (e) {
      // if (kDebugMode) {
      //   print(e.toString());
      // }
      Get.snackbar(
        '',
        e.toString(),
        titleText: MyText(
          text: 'Ops!',
          size: 16.sp,
        ),
      );
    }
  }

  void fetchDeliveredData() async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('history')
          .where('status', isEqualTo: 'delivered')
          .get();

      final historyList = data.docs
          .map(
              (doc) => HistoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      deliveredHistory.assignAll(historyList);

      // if (kDebugMode) {
      //   print('deliveredHistory');
      //   print(deliveredHistory.map((e) => e.title));
      // }
      update();
    } catch (e) {
      Get.snackbar(
        '',
        e.toString(),
        titleText: MyText(
          text: 'Ops!',
          size: 16.sp,
        ),
      );
      // if (kDebugMode) {
      //   print(e.toString());
      // }
    }
  }

  Future<void> updateStatusAndTrackingCode(String documentId) async {
    try {
      showCircular();
      // Update the status and tracking code of the document with the provided documentId
      await FirebaseFirestore.instance
          .collection('history')
          .doc(documentId)
          .update(
        {
          'date': DateTime.now(),
          'status': 'processing',
          'trackingCode': trackingController
              .text, // Include the tracking code in the update
        },
      );

      fetchData(selectedStatus);

      // Optionally, you can trigger a re-fetch of data or any other necessary actions here.

      if (kDebugMode) {
        print('Status updated to processing, Tracking Code updated');
      }
      trackingController.clear();
      hideCircle();

      update();
      Get.rawSnackbar(
        titleText: MyText(
          text: 'Status Updated',
          color: kwhite,
        ),
        message:
            'Product status has been updated successfully!', // Add a message here
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating status and tracking code: ${e.toString()}');
      }
    }
  }

  Future<void> updateDelivered(String documentId) async {
    StreamSubscription<DocumentSnapshot>?
        subscription; // Declare the subscription variable

    try {
      showCircular();

      // Set up a stream subscription for the document
      var documentRef =
          FirebaseFirestore.instance.collection('history').doc(documentId);
      var documentStream = documentRef.snapshots();

      // Listen to updates on the document
      subscription = documentStream.listen((documentSnapshot) {
        // Check if the document exists and handle its data
        if (documentSnapshot.exists) {
          // Update your UI with the new data if needed
          fetchData(selectedStatus);
          if (kDebugMode) {
            print('Status updated to delivered');
          }
          hideCircle();

          Get.rawSnackbar(
            titleText: MyText(
              text: 'Status Updated',
              color: kwhite,
            ),
            message:
                'Your status has been updated successfully!', // Add a message here
          );

          update();

          // Cancel the subscription after the first update
          subscription?.cancel();
        }
      });

      // Update the document status
      await documentRef.update({
        'date': DateTime.now(),
        'status': 'delivered',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating status: ${e.toString()}');
      }
    }
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Invalid Time'; // Handle null timestamp if needed
    }

    try {
      DateTime dateTime = timestamp.toDate();
      String formattedTime =
          DateFormat('MMMM d, y ' 'at' ' h:mm:ss a ' 'UTCz').format(dateTime);
      return formattedTime;
    } catch (e) {
      return 'Invalid Time'; // Handle parsing errors
    }
  }

  String oneItemPrice(
      List<dynamic>? totalPrice, List<dynamic>? totalQuantity, index) {
    if (totalPrice == null ||
        totalPrice.isEmpty ||
        totalQuantity == null ||
        totalQuantity.isEmpty) {
      return 'Invalid Price'; // Handle empty or null lists if needed
    }

    double totalPriceValue =
        (totalPrice[index] as num).toDouble(); // Convert to double
    int totalQuantityValue = totalQuantity[index] as int;

    if (totalQuantityValue == 0) {
      return 'Invalid Quantity'; // Handle division by zero if needed
    }

    double singleItemPrice = totalPriceValue / totalQuantityValue;
    return singleItemPrice.toStringAsFixed(2); // Format to two decimal places
  }
}

import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/admin_model_data.dart';
import '../../../core/services/database.dart';

class AdminGetDataController extends GetxController {
  var isLoading = true.obs;
  var adminData = <AdminModel>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // @override
  // void onInit() {
  //   fetchData();
  //   super.onInit();
  //   ever(adminData, (_) {
  //     update();
  //   });
  // }

  @override
  void onReady() {
    super.onReady();
    fetchData();
    ever(adminData, (_) {
      update();
    });
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final data = await DataBaseServices().getAdminData();
      adminData.assignAll(data);
      // print('${adminData.first.adminPrice}');
      // print('${adminData.map((element) => element.adminTitle)}');
      print('${adminData.map((element) => element.adminImages)}');
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching admin data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteData(String documentId) async {
    try {
      isLoading.value = true;
      await DataBaseServices().deleteData(documentId);
      await fetchData(); // Refresh the data after deletion
      Get.snackbar(
        'Deleted',
        'Product has been deleted',
        colorText: kwhite,
        backgroundColor: kblack,
      );

      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editData(
      String documentId, Map<String, dynamic> editedData) async {
    try {
      isLoading.value = true;
      // Modify this to update the data in your Firestore collection
      await DataBaseServices().editData(documentId, editedData);
      await fetchData(); // Refresh the data after edit
      Get.snackbar(
        'Updated',
        'Product info has been updated',
        colorText: kwhite,
        backgroundColor: kblack,
      );
      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error editing data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}

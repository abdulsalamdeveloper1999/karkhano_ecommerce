import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/core/constants.dart';
import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:e_commerce_store_karkhano/core/services/notidication_services_updated.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/add_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/database.dart';
import '../../../core/widgets/custom_progress_dialog.dart';

class AddDataCubit extends Cubit<AddDataState> {
  void showCustomProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomProgressDialogWidget();
      },
    );
  }

  String adminToken = '';
  FcmServices fcmServices = FcmServices();

  void getData() {
    fcmServices.getDeviceToken().then((value) {
      adminToken = value;
      print('This is admin Token   ' + adminToken);
    });
    fcmServices.requestPermission();
    fcmServices.initInfo();
  }

  void hideCustomProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  AddDataCubit() : super(ImageInitial());

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    return super.close();
  }

  String selectedOption = 'Electronics';
  List<String> options = ['Electronics', 'Crockery', 'Dresses'];

  void setDropValue(value) {
    selectedOption = value;
    emit(ImageLoad());
  }

  List<File> images = <File>[];
  final ImagePicker picker = ImagePicker();

  // Method to add a new image
  void addImage(File image) {
    images.add(image);
    emit(ImageLoad());
  }

  // Method to remove an image
  void removeImage(int index) {
    images.removeAt(index);
    emit(ImageLoad());
  }

  // Modify _pickFromGallery method
  Future<void> pickFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && images.length < 6) {
      // Use the addImage method to add the new image
      addImage(File(pickedFile.path));
    } else {
      // Show a snackbar message if the maximum number of images has been reached
      Get.snackbar(
        'Error',
        'You can only pick up to 6 images.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    Get.back();
  }

  Future<void> addDataToFirestore() async {
    try {
      // Upload images to Firebase Storage and get their download URLs
      List<String> downloadUrls = await DataBaseServices()
          .uploadImagesToFirebaseStorage(images, selectedOption);

      // Convert the download URLs back to File objects
      List<File> imageFiles = downloadUrls.map((url) => File(url)).toList();

      // Create an instance of AdminModel with the form data and File objects
      AdminModel data = AdminModel(
        adminCategory: selectedOption,
        adminImages: imageFiles, // Store the File objects
        adminTitle: titleController.text,
        adminDescription: descriptionController.text,
        adminPrice: int.parse(priceController.text),
      );

      // Add the data to Firestore
      await DataBaseServices().add_data(data.toMap());
      Get.snackbar(
        'Done',
        "Product Added to catalog",
        colorText: Colors.white,
        backgroundColor: kblack,
      );
      clearAll();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  clearAll() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    images.clear();
    emit(ImageLoad());
  }
}

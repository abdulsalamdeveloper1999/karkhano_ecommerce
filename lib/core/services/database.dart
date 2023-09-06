import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class DSDataBase {
  Future<bool> add_data(Map<String, dynamic> data);
  Future<List<String>> uploadImagesToFirebaseStorage(
      List<File> images, String selectedOption);

  Future<List<AdminModel>> getAdminData();

  Future<List<AdminModel>> getData(String selectedCategory);

  Future<bool> addHistory(Map<String, dynamic> data);

  Future<bool> addfav(Map<String, dynamic> data, userUid);
  Future<bool> deleteFav(useruid);

  Future<List<AdminModel>> getFav();
}

class DataBaseServices extends DSDataBase {
  final CollectionReference adminDataCollection =
      FirebaseFirestore.instance.collection('adminData');

  var userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // var uid = FirebaseFirestore.instance.collection('adminData').doc().id;
  @override
  Future<bool> add_data(Map<String, dynamic> data) async {
    bool rsp = false;

    // var uid = _firestore.collection('adminData').doc().id;
    var uid = FirebaseFirestore.instance.collection('adminData').doc().id;
    if (kDebugMode) {
      print('${uid}@@@@@@@@@@@@@@@@@');
    }
    data['uid'] = uid;

    await _firestore
        .collection('adminData')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    if (kDebugMode) {
      print('success%%%%%%%%%%%%%%%%%%%%%%55');
    }
    return rsp;
  }

  @override
  Future<List<String>> uploadImagesToFirebaseStorage(
      List<File> images, String selectedOption) async {
    final List<String> downloadUrls = [];

    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef =
          storage.ref().child('adminImages').child(selectedOption);

      for (int i = 0; i < images.length; i++) {
        File imageFile = images[i];
        String fileName = 'image_$i.jpg';
        Reference fileRef = storageRef.child(fileName);

        // Upload the image
        UploadTask uploadTask = fileRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;

        if (taskSnapshot.state == TaskState.success) {
          // Image uploaded successfully, get the download URL
          String downloadURL = await fileRef.getDownloadURL();
          downloadUrls.add(downloadURL); // Add the URL to the list

          if (kDebugMode) {
            debugPrint('Image $i uploaded. Download URL: $downloadURL');
          }
        }
      }

      if (kDebugMode) {
        debugPrint('All images uploaded to Firebase Storage');
      }

      // Return the list of download URLs
      return downloadUrls;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error uploading images: $e');
      }
      return []; // Return an empty list in case of an error
    }
  }

  //* Retrieve Data *//
  Future<List<AdminModel>> getAdminData() async {
    List<AdminModel> model = [];
    try {
      var snapShot = await _firestore.collection("adminData").get();
      if (snapShot.docs.isNotEmpty) {
        snapShot.docs.forEach((element) {
          AdminModel mdl = AdminModel.fromMap(element.data());

          model.add(mdl);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
    return model;
  }

  Future<List<AdminModel>> getData(String selectedCategory) async {
    Query query = adminDataCollection;

    if (selectedCategory != 'All') {
      query = query.where('adminCategory', isEqualTo: selectedCategory);
    }

    final QuerySnapshot querySnapshot = await query.get();

    List<AdminModel> retrievedData = [];

    querySnapshot.docs.forEach((document) {
      AdminModel model = AdminModel.fromMap({
        'adminUid': document.id, // Retrieve the document ID (which is the uid)
        ...document.data() as Map<String, dynamic>,
      });
      retrievedData.add(model);
    });

    return retrievedData;
  }

  Future<bool> addHistory(Map<String, dynamic> data) async {
    var uid = FirebaseFirestore.instance.collection('adminData').doc().id;
    bool rsp = false;
    // var uid = _firestore.collection('adminData').doc().id;
    if (kDebugMode) {
      print('${uid}@@@@@@@@@@@@@@@@@');
    }
    data['uid'] = uid;

    await _firestore
        .collection('history')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    if (kDebugMode) {
      print('success%%%%%%%%%%%%%%%%%%%%%%55');
    }
    return rsp;
  }

  Future<bool> addfav(Map<String, dynamic> data, userUid) async {
    bool rsp = false;
    // var uid = _firestore.collection('adminData').doc().id;
    // print('${uid}@@@@@@@@@@@@@@@@@');
    // data['uid'] = uid;

    await _firestore
        .collection('favorites')
        .doc(userUid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    if (kDebugMode) {
      print('success%%%%%%%%%%%%%%%%%%%%%%55');

      print(userUid);
    }
    return rsp;
  }

  Future<bool> deleteFav(useruid) async {
    bool rsp = false;
    // var uid = _firestore.collection('adminData').doc().id;
    // print('${uid}@@@@@@@@@@@@@@@@@');
    // data['uid'] = uid;

    await _firestore
        .collection('favorites')
        .doc(useruid)
        .delete()
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    if (kDebugMode) {
      print('success%%%%%%%%%%%%%%%%%%%%%%55');

      print(useruid);
    }

    return rsp;
  }

  Future<List<AdminModel>> getFav() async {
    List<AdminModel> model = [];
    try {
      var snapShot = await _firestore.collection("favorites").get();
      if (snapShot.docs.isNotEmpty) {
        snapShot.docs.forEach((element) {
          AdminModel mdl = AdminModel.fromMap(element.data());

          model.add(mdl);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
    return model;
  }
}

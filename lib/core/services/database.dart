import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:e_commerce_store_karkhano/core/models/history_model.dart';
import 'package:e_commerce_store_karkhano/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> add_data(Map<String, dynamic> data) async {
    bool rsp = false;

    // var uid = _firestore.collection('adminData').doc().id;
    var uid = FirebaseFirestore.instance.collection('adminData').doc().id;

    log('${uid}@@@@@@@@@@@@@@@@@');

    data['adminUid'] = uid;

    await _firestore
        .collection('adminData')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    log('success%%%%%%%%%%%%%%%%%%%%%%55');

    return rsp;
  }

  Future<List<AdminModel>> retrieveData() async {
    List<AdminModel> dataList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('adminData').get();

      dataList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        // Convert the retrieved map to an AdminModel object
        return AdminModel.fromMap(data);
      }).toList();
    } catch (e) {
      log('Error retrieving data: $e');
    }

    return dataList;
  }

  @override
  Future<List<String>> uploadImagesToFirebaseStorage(
      List images, String selectedOption) async {
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

          log('Image $i uploaded. Download URL: $downloadURL');
        }
      }

      log('All images uploaded to Firebase Storage');

      // Return the list of download URLs
      return downloadUrls;
    } catch (e) {
      log('Error uploading images: $e');
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
      log(('Error fetching data: $e'));
    }
    return model;
  }

// Define the deleteData method
  Future<void> deleteData(String documentId) async {
    try {
      // Reference to the document you want to delete
      DocumentReference docRef =
          _firestore.collection('adminData').doc(documentId);

      // Delete the document
      await docRef.delete();
    } catch (e) {
      log('Error deleting data: $e');
    }
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
    bool rsp = false;
    var uid = _firestore.collection('adminData').doc().id;
    data['collectionUid'] = uid;

    await _firestore
        .collection('history')
        .doc(uid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    log('history has been added log of datbase services');

    return rsp;
  }

  //this is used in user panel to get only sign in user data
  Future<List<HistoryModel>> getSpecificUserHistory() async {
    List<HistoryModel> model = [];
    try {
      // Get the current signed-in user's UID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Query the "favorites" collection for favorites of the current user
        var snapShot = await _firestore
            .collection("history")
            .where("userId", isEqualTo: userId)
            .get();

        if (snapShot.docs.isNotEmpty) {
          snapShot.docs.forEach((element) {
            HistoryModel mdl = HistoryModel.fromMap(element.data());
            model.add(mdl);
          });
        }
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
    return model;
  }

  Future<List<HistoryModel>> getSelectedHistory(String selectedHistory) async {
    final CollectionReference adminDataCollection =
        FirebaseFirestore.instance.collection('history');
    Query query = adminDataCollection;

    if (selectedHistory != 'pending') {
      query = query.where('status', isEqualTo: selectedHistory);
    }

    final QuerySnapshot querySnapshot = await query.get();

    List<HistoryModel> retrievedData = [];

    querySnapshot.docs.forEach((document) {
      HistoryModel model = HistoryModel.fromMap({
        // 'adminUid': document.id, // Retrieve the document ID (which is the uid)
        ...document.data() as Map<String, dynamic>,
      });
      retrievedData.add(model);
    });

    return retrievedData;
  }

  Future<bool> addfav(Map<String, dynamic> data, collectionUid) async {
    bool rsp = false;

    var userId = FirebaseAuth.instance.currentUser!.uid;
    data['userId'] = userId;

    await _firestore
        .collection('favorites')
        .doc(collectionUid)
        .set(data)
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    return rsp;
  }

  Future<bool> deleteFav(userUid) async {
    bool rsp = false;

    await _firestore
        .collection('favorites')
        .doc(userUid)
        .delete()
        .then((v) => rsp = true)
        .onError((error, stackTrace) => rsp = false);

    return rsp;
  }

  Future<List<AdminModel>> getFav() async {
    List<AdminModel> model = [];
    try {
      // Get the current signed-in user's UID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Query the "favorites" collection for favorites of the current user
        var snapShot = await _firestore
            .collection("favorites")
            .where("userId", isEqualTo: userId)
            .get();

        if (snapShot.docs.isNotEmpty) {
          snapShot.docs.forEach((element) {
            AdminModel mdl = AdminModel.fromMap(element.data());
            model.add(mdl);
          });
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return model;
  }

  Future<List<UserModel>> getUsers() async {
    List<UserModel> model = [];
    try {
      var snapShot = await _firestore.collection("users").get();
      if (snapShot.docs.isNotEmpty) {
        snapShot.docs.forEach((element) {
          UserModel mdl = UserModel.fromMap(element.data());

          model.add(mdl);
        });
      }
    } catch (e) {
      log(e.toString());
    }
    return model;
  }

  Future<void> updateUserProfile(String userId,
      {String? name, String? phoneNumber, String? address}) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      Map<String, dynamic> dataToUpdate = {};

      if (name != null) {
        dataToUpdate['name'] = name;
      }
      if (phoneNumber != null) {
        dataToUpdate['phoneNumber'] = phoneNumber;
      }
      if (address != null) {
        dataToUpdate['address'] = address;
      }

      await userRef.update(dataToUpdate);
    } catch (e) {
      log('Error updating user profile in Firestore: $e');
    }
  }

  Future<void> editData(
      String documentId, Map<String, dynamic> editedData) async {
    try {
      await _firestore
          .collection('adminData')
          .doc(documentId)
          .update(editedData);
    } catch (e) {
      // Handle any errors that occur during the edit process
      log('Error editing data: $e');
      throw e;
    }
  }
}

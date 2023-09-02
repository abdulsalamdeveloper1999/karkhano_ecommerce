import 'dart:io';

class AdminModel {
  String? adminCategory;
  List<File>? adminImages;
  String? adminTitle;
  String? adminDescription;
  int? adminPrice;

  AdminModel({
    this.adminCategory,
    this.adminImages,
    this.adminTitle,
    this.adminDescription,
    this.adminPrice,
  });

  // Convert an AdminModel object to a Map
  Map<String, dynamic> toMap() {
    List imagePaths = adminImages!.map((file) => file.path).toList();
    return {
      'adminCategory': adminCategory,
      'adminImages': imagePaths,
      'adminTitle': adminTitle,
      'adminDescription': adminDescription,
      'adminPrice': adminPrice,
    };
  }

  static AdminModel fromMap(Map<String, dynamic> map) {
    AdminModel model = AdminModel();
    model.adminCategory = map['adminCategory'] ?? '';
    model.adminTitle = map['adminTitle'] ?? ''; // Use 'adminTitle' key
    model.adminDescription =
        map['adminDescription'] ?? ''; // Use 'adminDescription' key
    model.adminPrice = map['adminPrice'] ?? ''; // Use 'adminPrice' key
    List<String> imagePaths = List<String>.from(map['adminImages'] ?? []);
    model.adminImages = imagePaths.map((path) => File(path)).toList();

    return model;
  }
}

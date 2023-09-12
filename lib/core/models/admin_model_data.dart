import 'dart:io';

class AdminModel {
  String? adminCategory;
  List<File>? adminImages;
  String? adminTitle;
  String? adminDescription;
  int? adminPrice;
  String? adminUid;

  AdminModel({
    this.adminCategory,
    this.adminImages,
    this.adminTitle,
    this.adminDescription,
    this.adminPrice,
    this.adminUid,
  });

  // Convert an AdminModel object to a Map
  Map<String, dynamic> toMap() {
    List<String> imagePaths =
        adminImages?.map((file) => file.path)?.toList() ?? [];
    return {
      'adminCategory': adminCategory,
      'adminImages': imagePaths,
      'adminTitle': adminTitle,
      'adminDescription': adminDescription,
      'adminPrice': adminPrice,
      'adminUid': adminUid,
    };
  }

  static AdminModel fromMap(Map<String, dynamic> map) {
    List<String> imagePaths = List<String>.from(map['adminImages'] ?? []);
    List<File> adminImages = imagePaths.map((path) => File(path)).toList();

    return AdminModel(
      adminCategory: map['adminCategory'] ?? '',
      adminImages: adminImages,
      adminTitle: map['adminTitle'] ?? '',
      adminDescription: map['adminDescription'] ?? '',
      adminPrice: map['adminPrice'] ?? 0,
      adminUid: map['adminUid'] ?? '',
    );
  }

  // Implement the copyWith method
  AdminModel copyWith({
    String? adminCategory,
    List<File>? adminImages,
    String? adminTitle,
    String? adminDescription,
    int? adminPrice,
    String? adminUid,
  }) {
    return AdminModel(
      adminCategory: adminCategory ?? this.adminCategory,
      adminImages: adminImages ?? this.adminImages,
      adminTitle: adminTitle ?? this.adminTitle,
      adminDescription: adminDescription ?? this.adminDescription,
      adminPrice: adminPrice ?? this.adminPrice,
      adminUid: adminUid ?? this.adminUid,
    );
  }
}

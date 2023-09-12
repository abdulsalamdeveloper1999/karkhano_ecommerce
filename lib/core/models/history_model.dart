import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  String? status;
  List? title;
  List? price;
  List? quantity;
  Timestamp? date;
  // String? time;
  List? images;
  String? collectionUid;
  String? userId;
  final userEmail;
  final userName;
  final userAddress;
  final trackingCode;

  HistoryModel({
    this.trackingCode,
    this.userAddress,
    this.userEmail,
    this.userName,
    this.status,
    this.title,
    this.price,
    this.quantity,
    this.images,
    // this.time,
    this.date,
    this.userId,
    this.collectionUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'userAddress': this.userAddress,
      'trackingCode': this.trackingCode,
      'userEmail': this.userEmail,
      'userName': this.userName,
      'status': this.status,
      'title': this.title,
      'price': this.price,
      'quantity': this.quantity,
      'date': this.date,
      // 'time': this.time,
      'images': this.images,
      'collectionUid': this.collectionUid,
      'userId': this.userId,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      userAddress: map['userAddress'] as String?,
      trackingCode: map['trackingCode'] as String?,
      userEmail: map['userEmail'] as String?,
      userName: map['userName'] as String?,
      status: map['status'] as String?,
      title: (map['title'] as List?) ?? [],
      price: (map['price'] as List?) ?? [],
      quantity: (map['quantity'] as List?) ?? [],
      date: map['date'] as Timestamp?,
      // time: map['time'] as String?,
      images: (map['images'] as List?) ?? [],
      collectionUid: map['collectionUid'] as String?,
      userId: map['userId'] as String?,
    );
  }
}

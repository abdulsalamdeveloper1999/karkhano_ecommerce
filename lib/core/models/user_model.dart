class UserModel {
  String? email;
  String? name;
  String? uid;
  String? userId;
  String? address;
  String? phoneNumber;

  UserModel(
      {this.email,
      this.name,
      this.uid,
      this.userId,
      this.address,
      this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'name': this.name,
      'uid': this.uid,
      'userId': this.userId,
      'address': this.address,
      'phoneNumber': this.phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      uid: map['uid'] as String,
      userId: map['userId'] as String,
      address: map['address'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }
}

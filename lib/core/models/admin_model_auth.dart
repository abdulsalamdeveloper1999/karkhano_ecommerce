class Admin {
  String email;
  String? password;

  Admin({
    required this.email,
    this.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        email: json['email'],
        password: json['password']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password":password,
    };
  }
}

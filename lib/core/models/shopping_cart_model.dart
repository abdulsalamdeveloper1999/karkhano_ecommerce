class ShoppingCartItemModel {
  final String productName;
  int productPrice;
  int quantity;
  List<String> adminImages;
  String uid;

  ShoppingCartItemModel({
    required this.uid,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.adminImages,
  });
}

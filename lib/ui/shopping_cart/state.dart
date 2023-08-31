class ShoppingCartState {
  late int count;
  ShoppingCartState({this.count = 0});

  ShoppingCartState init() {
    return ShoppingCartState();
  }

  ShoppingCartState clone() {
    return ShoppingCartState();
  }
}

class Initial extends ShoppingCartState {}

class Loaded extends ShoppingCartState {}

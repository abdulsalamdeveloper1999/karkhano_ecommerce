class ProductDetailState {
  final int count;
  ProductDetailState({this.count = 1});

  ProductDetailState init() {
    return ProductDetailState();
  }

  ProductDetailState clone() {
    return ProductDetailState();
  }
}

class InitialState extends ProductDetailState {}

class LoadedState extends ProductDetailState {}

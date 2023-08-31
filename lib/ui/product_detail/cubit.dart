import 'dart:ui';

import 'package:bloc/bloc.dart';

import 'state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(InitialState());
  var sizeList = [
    'S',
    'M',
    'L',
    'XL',
  ];

  var colorList = [
    Color(0xff1B2028).withOpacity(0.30),
    Color(0xff1B2028),
    Color(0xff292526),
  ];
  double ratingText = 0.0;

  void countIncrement() {
    final count = state.count + 1;
    var updateState = ProductDetailState(count: count);
    emit(updateState);
  }

  void countDecrement() {
    if (state.count > 0) {
      // Check if count is greater than 0 before decrementing
      final count = state.count - 1;
      var updateState = ProductDetailState(count: count);
      emit(updateState);
    }
  }

  emit(updateState);

  void updateRating(value) {
    ratingText = value;
    emit(LoadedState());
  }

  int currentPage = 0;

  final int totalPages = 3; // Total number of pages

  void updatePageView(page) {
    currentPage = page;
    emit(LoadedState());
  }

  var listImages = [
    'assets/icons_images/dummyimg.png',
    'assets/icons_images/img2.png',
    'assets/icons_images/img3.png',
  ];
}

import 'package:bloc/bloc.dart';

import 'state.dart';

class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  ShoppingCartCubit() : super(Initial());

  void countIncrement() {
    final count = state.count + 1;

    var updatedStates = ShoppingCartState(count: count);
    emit(updatedStates);
  }

  void countDecrement() {
    final count = state.count - 1;

    var updateState = ShoppingCartState(count: count);
    emit(updateState);
  }
}

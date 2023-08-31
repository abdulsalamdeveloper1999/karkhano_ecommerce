import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class BottombarCubit extends Cubit<BottombarState> {
  BottombarCubit() : super(BottombarInitial());

  // static BottombarCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(BottombarLoaded());
  }
}

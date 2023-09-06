// splash_cubit.dart
import 'package:e_commerce_store_karkhano/ui/splash/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void loadSplashData() {
    // Simulate loading
    Future.delayed(Duration(seconds: 2), () {
      emit(SplashLoaded());
    });
  }
}

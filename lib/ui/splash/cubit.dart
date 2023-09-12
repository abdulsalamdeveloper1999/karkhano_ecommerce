// splash_cubit.dart
import 'package:e_commerce_store_karkhano/ui/bottombar/view.dart';
import 'package:e_commerce_store_karkhano/ui/splash/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void loadSplashData() {
    // Simulate loading
    print('call againgggggggggggggggggggggg');
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(() => BottombarPage());
      emit(SplashLoaded());
    });
  }
}

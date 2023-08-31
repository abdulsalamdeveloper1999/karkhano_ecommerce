class SplashState {
  SplashState init() {
    print('object');
    return SplashState();
  }

  SplashState clone() {
    return SplashState();
  }
}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {}

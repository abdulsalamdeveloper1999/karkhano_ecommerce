enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class LoginState {
  final AuthenticationStatus status;
  const LoginState(this.status);
}

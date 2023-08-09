abstract class LoginState {}

class InitLoginState extends LoginState {}

class LoadingLoginState extends LoginState {}

class ErrorLoginState extends LoginState {
  final String errorMessage;
  ErrorLoginState(this.errorMessage);
}

class ResponseLoginState extends LoginState {
  final String token;
  ResponseLoginState(this.token);
}
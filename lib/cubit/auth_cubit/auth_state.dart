import 'package:mobile/models/register_user_response_model.dart';

abstract class AuthState {}

class InitState extends AuthState {}

class LoadingState extends AuthState {}

class ErrorState extends AuthState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoginSuccessState extends AuthState {
  final String token;
  LoginSuccessState(this.token);
}

class RegisterSuccessState extends AuthState {
  final RegisterUserResponseModel user;
  RegisterSuccessState(this.user);
}
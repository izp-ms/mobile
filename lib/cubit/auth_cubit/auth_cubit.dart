import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/cubit/auth_cubit/auth_state.dart';
import 'package:mobile/repositories/auth_repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final storage = const FlutterSecureStorage();

  AuthCubit(this._repository) : super(InitState());

  Future<void> loginUser(String email, String password) async {
    emit(LoadingState());
    try {
      final response = await _repository.login(
        email,
        password,
      );

      await storage.write(key: 'token', value: response);

      emit(LoginSuccessState(response));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> registerUser(
    String email,
    String nickName,
    String password,
    String confirmPassword,
  ) async {
    emit(LoadingState());
    try {
      final response = await _repository.register(
        email,
        nickName,
        password,
        confirmPassword,
      );

      emit(RegisterSuccessState(response));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void resetState() {
    emit(InitState());
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/request/login_request.dart';
import 'package:mobile/api/request/register_request.dart';
import 'package:mobile/cubit/auth_cubit/auth_state.dart';
import 'package:mobile/repositories/auth_repository.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(InitState());

  Future<void> loginUser(LoginRequest loginRequest) async {
    emit(LoadingState());
    try {
      final response = await _repository.login(loginRequest);

      await SecureStorageRepository.write(key: 'token', value: response);

      emit(LoginSuccessState(response));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }

  Future<void> registerUser(RegisterRequest registerRequest) async {
    emit(LoadingState());
    try {
      final response = await _repository.register(registerRequest);

      emit(RegisterSuccessState(response));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }

  void resetState() {
    emit(InitState());
  }
}

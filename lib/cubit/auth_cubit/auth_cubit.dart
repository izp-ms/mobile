import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/cubit/auth_cubit/auth_state.dart';
import 'package:mobile/dto/login_dto.dart';
import 'package:mobile/dto/register_dto.dart';
import 'package:mobile/repositories/auth_repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final storage = const FlutterSecureStorage();

  AuthCubit(this._repository) : super(InitState());

  Future<void> loginUser(LoginDto loginDto) async {
    emit(LoadingState());
    try {
      final response = await _repository.login(loginDto);

      await storage.write(key: 'token', value: response);

      emit(LoginSuccessState(response));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }

  Future<void> registerUser(RegisterDto registerDto) async {
    emit(LoadingState());
    try {
      final response = await _repository.register(registerDto);

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

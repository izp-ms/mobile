import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/pages/login_page/cubit/login_state.dart';
import 'package:mobile/repositories/login_repository/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;
  final storage = const FlutterSecureStorage();

  LoginCubit(this._repository) : super(InitLoginState());

  Future<void> loginUser(String email, String password) async {
    emit(LoadingLoginState());
    try {
      final response = await _repository.login(email, password);

      await storage.write(key: 'token', value: response);

      emit(ResponseLoginState(response));
    } catch(e) {
      emit(ErrorLoginState(e.toString()));
    }
  }
}
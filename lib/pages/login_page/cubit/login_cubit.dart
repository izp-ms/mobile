import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/pages/login_page/cubit/login_state.dart';
import 'package:mobile/repositories/login_repository/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;
  LoginCubit(this._repository) : super(InitLoginState());

  Future<void> loginUser() async {
    emit(LoadingLoginState());
    try {
      final response = await _repository.login();
      emit(ResponseLoginState(response));
    } catch(e) {
      emit(ErrorLoginState(e.toString()));
    }
  }
}
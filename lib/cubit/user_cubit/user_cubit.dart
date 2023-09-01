import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(InitState());

  Future<void> getUserDetail() async {
    emit(LoadingState());
    try {
      final response = await _repository.getUserDetail();

      String nickName = "";

      final token = await SecureStorageRepository.read(key: 'token') ?? "";
      if (token != "") {
        final decodedToken = JwtDecoder.decode(token);
        nickName = decodedToken[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
      }

      emit(LoadedState(response, nickName));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }
}
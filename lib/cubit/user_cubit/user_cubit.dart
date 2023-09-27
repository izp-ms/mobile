import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'package:mobile/services/user_service.dart';

class UserCubit extends Cubit<UserState> {
  final UserService _repository;

  UserCubit(this._repository) : super(InitState());

  Future<void> getUserDetail() async {
    emit(LoadingState());
    try {
      final response = await _repository.getUserDetail();

      String nickName = "";

      final token = await SecureStorageService.read(key: 'token') ?? "";
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

  Future<void> putUserDetail(UserDetailRequest userDetailRequest) async {
    emit(LoadingState());
    try {
      await _repository.putUserDetail(userDetailRequest);

      getUserDetail();
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }
}

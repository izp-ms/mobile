import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/services/postcard_service.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'package:mobile/services/user_service.dart';

class UserCubit extends Cubit<UserState> {
  final UserService _repository;
  final PostcardService _favouritePostcardsRepository;

  UserCubit(this._repository, this._favouritePostcardsRepository) : super(InitState());

  Future<void> getUserDetail({int userID = -1}) async {
    emit(LoadingState());
    try {
      final response = await _repository.getUserDetail(userID);
      final favouritePostacrdsResponse = await _favouritePostcardsRepository.getFavouritePostcards();

      String nickName = "";

      final token = await SecureStorageService.read(key: 'token') ?? "";
      if (token != "") {
        final decodedToken = JwtDecoder.decode(token);
        nickName = decodedToken[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
      }

      emit(LoadedState(response, nickName, favouritePostacrdsResponse));
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

  Future<void> refreshFavouritePostcards(response) async {
    final favouritePostacrdsResponse = await _favouritePostcardsRepository.getFavouritePostcards();
    String nickName = "";

    final token = await SecureStorageService.read(key: 'token') ?? "";
    if (token != "") {
      final decodedToken = JwtDecoder.decode(token);
      nickName = decodedToken[
      "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
    }
    emit(LoadedState(response, nickName, favouritePostacrdsResponse));
  }
}

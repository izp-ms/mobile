import 'package:mobile/api/response/postcards_list_response.dart';
import 'package:mobile/api/response/user_detail_response.dart';

abstract class UserState {}

class InitState extends UserState {}

class LoadingState extends UserState {}

class ErrorState extends UserState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadedState extends UserState {
  final UserDetailResponse userDetail;
  final String nickName;
  final PostcardsListResponse favouritePostcards;
  LoadedState(this.userDetail, this.nickName, this.favouritePostcards);
}
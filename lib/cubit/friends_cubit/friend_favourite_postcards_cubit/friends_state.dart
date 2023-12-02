import 'package:mobile/api/response/postcards_list_response.dart';

abstract class FriendsState {}

class InitState extends FriendsState {}

class LoadingState extends FriendsState {}

class ErrorState extends FriendsState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadedState extends FriendsState {
  final PostcardsListResponse favouritePostcards;
  final bool isFollowing;
  LoadedState(this.favouritePostcards, this.isFollowing);
}
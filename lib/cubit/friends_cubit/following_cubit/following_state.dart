import 'package:mobile/api/response/friends_list_response.dart';

abstract class FollowingState {}

class InitState extends FollowingState {}

class ErrorState extends FollowingState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class LoadingState extends FollowingState {
  final FriendsListResponse oldFriendsData;
  final bool isFirstFetch;

  LoadingState(this.oldFriendsData, {this.isFirstFetch = false});
}

class LoadedState extends FollowingState {
  final FriendsListResponse friendsData;
  LoadedState(this.friendsData);
}

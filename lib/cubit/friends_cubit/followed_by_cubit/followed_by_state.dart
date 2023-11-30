import 'package:mobile/api/response/friends_list_response.dart';

abstract class FollowedByState {}

class InitState extends FollowedByState {}

class ErrorState extends FollowedByState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class LoadingState extends FollowedByState {
  final FriendsListResponse oldFriendsData;
  final bool isFirstFetch;

  LoadingState(this.oldFriendsData, {this.isFirstFetch = false});
}

class LoadedState extends FollowedByState {
  final FriendsListResponse friendsData;
  LoadedState(this.friendsData);
}

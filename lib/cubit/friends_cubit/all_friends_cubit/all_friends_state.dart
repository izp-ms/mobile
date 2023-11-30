import 'package:mobile/api/response/friends_list_response.dart';

abstract class AllFriendsState {}

class InitState extends AllFriendsState {}

class ErrorState extends AllFriendsState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class LoadingState extends AllFriendsState {
  final FriendsListResponse oldFriendsData;
  final bool isFirstFetch;

  LoadingState(this.oldFriendsData, {this.isFirstFetch = false});
}

class LoadedState extends AllFriendsState {
  final FriendsListResponse friendsData;
  LoadedState(this.friendsData);
}

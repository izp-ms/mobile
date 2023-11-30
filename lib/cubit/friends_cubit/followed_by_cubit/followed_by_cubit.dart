import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/friends_list_response.dart';
import 'package:mobile/cubit/friends_cubit/followed_by_cubit/followed_by_state.dart';
import 'package:mobile/services/user_service.dart';

class FollowedByCubit extends Cubit<FollowedByState> {
  FollowedByCubit(this._repository) : super(InitState());

  int currentPage = 1;
  final UserService _repository;

  Future<void> getFollowedBy(
      [
        String search = "",
        String orderBy = ""]) async {
    if (state is LoadingState) return;

    final currentState = state;
    var oldFriendsData = FriendsListResponse(content: []);
    if (currentState is LoadedState) {
      oldFriendsData = currentState.friendsData;
    }

    emit(LoadingState(oldFriendsData, isFirstFetch: currentPage == 1));

    try {
      final newAllFriendssData = await _repository.GetFollowedBy(currentPage, search, orderBy);
      var allFriendsData = (state as LoadingState).oldFriendsData;
      allFriendsData.totalCount = newAllFriendssData.totalCount;
      allFriendsData.content?.addAll(newAllFriendssData.content ?? []);
      currentPage++;
      emit(LoadedState(allFriendsData));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void clearFollowedBy() {
    emit(InitState());
  }
}

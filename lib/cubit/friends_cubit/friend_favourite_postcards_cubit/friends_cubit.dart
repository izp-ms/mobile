import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/friends_cubit/friend_favourite_postcards_cubit/friends_state.dart';
import 'package:mobile/services/postcard_service.dart';
import 'package:mobile/services/user_service.dart';


class FriendsCubit extends Cubit<FriendsState> {
  final UserService _userRepository;
  final PostcardService _favouritePostcardsRepository;

  FriendsCubit(this._userRepository, this._favouritePostcardsRepository) : super(InitState());

  Future<void> getFriendDetails(int? FriendID) async {
    emit(LoadingState());
    try {
      final friendData = await _userRepository.getUserDetail(FriendID!);
      final favouritePostacrdsResponse = await _favouritePostcardsRepository.getFriendFavouritePostcards(FriendID);
      final isFollowing = await _userRepository.getIsFollowing(FriendID);

      emit(LoadedState(favouritePostacrdsResponse, isFollowing, friendData));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }

  Future<void> updateFollowing(bool newIsFollowing, int? FriendID, favouritePostacrdsResponse, friendData) async {
    //emit(LoadingState());
    try {
      await _userRepository.updateFollowing(newIsFollowing, FriendID);

      emit(LoadedState(favouritePostacrdsResponse, newIsFollowing, friendData));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }
}

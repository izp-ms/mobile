import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/request/favourite_postcard_request.dart';
import 'package:mobile/api/response/postcards_list_response.dart';
import 'package:mobile/cubit/postcards_cubits/received_postcards_cubit/received_postcards_state.dart';
import 'package:mobile/services/postcard_service.dart';

class ReceivedPostcardsCubit extends Cubit<ReceivedPostcardsState> {
  ReceivedPostcardsCubit(this._repository) : super(InitState());

  int currentPage = 1;
  final PostcardService _repository;

  Future<void> getPostcards(
      [bool isSent = true,
      String search = "",
      String city = "",
      String country = "",
      String dateFrom = "",
      String dateTo = "",
      String orderBy = ""]) async {
    if (state is LoadingState) return;

    final currentState = state;
    var oldPostcardsData = PostcardsListResponse(content: []);
    if (currentState is LoadedState) {
      oldPostcardsData = currentState.postcardsData;
    }

    emit(LoadingState(oldPostcardsData, isFirstFetch: currentPage == 1));

    try {
      final newPostcardsData = await _repository.getPostcards(currentPage,
          isSent, search, city, country, dateFrom, dateTo, orderBy);
      final favouritePostacrdsResponse =
          await _repository.getFavouritePostcards();
      var postcardsData = (state as LoadingState).oldPostcardsData;
      postcardsData.totalCount = newPostcardsData.totalCount;
      postcardsData.content?.addAll(newPostcardsData.content ?? []);
      currentPage++;
      emit(LoadedState(postcardsData, favouritePostacrdsResponse));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> putFavouritePostcards(PostcardsListResponse postcardsData,
      FavouritePostcardRequest favouritePostcardRequest) async {
    await _repository.putFavouritePostcards(favouritePostcardRequest);
    final favouritePostacrdsResponse =
        await _repository.getFavouritePostcards();
    emit(LoadedState(postcardsData, favouritePostacrdsResponse));
  }

  void clearReceivedPostcards() {
    emit(InitState());
  }
}

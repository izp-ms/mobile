import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcards_collection_response.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';
import 'package:mobile/cubit/postcards_cubits/user_postcards_data_cubit/user_postcards_data_state.dart';
import 'package:mobile/services/postcard_service.dart';

class UserPostcardsDataCubit extends Cubit<UserPostcardsDataState> {
  UserPostcardsDataCubit(this._repository) : super(InitState());

  int currentPage = 1;
  final PostcardService _repository;

  Future<void> getPostcardData([bool showAllPostcardsCollection = false, String search = "", String city ="", String country="", String dateFrom="", String dateTo="", String orderBy=""]) async {
    if (state is LoadingState) return;

    final currentState = state;
    var oldPostcardsData = PostcardsDataListResponse(content: []);
    var oldPostcardDataCollection = PostcardsCollectionListResponse(content: []);
    if (currentState is LoadedState) {
      oldPostcardsData = currentState.postcardsData;
      oldPostcardDataCollection = currentState.postcardDataCollection;
    }

    emit(LoadingState(oldPostcardsData, oldPostcardDataCollection, isFirstFetch: currentPage == 1));

    try {
      final newPostcardsData = await _repository.getPostcardData(currentPage, showAllPostcardsCollection, search, city, country, dateFrom, dateTo, orderBy);
      var postcardDataCollectionResponse = PostcardsCollectionListResponse.createDefault();
      if (showAllPostcardsCollection)
        {
          postcardDataCollectionResponse = await _repository.getPostcardDataCollection();
        }
      var postcardsData = (state as LoadingState).oldPostcardsData;
      postcardsData.totalCount = newPostcardsData.totalCount;
      postcardsData.content?.addAll(newPostcardsData.content ?? []);

      var postcardsDataCollection = (state as LoadingState).oldPostcardDataCollection;
      postcardsDataCollection.content = postcardDataCollectionResponse.content;
      currentPage++;
      emit(LoadedState(postcardsData, postcardDataCollectionResponse));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void clearUserPostcardsData() {
    emit(InitState());
  }
}

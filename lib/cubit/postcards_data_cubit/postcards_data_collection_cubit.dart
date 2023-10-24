import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';
import 'package:mobile/cubit/postcards_data_cubit/postcards_data_collection_state.dart';
import 'package:mobile/services/postcard_service.dart';

class PostcardsDataCollectionCubit extends Cubit<PostcardsDataCollectionState> {
  PostcardsDataCollectionCubit(this._repository) : super(InitState());

  int currentPage = 1;
  final PostcardService _repository;

  Future<void> getPostcardData([bool showAllPostcardsCollection = false]) async {
    if (state is LoadingState) return;

    final currentState = state;
    var oldPostcardsData = PostcardsDataListResponse(content: []);
    if (currentState is LoadedState) {
      oldPostcardsData = currentState.postcardsData;
    }

    emit(LoadingState(oldPostcardsData, isFirstFetch: currentPage == 1));

    try {
      final newPostcardsData = await _repository.getPostcardData(currentPage, showAllPostcardsCollection);
      var postcardsData = (state as LoadingState).oldPostcardsData;
      postcardsData.totalCount = newPostcardsData.totalCount;
      postcardsData.content?.addAll(newPostcardsData.content ?? []);
      currentPage++;
      emit(LoadedState(postcardsData));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void clearPostcardData() {
    emit(InitState());
  }
}

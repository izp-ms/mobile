import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_state.dart';
import 'package:mobile/services/postcard_service.dart';

class PostcardCubit extends Cubit<PostcardState> {
  PostcardCubit(this._repository) : super(InitState());

  int currentPage = 1;
  final PostcardService _repository;

  Future<void> getPostcardData() async {
    if (state is LoadingState) return;

    final currentState = state;
    var oldPostcardsData = PostcardsDataListResponse(content: []);
    if (currentState is LoadedState) {
      oldPostcardsData = currentState.postcardsData;
    }

    emit(LoadingState(oldPostcardsData, isFirstFetch: currentPage == 1));

    try {
      final newPostcardsData = await _repository.getPostcardData(currentPage);
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

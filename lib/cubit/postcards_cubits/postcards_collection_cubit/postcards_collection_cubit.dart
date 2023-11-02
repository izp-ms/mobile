import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_collection_cubit/postcards_collection_state.dart';
import 'package:mobile/services/postcard_service.dart';

class PostcardsCollectionCubit extends Cubit<PostcardsCollectionState> {
  PostcardsCollectionCubit(this._repository) : super(InitState());
  final PostcardService _repository;

  Future<void> getFavouritePostcards() async {
    emit(LoadingState());
  }

  Future<void> putFavouritePostcards(UserDetailRequest userDetailRequest) async {
    emit(LoadingState());
  }

}

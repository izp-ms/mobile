import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/request/user_detail_request.dart';
import 'package:mobile/cubit/postcards_cubits/favourite_postcards_cubit/favourite_postcards_state.dart';
import 'package:mobile/services/postcard_service.dart';

class FavouritePostcardsCubit extends Cubit<FavouritePostcardsState> {
  FavouritePostcardsCubit(this._repository) : super(InitState());
  final PostcardService _repository;

  Future<void> getFavouritePostcards() async {
    emit(LoadingState());
  }

  Future<void> putFavouritePostcards(UserDetailRequest userDetailRequest) async {
    emit(LoadingState());
  }

}

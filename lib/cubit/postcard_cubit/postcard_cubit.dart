import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_state.dart';
import 'package:mobile/repositories/postcard_repository.dart';

class PostcardCubit extends Cubit<PostcardState> {
  final PostcardRepository _repository;

  PostcardCubit(this._repository) : super(InitState());

  Future<void> getPostcardData() async {
    emit(LoadingState());
    try {
      final response = await _repository.getPostcardData();
      emit(LoadedState(response));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
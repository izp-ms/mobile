import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/request/collect_postcard_request.dart';
import 'package:mobile/cubit/postcards_cubits/collect_postcard_cubit/collect_postcard_state.dart';
import 'package:mobile/services/collect_postcard_service.dart';

class CollectPostcardCubit extends Cubit<CollectPostcardState> {
  final CollectPostcardService _service;

  CollectPostcardCubit(this._service) : super(InitState());

  Future<void> collectPostcard(
      CollectPostcardRequest collectPostcardRequest) async {
    try {
      final response = await _service.collectPostcards(collectPostcardRequest);
      emit(SuccessState());
      emit(InitState());
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/request/coordinates_request.dart';
import 'package:mobile/cubit/postcards_cubits/collect_postcard_cubit/collect_postcard_state.dart';
import 'package:mobile/services/collect_postcard_service.dart';

class CollectPostcardCubit extends Cubit<CollectPostcardState> {
  final CollectPostcardService _service;

  CollectPostcardCubit(this._service) : super(InitState());

  Future<void> postCoordinates(CoordinatesRequest coordinatesRequest) async {
    emit(LoadingState());
    try {
    final response = await _service.postCoordinates(coordinatesRequest);

    emit(LoadedState(response));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }
}

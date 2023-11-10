import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/admin_cubit/admin_state.dart';
import 'package:mobile/services/admin_service.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminService _service;

  AdminCubit(this._service) : super(InitState());

  Future<void> editPostcardData(
      PostcardsDataResponse postcardsDataResponse) async {
    emit(LoadingState());
    try {
      await _service
          .editPostcardData(postcardsDataResponse)
          .then((value) => emit(LoadedState()));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }

  Future<void> addPostcardData(
      PostcardsDataResponse postcardsDataResponse) async {
    emit(LoadingState());
    try {
      await _service
          .addPostcardData(postcardsDataResponse)
          .then((value) => emit(LoadedState()));
    } catch (e) {
      emit(
        ErrorState(e.toString()),
      );
    }
  }
}

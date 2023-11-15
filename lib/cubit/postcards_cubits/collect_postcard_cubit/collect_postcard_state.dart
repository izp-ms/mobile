import 'package:mobile/api/response/post_coordinates_response.dart';

abstract class CollectPostcardState {}

class InitState extends CollectPostcardState {}

class LoadingState extends CollectPostcardState {}

class ErrorState extends CollectPostcardState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class SuccessState extends CollectPostcardState {}

class LoadedState extends CollectPostcardState {
  final PostCoordinatesResponse postCoordinatesResponse;

  LoadedState(this.postCoordinatesResponse);
}

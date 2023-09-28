import 'package:mobile/api/response/postcard_data_response.dart';

abstract class PostcardState {}

class InitState extends PostcardState {}

class LoadingState extends PostcardState {}

class ErrorState extends PostcardState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadedState extends PostcardState {
  final PostcardsDataResponse postcard;
  LoadedState(this.postcard);
}
import 'package:mobile/api/response/postcard_data_response.dart';

abstract class PostcardState {}

class InitState extends PostcardState {}

class ErrorState extends PostcardState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends PostcardState {
  final PostcardsDataResponse oldPostcardsData;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, {this.isFirstFetch=false});
}
class LoadedState extends PostcardState {
  final PostcardsDataResponse postcardsData;
  LoadedState(this.postcardsData);
}


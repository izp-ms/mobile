import 'package:mobile/api/response/postcards_data_list_response.dart';

abstract class PostcardState {}

class InitState extends PostcardState {}

class ErrorState extends PostcardState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends PostcardState {
  final PostcardsDataListResponse oldPostcardsData;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, {this.isFirstFetch=false});
}
class LoadedState extends PostcardState {
  final PostcardsDataListResponse postcardsData;
  LoadedState(this.postcardsData);
}


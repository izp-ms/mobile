import 'package:mobile/api/response/postcards_data_list_response.dart';

abstract class PostcardsDataCollectionState {}

class InitState extends PostcardsDataCollectionState {}

class ErrorState extends PostcardsDataCollectionState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends PostcardsDataCollectionState {
  final PostcardsDataListResponse oldPostcardsData;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, {this.isFirstFetch=false});
}
class LoadedState extends PostcardsDataCollectionState {
  final PostcardsDataListResponse postcardsData;
  LoadedState(this.postcardsData);
}


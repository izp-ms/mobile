import 'package:mobile/api/response/postcards_collection_response.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';

abstract class UserPostcardsDataState {}

class InitState extends UserPostcardsDataState {}

class ErrorState extends UserPostcardsDataState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends UserPostcardsDataState {
  final PostcardsDataListResponse oldPostcardsData;
  final PostcardsCollectionListResponse oldPostcardDataCollection;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, this.oldPostcardDataCollection, {this.isFirstFetch=false});
}
class LoadedState extends UserPostcardsDataState {
  final PostcardsDataListResponse postcardsData;
  final PostcardsCollectionListResponse postcardDataCollection;
  LoadedState(this.postcardsData, this.postcardDataCollection);
}


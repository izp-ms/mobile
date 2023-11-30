import 'package:mobile/api/response/postcards_collection_response.dart';
import 'package:mobile/api/response/postcards_data_list_response.dart';

abstract class PostcardsDataState {}

class InitState extends PostcardsDataState {}

class ErrorState extends PostcardsDataState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends PostcardsDataState {
  final PostcardsDataListResponse oldPostcardsData;
  final PostcardsCollectionListResponse oldPostcardDataCollection;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, this.oldPostcardDataCollection, {this.isFirstFetch=false});
}
class LoadedState extends PostcardsDataState {
  final PostcardsDataListResponse postcardsData;
  final PostcardsCollectionListResponse postcardDataCollection;
  LoadedState(this.postcardsData, this.postcardDataCollection);
}


import 'package:mobile/api/response/postcards_list_response.dart';

abstract class ReceivedPostcardsState {}

class InitState extends ReceivedPostcardsState {}

class ErrorState extends ReceivedPostcardsState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends ReceivedPostcardsState {
  final PostcardsListResponse oldPostcardsData;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, {this.isFirstFetch=false});
}
class LoadedState extends ReceivedPostcardsState {
  final PostcardsListResponse postcardsData;
  LoadedState(this.postcardsData);
}


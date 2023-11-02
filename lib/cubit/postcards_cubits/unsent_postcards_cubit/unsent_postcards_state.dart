import 'package:mobile/api/response/postcards_list_response.dart';

abstract class UnsentPostcardsState {}

class InitState extends UnsentPostcardsState {}

class ErrorState extends UnsentPostcardsState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadingState extends UnsentPostcardsState {
  final PostcardsListResponse oldPostcardsData;
  final bool isFirstFetch;
  LoadingState(this.oldPostcardsData, {this.isFirstFetch=false});
}
class LoadedState extends UnsentPostcardsState {
  final PostcardsListResponse postcardsData;
  LoadedState(this.postcardsData);
}


abstract class PostcardsCollectionState {}

class InitState extends PostcardsCollectionState {}

class LoadingState extends PostcardsCollectionState {}

class ErrorState extends PostcardsCollectionState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadedState extends PostcardsCollectionState {}
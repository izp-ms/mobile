abstract class FavouritePostcardsState {}

class InitState extends FavouritePostcardsState {}

class LoadingState extends FavouritePostcardsState {}

class ErrorState extends FavouritePostcardsState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}

class LoadedState extends FavouritePostcardsState {}
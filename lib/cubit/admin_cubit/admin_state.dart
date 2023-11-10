abstract class AdminState {}

class InitState extends AdminState {}

class LoadingState extends AdminState {}

class ErrorState extends AdminState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class LoadedState extends AdminState {}

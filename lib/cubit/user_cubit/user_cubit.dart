import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(InitState());


}

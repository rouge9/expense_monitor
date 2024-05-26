import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UserRepository _userRepository;
  UpdateUserBloc(this._userRepository) : super(UpdateUserInitial()) {
    on<UpdateUserEvent>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        await _userRepository.updateUserData(event.myUser);

        MyUser myUser = await _userRepository.getMyUser(event.myUser.userId);
        emit(UpdateUserSuccess(
          myUser,
        ));
      } catch (e) {
        emit(UpdateUserFailure(e.toString()));
      }
    });
  }
}

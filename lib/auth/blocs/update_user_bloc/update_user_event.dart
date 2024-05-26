part of 'update_user_bloc.dart';

sealed class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object> get props => [];

  get myUser => null;
}

final class UpdateUser extends UpdateUserEvent {
  @override
  final MyUser myUser;

  const UpdateUser(this.myUser);

  @override
  List<Object> get props => [myUser];
}

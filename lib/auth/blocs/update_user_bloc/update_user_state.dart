part of 'update_user_bloc.dart';

sealed class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object> get props => [];
}

final class UpdateUserInitial extends UpdateUserState {}

final class UpdateUserLoading extends UpdateUserState {}

final class UpdateUserSuccess extends UpdateUserState {
  final MyUser myUser;

  const UpdateUserSuccess(this.myUser);

  @override
  List<Object> get props => [myUser];
}

final class UpdateUserFailure extends UpdateUserState {
  final String errorMsg;

  const UpdateUserFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

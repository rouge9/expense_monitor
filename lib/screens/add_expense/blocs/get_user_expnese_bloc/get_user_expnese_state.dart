part of 'get_user_expnese_bloc.dart';

sealed class GetUserExpneseState extends Equatable {
  const GetUserExpneseState();

  @override
  List<Object> get props => [];
}

final class GetUserExpneseInitial extends GetUserExpneseState {}

final class GetUserExpneseLoading extends GetUserExpneseState {}

final class GetUserExpneseSuccess extends GetUserExpneseState {
  final List<Expense> expenses;

  const GetUserExpneseSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}

final class GetUserExpneseFailure extends GetUserExpneseState {
  final String message;

  const GetUserExpneseFailure(this.message);

  @override
  List<Object> get props => [message];
}

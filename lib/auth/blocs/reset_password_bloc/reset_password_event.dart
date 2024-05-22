part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];

  String get email => '';
}

final class ResetPassword extends ResetPasswordEvent {
  @override
  final String email;

  const ResetPassword(this.email);

  @override
  List<Object> get props => [email];
}

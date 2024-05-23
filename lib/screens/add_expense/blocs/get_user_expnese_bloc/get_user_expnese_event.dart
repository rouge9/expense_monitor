part of 'get_user_expnese_bloc.dart';

sealed class GetUserExpneseEvent extends Equatable {
  const GetUserExpneseEvent();

  @override
  List<Object> get props => [];

  String? get userId => null;
}

final class GetUserExpnese extends GetUserExpneseEvent {
  @override
  final String userId;

  const GetUserExpnese(this.userId);

  @override
  List<Object> get props => [userId];
}

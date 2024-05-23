part of 'get_user_category_bloc.dart';

sealed class GetUserCategoryEvent extends Equatable {
  const GetUserCategoryEvent();

  @override
  List<Object> get props => [];

  String? get userId => null;
}

final class GetUserCategory extends GetUserCategoryEvent {
  @override
  final String userId;

  const GetUserCategory(this.userId);

  @override
  List<Object> get props => [userId];
}

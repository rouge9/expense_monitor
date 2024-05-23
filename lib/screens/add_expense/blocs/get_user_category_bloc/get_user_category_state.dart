part of 'get_user_category_bloc.dart';

sealed class GetUserCategoryState extends Equatable {
  const GetUserCategoryState();

  @override
  List<Object> get props => [];
}

final class GetUserCategoryInitial extends GetUserCategoryState {}

final class GetUserCategoryLoading extends GetUserCategoryState {}

final class GetUserCategorySuccess extends GetUserCategoryState {
  final List<Category> categories;

  const GetUserCategorySuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

final class GetUserCategoryFailure extends GetUserCategoryState {
  final String message;

  const GetUserCategoryFailure(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_user_category_event.dart';
part 'get_user_category_state.dart';

class GetUserCategoryBloc
    extends Bloc<GetUserCategoryEvent, GetUserCategoryState> {
  ExpenseRepository expenseRepository;
  GetUserCategoryBloc(this.expenseRepository)
      : super(GetUserCategoryInitial()) {
    on<GetUserCategoryEvent>((event, emit) async {
      emit(GetUserCategoryLoading());
      try {
        List<Category> categories =
            await expenseRepository.getUserCategory(event.userId!);
        emit(GetUserCategorySuccess(categories));
      } catch (e) {
        emit(GetUserCategoryFailure(e.toString()));
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_user_expnese_event.dart';
part 'get_user_expnese_state.dart';

class GetUserExpneseBloc
    extends Bloc<GetUserExpneseEvent, GetUserExpneseState> {
  ExpenseRepository expenseRepository;
  GetUserExpneseBloc(this.expenseRepository) : super(GetUserExpneseInitial()) {
    on<GetUserExpneseEvent>((event, emit) async {
      emit(GetUserExpneseLoading());
      try {
        List<Expense> expenses =
            await expenseRepository.getUserExpenses(event.userId!);
        emit(GetUserExpneseSuccess(expenses));
      } catch (e) {
        emit(GetUserExpneseFailure(e.toString()));
      }
    });
  }
}

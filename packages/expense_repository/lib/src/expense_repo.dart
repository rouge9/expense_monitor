import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(Category category);

  Future<List<Category>> getCategory();

  Future<void> deleteCategory(Category category);

  Future<List<Category>> getUserCategory(String userId);

  Future<void> createExpense(Expense expense);

  Future<List<Expense>> getExpenses();

  Future<List<Expense>> getUserExpenses(String userId);
}

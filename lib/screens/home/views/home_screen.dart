import 'dart:math';
import 'package:expense_monitor/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/delete_category_bloc/delete_category_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_monitor/screens/add_expense/view/add_expense.dart';
import 'package:expense_monitor/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expense_monitor/screens/home/views/main_screen.dart';
import 'package:expense_monitor/screens/home/views/main_shimmering_screen.dart';
import 'package:expense_monitor/screens/stats/view/stats.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state is GetExpensesSuccess) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.outline,
                currentIndex: index,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.grip),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.chartSimple),
                    label: 'Graph',
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                var newExpense = await Navigator.push(
                    context,
                    MaterialPageRoute<Expense>(
                        builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) =>
                                      CreateCategoryBloc(FirebaseExpenseRepo()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      GetCategoriesBloc(FirebaseExpenseRepo())
                                        ..add(GetCategories()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      DeleteCategoryBloc(FirebaseExpenseRepo()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      CreateExpenseBloc(FirebaseExpenseRepo()),
                                ),
                              ],
                              child: const AddExpenseScreen(),
                            )));
                if (newExpense != null) {
                  setState(() {
                    state.expenses.insert(0, newExpense);
                  });
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                ),
              ),
            ),
            body: index == 0 ? MainScreen(state.expenses) : const StatScreen(),
          );
        } else {
          return const MainShimmeringScreen();
        }
      },
    );
  }
}

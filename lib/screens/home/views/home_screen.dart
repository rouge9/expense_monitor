import 'dart:math';
import 'package:expense_monitor/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_monitor/auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_monitor/components/main_shimmering_screen.dart';
import 'package:expense_monitor/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/delete_category_bloc/delete_category_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/get_user_expnese_bloc/get_user_expnese_bloc.dart';
import 'package:expense_monitor/screens/add_expense/view/add_expense.dart';
import 'package:expense_monitor/screens/home/views/main_screen.dart';
import 'package:expense_monitor/screens/stats/view/stats.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetUserExpneseBloc(FirebaseExpenseRepo())
            ..add(GetUserExpnese(widget.userId)),
        ),
      ],
      child: BlocBuilder<GetUserExpneseBloc, GetUserExpneseState>(
        builder: (context, state) {
          if (state is GetUserExpneseSuccess) {
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
                                    create: (context) => MyUserBloc(
                                        myUserRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository)
                                      ..add(
                                        GetMyUser(
                                            myUserId: context
                                                .read<AuthenticationBloc>()
                                                .state
                                                .user!
                                                .uid),
                                      ),
                                  ),
                                  BlocProvider(
                                    create: (context) => CreateCategoryBloc(
                                        FirebaseExpenseRepo()),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        GetCategoriesBloc(FirebaseExpenseRepo())
                                          ..add(GetCategories()),
                                  ),
                                  BlocProvider(
                                    create: (context) => DeleteCategoryBloc(
                                        FirebaseExpenseRepo()),
                                  ),
                                  BlocProvider(
                                    create: (context) => CreateExpenseBloc(
                                        FirebaseExpenseRepo()),
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
              body: index == 0
                  ? MainScreen(
                      expenses: state.expenses,
                    )
                  : const StatScreen(),
            );
          } else if (state is GetUserExpneseLoading) {
            return const MainShimmeringScreen();
          } else if (state is GetUserExpneseFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const MainShimmeringScreen();
          }
        },
      ),
    );
  }
}

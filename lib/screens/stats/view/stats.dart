import 'dart:math';
import 'package:expense_monitor/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expense_monitor/screens/home/views/home_screen.dart';
import 'package:expense_monitor/screens/stats/view/chart.dart';
import 'package:expense_monitor/screens/stats/view/stats_shummering_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  bool isIncome = false;

  DateTime? startDateRange;
  DateTime? endDateRange;
  List<Expense>? filteredExpenses;

  @override
  void initState() {
    super.initState();
    startDateRange = DateTime.now().subtract(const Duration(days: 7));
    endDateRange = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final String date = DateFormat.yMMMd().format(
        startDateRange ?? DateTime.now().subtract(const Duration(days: 7)));
    final String prevWeek =
        DateFormat.yMMMd().format(endDateRange ?? DateTime.now());

    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
      if (state is GetExpensesSuccess) {
        final List<Expense> expenses = state.expenses;

        List<Expense> filteredExpenses = expenses
            .where((element) =>
                element.date.isAfter(startDateRange ??
                    DateTime.now().subtract(const Duration(days: 7))) &&
                element.date.isBefore(endDateRange ?? DateTime.now()))
            .toList();

        final sumExpense = filteredExpenses
            .fold<int>(
                0, (previousValue, element) => previousValue + element.amount)
            .toString();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    GetExpensesBloc(FirebaseExpenseRepo())
                                      ..add(GetExpenses()),
                                child: const HomeScreen(),
                              ),
                            ),
                          );
                        },
                        icon: Icon(CupertinoIcons.arrow_left_circle_fill,
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                    const Text(
                      'Reports',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.slider_horizontal_3,
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: isIncome
                                ? LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                      Theme.of(context).colorScheme.tertiary,
                                    ],
                                    transform: const GradientRotation(pi / 4),
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isIncome = true;
                                });
                              },
                              child: Text(
                                'Income',
                                style: TextStyle(
                                  color: isIncome
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: !isIncome
                                ? LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                      Theme.of(context).colorScheme.tertiary,
                                    ],
                                    transform: const GradientRotation(pi / 4),
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isIncome = false;
                                });
                              },
                              child: Text(
                                'Expenses',
                                style: TextStyle(
                                  color: !isIncome
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2022),
                              lastDate: DateTime.now(),
                              initialDateRange: DateTimeRange(
                                start: DateTime.now()
                                    .subtract(const Duration(days: 7)),
                                end: DateTime.now(),
                              ),
                            ).then((pickedDateRange) {
                              if (pickedDateRange != null) {
                                if (pickedDateRange.duration.inDays <= 7) {
                                  setState(() {
                                    startDateRange = pickedDateRange.start;
                                    endDateRange = pickedDateRange.end
                                        .add(const Duration(days: 1));
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      dismissDirection: DismissDirection.down,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        'Date range should not be more than 7 days',
                                      ),
                                    ),
                                  );
                                }
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$date - $prevWeek',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '\$ $sumExpense.00',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: const MyChart(),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(
                                          filteredExpenses[i].category.color),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/${filteredExpenses[i].category.icon}.png',
                                    scale: 1.5,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Text(
                                filteredExpenses[i].category.name,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$ ${filteredExpenses[i].amount}.00',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd()
                                    .format(filteredExpenses[i].date)
                                    .toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        );
      } else if (state is GetExpensesLoading) {
        return const Center(
          child: StatShimmeringScreen(),
        );
      } else {
        return const Center(
          child: Text('Error'),
        );
      }
    });
  }
}

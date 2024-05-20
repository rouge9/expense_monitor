import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  final List<Expense> expenses;
  const TransactionsScreen(this.expenses, {super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool dateAssending = true;
  bool amountAssending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        dateAssending = !dateAssending;
                      });

                      if (dateAssending == true) {
                        widget.expenses
                            .sort((a, b) => a.date.compareTo(b.date));
                      } else {
                        widget.expenses
                            .sort((a, b) => b.date.compareTo(a.date));
                      }

                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By Date',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        dateAssending == false
                            ? Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 16,
                              )
                            : Icon(
                                FontAwesomeIcons.chevronUp,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 16,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        amountAssending = !amountAssending;
                      });

                      if (amountAssending == true) {
                        widget.expenses
                            .sort((a, b) => a.amount.compareTo(b.amount));
                      } else {
                        widget.expenses
                            .sort((a, b) => b.amount.compareTo(a.amount));
                      }

                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By Amount',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        amountAssending == false
                            ? Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 16,
                              )
                            : Icon(
                                FontAwesomeIcons.chevronUp,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 16,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        Navigator.pop(context);
                      },
                      icon: Icon(CupertinoIcons.arrow_left_circle_fill,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  const Text(
                    'Transactions',
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
                    child: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: Icon(
                            Icons.filter_list,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.expenses.length,
                    itemBuilder: (context, int i) {
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
                                            widget.expenses[i].category.color),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/${widget.expenses[i].category.icon}.png',
                                      scale: 1.5,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.expenses[i].category.name,
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
                                  '\$ ${widget.expenses[i].amount}.00',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd()
                                      .format(widget.expenses[i].date)
                                      .toString(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

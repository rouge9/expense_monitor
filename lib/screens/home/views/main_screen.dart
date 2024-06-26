import 'dart:math';

import 'package:expense_monitor/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_monitor/auth/blocs/update_user_bloc/update_user_bloc.dart';
import 'package:expense_monitor/auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_monitor/auth/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:expense_monitor/components/main_shimmering_screen.dart';
import 'package:expense_monitor/screens/home/views/transactions_screen.dart';
import 'package:expense_monitor/screens/home/views/profile_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;
  const MainScreen({Key? key, required this.expenses}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isDataEmpty = false;

  @override
  Widget build(BuildContext context) {
    final sumExpense = widget.expenses
        .fold<int>(
            0, (previousValue, element) => previousValue + element.amount)
        .toString();

    if (widget.expenses.isEmpty) {
      setState(() {
        isDataEmpty = true;
      });
    }

    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if (state.status == MyUserStatus.loading) {
          return const MainShimmeringScreen();
        } else if (state.status == MyUserStatus.failure) {
          return const Center(
            child: Text('Failed to load user'),
          );
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            state.user?.picture == ""
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow[800]),
                                    child: Icon(Icons.add_a_photo_outlined,
                                        size: 25, color: Colors.yellow[900]),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow[800],
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                state.user?.picture ?? ''),
                                            fit: BoxFit.cover)),
                                  ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  state.user!.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                          onPressed: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute<ProfileScreen>(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => UploadPictureBloc(
                                          context
                                              .read<AuthenticationBloc>()
                                              .userRepository,
                                        ),
                                      ),
                                      BlocProvider(
                                        create: (context) => UpdateUserBloc(
                                          context
                                              .read<AuthenticationBloc>()
                                              .userRepository,
                                        ),
                                      ),
                                    ],
                                    child: ProfileScreen(
                                      user: MyUser(
                                        userId: state.user!.userId,
                                        name: state.user!.name,
                                        email: state.user!.email,
                                        picture: state.user!.picture,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } catch (_) {}
                          },
                          icon: Icon(
                            FontAwesomeIcons.gear,
                            color: Theme.of(context).colorScheme.outline,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '\$ 4800.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.arrow_down,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Income',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '2.500.00',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.arrow_up,
                                    color: Colors.redAccent,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Expense',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '$sumExpense.00',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    isDataEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<Expense>(
                                  builder: (context) =>
                                      TransactionsScreen(widget.expenses),
                                ),
                              );
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: isDataEmpty
                      ? Center(
                          child: Text(
                            'No transactions yet',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.expenses.length > 5
                              ? 5
                              : widget.expenses.length,
                          itemBuilder: (context, int i) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              color: Color(widget
                                                  .expenses[i].category.color),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(widget.expenses[i].date)
                                            .toString(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
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
        );
      },
    );
  }
}

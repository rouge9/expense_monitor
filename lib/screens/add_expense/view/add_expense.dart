import 'dart:math';

import 'package:expense_monitor/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_monitor/auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_monitor/auth/view/welcome_screen.dart';
import 'package:expense_monitor/components/button.dart';
import 'package:expense_monitor/components/custome_app_bar.dart';
import 'package:expense_monitor/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/delete_category_bloc/delete_category_bloc.dart';
import 'package:expense_monitor/screens/add_expense/blocs/get_user_category_bloc/get_user_category_bloc.dart';
import 'package:expense_monitor/screens/add_expense/view/add_category.dart';
import 'package:expense_monitor/screens/home/views/home_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late Expense expense;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _errorMsg;

  @override
  void initState() {
    dateController.text = DateFormat.yMMMd().format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, categoryState) {
        if (categoryState is CreateExpenseSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state.status == AuthenticationStatus.authenticated) {
                    return BlocProvider(
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
                        child: HomeScreen(
                          userId: state.user!.uid,
                        ));
                  } else {
                    return const WelcomeScreen();
                  }
                },
              ),
            ),
          );
        } else if (categoryState is CreateExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.down,
              behavior: SnackBarBehavior.floating,
              content: Text(categoryState.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (categoryState is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                leadingWidth: 70,
                leading: const CustomeAppBar(),
              ),
              body: BlocBuilder<MyUserBloc, MyUserState>(
                builder: (context, userState) {
                  if (userState.status == MyUserStatus.success &&
                      userState.user != null) {
                    return BlocProvider(
                      create: (context) =>
                          GetUserCategoryBloc(FirebaseExpenseRepo())
                            ..add(GetUserCategory(userState.user!.userId)),
                      child: BlocBuilder<GetUserCategoryBloc,
                          GetUserCategoryState>(
                        builder: (context, categoryState) {
                          if (categoryState is GetUserCategorySuccess) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Add Expense',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: expenseController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              label: const Text('0'),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              filled: true,
                                              fillColor: Colors.white,
                                              prefixIcon: Icon(
                                                FontAwesomeIcons.dollarSign,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none),
                                              errorText: _errorMsg,
                                              errorStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return 'Please fill in this field';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        categorySelector(
                                            context, userState, categoryState),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TextFormField(
                                            controller: dateController,
                                            onTap: () async {
                                              DateTime? newDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate: expense.date,
                                                      firstDate: DateTime(2021),
                                                      lastDate: DateTime.now());

                                              if (newDate != null) {
                                                setState(() {
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(newDate);

                                                  expense.date = newDate;
                                                });
                                              }
                                            },
                                            readOnly: true,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              label: const Text('Date'),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              filled: true,
                                              fillColor: Colors.white,
                                              prefixIcon: Icon(
                                                FontAwesomeIcons.calendarDays,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                        ),
                                        Button(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                expense.amount = int.parse(
                                                    expenseController.text);
                                                expense.userId =
                                                    userState.user!.userId;
                                              });
                                              BlocProvider.of<
                                                          CreateExpenseBloc>(
                                                      context)
                                                  .add(CreateExpense(expense));
                                            }
                                          },
                                          text: 'Save',
                                          isGradient: true,
                                          isLoading: isLoading,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                },
              )),
        ),
      ),
    );
  }

  Column categorySelector(BuildContext context, MyUserState userState,
      GetUserCategorySuccess categoryState) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: categoryController,
            textAlignVertical: TextAlignVertical.center,
            readOnly: true,
            decoration: InputDecoration(
              label: const Text('Category'),
              hintText: 'Category',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: expense.category == Category.empty
                  ? Colors.white
                  : Color(expense.category.color),
              prefixIcon: expense.category == Category.empty
                  ? Icon(
                      FontAwesomeIcons.list,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    )
                  : Image.asset(
                      'assets/${expense.category.icon}.png',
                      scale: 1.5,
                      color: Colors.white,
                    ),
              suffixIcon: IconButton(
                onPressed: () async {
                  var newCategory =
                      await addCategory(context, userState.user!.userId);
                  if (newCategory != null) {
                    setState(() {
                      categoryState.categories.insert(0, newCategory);
                    });
                  }
                },
                icon: Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: categoryState.categories.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(Random().nextInt(100).toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    BlocProvider.of<DeleteCategoryBloc>(context)
                        .add(DeleteCategory(categoryState.categories[index]));
                    setState(() {
                      categoryState.categories.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Category'),
                          content: const Text(
                              'Are you sure you want to delete this category?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: Card(
                    color: Color(categoryState.categories[index].color),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          expense.category = categoryState.categories[index];
                          categoryController.text = expense.category.name;
                        });
                      },
                      leading: Image.asset(
                        'assets/${categoryState.categories[index].icon}.png',
                        scale: 1.5,
                        color: Colors.white,
                      ),
                      title: Text(categoryState.categories[index].name),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:expense_monitor/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_cubit.dart';
import 'package:expense_monitor/auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_monitor/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_monitor/auth/view/welcome_screen.dart';
import 'package:expense_monitor/components/main_shimmering_screen.dart';
import 'package:expense_monitor/screens/add_expense/blocs/get_user_expnese_bloc/get_user_expnese_bloc.dart';
import 'package:expense_monitor/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expense_monitor/screens/home/views/home_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GoogleAuthCubit(
            userRepo: context.read<AuthenticationBloc>().userRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SignInBloc(
              userRepository:
                  context.read<AuthenticationBloc>().userRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Monitor',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
              surface: Color(0xfff3f4f6),
              onSurface: Colors.black,
              primary: Color(0xFF00B2E7),
              secondary: Color(0xFFE064F7),
              tertiary: Color(0xFFFF8D6C),
              outline: Colors.grey),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => GoogleAuthCubit(
                      userRepo:
                          context.read<AuthenticationBloc>().userRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GetExpensesBloc(FirebaseExpenseRepo())
                      ..add(GetExpenses()),
                  ),
                  BlocProvider(
                    create: (context) => MyUserBloc(
                        myUserRepository:
                            context.read<AuthenticationBloc>().userRepository)
                      ..add(GetMyUser(
                          myUserId: context
                              .read<AuthenticationBloc>()
                              .state
                              .user!
                              .uid)),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetUserExpneseBloc(FirebaseExpenseRepo())
                          ..add(GetUserExpnese(state.user!.uid)),
                  ),
                ],
                child: HomeScreen(userId: state.user!.uid),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}

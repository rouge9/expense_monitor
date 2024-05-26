import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_monitor/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_cubit.dart';
import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_state.dart';
import 'package:expense_monitor/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_monitor/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:expense_monitor/auth/view/signin.dart';
import 'package:expense_monitor/auth/view/signup.dart';
import 'package:expense_monitor/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 90,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 410,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1000),
                    viewportFraction: 0.8,
                  ),
                  items: [
                    carsoulItem(
                        Text(
                          'Welcome To',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          'Expanse',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        'assets/onbording1.png'),
                    carsoulItem(
                        Text(
                          'Fast and Easy way to track all your',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          'expenses and incomes...',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        'assets/onbording2.png'),
                    carsoulItem(
                        Text(
                          'Fast & Secure',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          'Authentication',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        'assets/onbording3.png')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Let\'s Get Started...',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(
                  height: 20,
                ),
                Button(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => SignUpBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository,
                            ),
                            child: const SignUpScreen(),
                          ),
                        ),
                      );
                    },
                    text: 'Sign Up',
                    isGradient: true),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<GoogleAuthCubit, GoogleAuthState>(
                    listener: (context, state) {
                  if (state is GoogleAuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                  if (state is GoogleAuthSuccess) {
                    Navigator.pop(context);
                  }
                }, builder: (context, state) {
                  return Button(
                    onPressed: () {
                      state is GoogleAuthLoading
                          ? null
                          : context.read<GoogleAuthCubit>().login();
                    },
                    text: 'Continue with google',
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    isGradient: false,
                    isLoading: state is GoogleAuthLoading,
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SignInBloc(
                                userRepository: context
                                    .read<AuthenticationBloc>()
                                    .userRepository,
                              ),
                              child: const SignInScreen(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container carsoulItem(Text title, Text subtitle, String image) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
          ),
          const SizedBox(height: 20),
          title,
          subtitle
        ],
      ),
    );
  }
}

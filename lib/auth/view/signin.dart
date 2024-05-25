import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_cubit.dart';
import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_state.dart';
import 'package:expense_monitor/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_monitor/auth/view/forgot_password.dart';
import 'package:expense_monitor/components/button.dart';
import 'package:expense_monitor/components/custome_app_bar.dart';
import 'package:expense_monitor/components/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: const CustomeAppBar(),
            leadingWidth: 70,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Sign In To Expanse',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    controller: emailController,
                    hintText: 'email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(FontAwesomeIcons.at,
                        size: 16, color: Theme.of(context).colorScheme.outline),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: passwordController,
                    hintText: '******',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icon(FontAwesomeIcons.key,
                        size: 16, color: Theme.of(context).colorScheme.outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          iconPassword = obscurePassword
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill;
                        });
                      },
                      icon: Icon(iconPassword,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    errorMsg: _errorMsg,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<SignInBloc, SignInState>(
                    listener: (context, state) {
                      if (state is SignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message.toString()),
                          ),
                        );
                      }
                      if (state is SignInSuccess) {
                        Navigator.pop(context);
                      }
                      if (state is SignInProcess) {
                        setState(() {
                          signInRequired = true;
                        });
                      } else {
                        setState(() {
                          signInRequired = false;
                        });
                      }
                    },
                    builder: (context, state) {
                      return Button(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInBloc>().add(SignInRequired(
                                emailController.text, passwordController.text));
                          }
                        },
                        text: 'Sign In',
                        isGradient: true,
                        isLoading: signInRequired,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<GoogleAuthCubit, GoogleAuthState>(
                      listener: (context, state) {
                    if (state is GoogleAuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

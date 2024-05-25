import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_cubit.dart';
import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_state.dart';
import 'package:expense_monitor/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:expense_monitor/auth/view/signin.dart';
import 'package:expense_monitor/components/button.dart';
import 'package:expense_monitor/components/custome_app_bar.dart';
import 'package:expense_monitor/components/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
          Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          setState(() {
            signUpRequired = false;
          });
        }
      },
      child: Form(
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
                    const SizedBox(height: 40),
                    MyTextField(
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(FontAwesomeIcons.at,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline),
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
                            size: 16,
                            color: Theme.of(context).colorScheme.outline),
                        onChanged: (val) {
                          if (val!.contains(RegExp(r'[A-Z]'))) {
                            setState(() {
                              containsUpperCase = true;
                            });
                          } else {
                            setState(() {
                              containsUpperCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[a-z]'))) {
                            setState(() {
                              containsLowerCase = true;
                            });
                          } else {
                            setState(() {
                              containsLowerCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[0-9]'))) {
                            setState(() {
                              containsNumber = true;
                            });
                          } else {
                            setState(() {
                              containsNumber = false;
                            });
                          }
                          if (val.contains(RegExp(
                              r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                            setState(() {
                              containsSpecialChar = true;
                            });
                          } else {
                            setState(() {
                              containsSpecialChar = false;
                            });
                          }
                          if (val.length >= 8) {
                            setState(() {
                              contains8Length = true;
                            });
                          } else {
                            setState(() {
                              contains8Length = false;
                            });
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                              if (obscurePassword) {
                                iconPassword = CupertinoIcons.eye_fill;
                              } else {
                                iconPassword = CupertinoIcons.eye_slash_fill;
                              }
                            });
                          },
                          icon: Icon(
                            iconPassword,
                            color: Theme.of(context).colorScheme.outline,
                          ),
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
                        }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: containsUpperCase
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "1 uppercase",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ]),
                            Row(children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: containsLowerCase
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "1 lowercase",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ]),
                            Row(children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: containsNumber
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "1 number",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ]),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: containsSpecialChar
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "1 special character",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ]),
                            Row(children: [
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: contains8Length
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "8 characters",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          prefixIcon: Icon(CupertinoIcons.person_fill,
                              color: Theme.of(context).colorScheme.outline),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            } else if (val.length > 30) {
                              return 'Name too long';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
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
                    ),
                    const SizedBox(height: 20),
                    Button(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            MyUser myUser = MyUser.empty;
                            myUser = myUser.copyWith(
                              email: emailController.text,
                              name: nameController.text,
                            );
                            setState(() {
                              context.read<SignUpBloc>().add(SignUpRequired(
                                  myUser, passwordController.text));
                            });
                          }
                        },
                        text: 'Create Account',
                        isGradient: true,
                        isLoading: signUpRequired),
                    const SizedBox(height: 20),
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
      ),
    );
  }
}

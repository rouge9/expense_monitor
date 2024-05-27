import 'package:bloc/bloc.dart';
import 'package:expense_monitor/app.dart';
import 'package:expense_monitor/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  FlutterNativeSplash.remove();
  runApp(MyApp(FirebaseUserRepo()));
}

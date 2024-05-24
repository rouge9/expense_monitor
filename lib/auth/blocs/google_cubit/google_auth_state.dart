import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthReset extends GoogleAuthState {
  final GoogleSignInAccount account;

  GoogleAuthReset(this.account);
}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final User user;

  GoogleAuthSuccess(this.user);
}

class GoogleAuthFailure extends GoogleAuthState {
  final String message;

  GoogleAuthFailure(this.message);
}

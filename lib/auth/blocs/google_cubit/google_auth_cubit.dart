import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_repository/user_repository.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final UserRepository _userRepository;

  GoogleAuthCubit({
    required UserRepository userRepo,
  })  : _userRepository = userRepo,
        super(GoogleAuthInitial());
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _auth = FirebaseAuth.instance;

  Future<void> login() async {
    emit(GoogleAuthLoading());
    try {
      // select google account
      final userAccount = await _googleSignIn.signIn();

      // user aborted
      if (userAccount == null) {
        emit(GoogleAuthFailure('User aborted'));
        return;
      }

      // get authentication object from account
      final GoogleSignInAuthentication googleAuth =
          await userAccount.authentication;

      // create OAuth credential from the authentication object
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // login to firebase using the OAuth credential
      final userCredential = await _auth.signInWithCredential(credential);
      await _userRepository.setUserData(
        MyUser(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email.toString(),
          name: userCredential.user!.displayName.toString(),
        ),
      );

      emit(GoogleAuthSuccess(userCredential.user!));
    } catch (e) {
      emit(GoogleAuthFailure(e.toString()));
    }
  }
}

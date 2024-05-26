import 'package:firebase_auth/firebase_auth.dart';
import 'models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void> signIn(String email, String password);

  Future<void> resetPassword(String email);

  Future<MyUser> signInWithGoogle();

  Future<MyUser> getMyUser(String userId);

  Future<void> updateUserData(MyUser user);

  Future<void> logOut();

  Future<String> uploadPicture(String file, String userId);
}

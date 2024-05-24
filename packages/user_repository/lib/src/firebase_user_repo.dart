import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';
import 'package:uuid/uuid.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<void> createDeafultCategories(String userId) async {
    final List<Category> defaultCategories = [
      Category(
        categoryId: const Uuid().v1(),
        name: 'Food',
        icon: 'food',
        color: 0xffffca5c,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Transport',
        icon: 'transport',
        color: 0xff459ee8,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Shopping',
        icon: 'shopping',
        color: 0xff9c54e3,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Entertainment',
        icon: 'entertainment',
        color: 0xffe73f3f,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Health',
        icon: 'health',
        color: 4287135203,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Bills',
        icon: 'bills',
        color: 0xffcd66fe,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Pet',
        icon: 'pet',
        color: 0xffbf6d6d,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Fuel',
        icon: 'fuel',
        color: 0xffee879b,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Travel',
        icon: 'travel',
        color: 0xff08b59a,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Home Rent',
        icon: 'home',
        color: 0xffffc857,
        userId: userId,
      ),
      Category(
        categoryId: const Uuid().v1(),
        name: 'Recharge',
        icon: 'tech',
        color: 0xff17cdb0,
        userId: userId,
      ),
    ];

    for (var category in defaultCategories) {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    }
  }

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(userId: user.user!.uid);
      createDeafultCategories(myUser.userId);
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      return MyUser(
        userId: user!.uid,
        email: user.email!,
        name: user.displayName!,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());

      final categoriesSnapshot = await categoryCollection
          .where('userId', isEqualTo: myUser.userId)
          .get();

      if (categoriesSnapshot.docs.isEmpty) {
        // User has no categories, add default categories
        createDeafultCategories(myUser.userId);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      final user = await usersCollection.doc(myUserId).get();
      return MyUser.fromEntity(MyUserEntity.fromDocument(user.data()!));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String> uploadPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(
        imageFile,
      );
      String url = await firebaseStoreRef.getDownloadURL();
      await usersCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

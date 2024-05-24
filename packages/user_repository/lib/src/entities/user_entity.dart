import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;
  final String name;
  String? picture;

  MyUserEntity(
      {required this.userId,
      required this.email,
      required this.name,
      this.picture});

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'picture': picture ?? ''
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        picture: doc['picture']);
  }

  @override
  List<Object?> get props => [userId, email, name, picture];
}

import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String name;
  String? picture;

  MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      this.picture});

  static final empty = MyUser(userId: '', email: '', name: '', picture: '');

  MyUser copyWith({String? userId, String? email, String? name}) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        picture: picture ?? '');
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
        userId: userId, email: email, name: name, picture: picture);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        name: entity.name,
        picture: entity.picture);
  }

  @override
  List<Object?> get props => [userId, email, name, picture];
}

import '../entities/entities.dart';

class Category {
  String categoryId;
  String name;
  String icon;
  int color;
  String userId;

  Category({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
    required this.userId,
  });

  //  Empty user which represents an unauthenticated user
  static final empty = Category(
    categoryId: '',
    name: '',
    icon: '',
    color: 0,
    userId: '',
  );

// modify myUser Parameters
  Category copyWith({
    String? categoryId,
    String? name,
    String? icon,
    int? color,
    String? userId,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      userId: userId ?? this.userId,
    );
  }

  // convience getter to determine if the current user is empty
  bool get isEmpty => this == Category.empty;

  // convience getter to determine if the current user is empty

  bool get isNotEmpty => this != Category.empty;

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      icon: icon,
      color: color,
      userId: userId,
    );
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      icon: entity.icon,
      color: entity.color,
      userId: entity.userId,
    );
  }

  @override
  String toString() {
    return 'Category { categoryId: $categoryId, name: $name, icon: $icon, color: $color,userId: $userId }';
  }
}

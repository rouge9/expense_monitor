class CategoryEntity {
  String categoryId;
  String name;
  String icon;
  int color;
  String userId;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
    required this.userId,
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'icon': icon,
      'color': color,
      'userId': userId,
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> doc) {
    return CategoryEntity(
      categoryId: doc['categoryId'],
      name: doc['name'],
      icon: doc['icon'],
      color: doc['color'],
      userId: doc['userId'],
    );
  }

  @override
  String toString() {
    return 'CategoryEntity { categoryId: $categoryId, name: $name, icon: $icon, color: $color,userId: $userId}';
  }
}

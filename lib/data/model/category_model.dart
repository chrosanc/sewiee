class CategoryModel {
  final String id;
  final String name;
  final String iconUrl;

  CategoryModel({required this.id, required this.name, required this.iconUrl});

  factory CategoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CategoryModel(id: id, name: data['name'] ?? '', iconUrl: data['icon_url'] ?? '');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;


}

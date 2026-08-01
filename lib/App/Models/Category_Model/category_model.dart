class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.isActive = true,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'isActive': isActive};
  }

  // Convert from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      isActive: json['isActive'] ?? true,
    );
  }
}

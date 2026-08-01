// lib/App/Models/Cart_Model/cart_models.dart
class CartItemModel {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;
  final String restaurant;
  final bool isVeg;
  final String? selectedWeight; // Added: selected weight variant
  final String? category; // Added: product category
  final String? brand; // Added: product brand

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.restaurant,
    required this.isVeg,
    this.selectedWeight,
    this.category,
    this.brand,
  });

  // Create a copy with updated fields
  CartItemModel copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? restaurant,
    bool? isVeg,
    String? selectedWeight,
    String? category,
    String? brand,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      restaurant: restaurant ?? this.restaurant,
      isVeg: isVeg ?? this.isVeg,
      selectedWeight: selectedWeight ?? this.selectedWeight,
      category: category ?? this.category,
      brand: brand ?? this.brand,
    );
  }

  // Get display name with variant info
  String get displayName {
    if (selectedWeight != null && selectedWeight!.isNotEmpty) {
      return '$name ($selectedWeight)';
    }
    return name;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'restaurant': restaurant,
      'isVeg': isVeg,
      'selectedWeight': selectedWeight,
      'category': category,
      'brand': brand,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      restaurant: json['restaurant'],
      isVeg: json['isVeg'],
      selectedWeight: json['selectedWeight'],
      category: json['category'],
      brand: json['brand'],
    );
  }
}

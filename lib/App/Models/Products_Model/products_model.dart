class ProductModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final String originalPrice;
  final String discount;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int reviews;
  final bool isInStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.isInStock,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      originalPrice: map['originalPrice'] ?? '',
      discount: map['discount'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviews: map['reviews'] ?? 0,
      isInStock: map['isInStock'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'reviews': reviews,
      'isInStock': isInStock,
    };
  }
}

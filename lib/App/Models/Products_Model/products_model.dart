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
  bool isLiked;
  int quantity;

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
    this.isInStock = true,
    this.isLiked = false,
    this.quantity = 1,
  });
}

class ProductCategory {
  final String id;
  final String name;
  final String icon;
  final int productCount;
  bool isSelected;

  ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.productCount = 0,
    this.isSelected = false,
  });
}

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => double.parse(product.price) * quantity;
}

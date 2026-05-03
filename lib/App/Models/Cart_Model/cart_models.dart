class CartItemModel {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;
  final String restaurant;
  final bool isVeg;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.restaurant,
    required this.isVeg,
  });
}

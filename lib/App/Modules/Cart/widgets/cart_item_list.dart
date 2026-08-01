// lib/App/Modules/Cart/widgets/cart_item_list.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/cart_item_card.dart';

class CartItemList extends StatelessWidget {
  final CartController controller;

  const CartItemList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.cartItems.length,
        itemBuilder: (context, index) {
          final item = controller.cartItems[index];
          return CartItemCard(item: item, index: index, controller: controller);
        },
      ),
    );
  }
}

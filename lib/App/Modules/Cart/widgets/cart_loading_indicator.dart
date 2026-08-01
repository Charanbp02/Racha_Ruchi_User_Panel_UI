// lib/App/Modules/Cart/widgets/cart_loading_indicator.dart
import 'package:flutter/material.dart';

class CartLoadingIndicator extends StatelessWidget {
  const CartLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFE53935)),
    );
  }
}

// lib/App/Modules/Products/widgets/products_loading_view.dart
import 'package:flutter/material.dart';

class ProductsLoadingView extends StatelessWidget {
  const ProductsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading products...'),
        ],
      ),
    );
  }
}

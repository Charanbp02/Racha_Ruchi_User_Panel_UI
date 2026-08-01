// lib/App/Modules/Cart/widgets/empty_cart.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyIcon(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildSubtitle(),
          const SizedBox(height: 20),
          _buildBrowseButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Iconsax.shopping_bag,
        size: 60,
        color: Color(0xFFE53935),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Your Cart is Empty',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D2D2D),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Add items to get started',
      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    );
  }

  Widget _buildBrowseButton() {
    return ElevatedButton(
      onPressed: () => Get.back(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: const Text('Browse Items'),
    );
  }
}

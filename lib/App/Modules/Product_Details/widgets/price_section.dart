// lib/App/Modules/Product_Details/widgets/price_section.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class PriceSection extends StatelessWidget {
  final ProductModel product;

  const PriceSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffFEF2F2), Color(0xffFEE2E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [_buildPriceDetails(), const Spacer(), _buildDiscountIcon()],
      ),
    );
  }

  Widget _buildPriceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price",
          style: TextStyle(
            color: Color(0xff9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              "₹${product.price}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xffEF4444),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            if (product.originalPrice > product.price)
              Text(
                "₹${product.originalPrice}",
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Color(0xff9CA3AF),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Iconsax.discount_shape,
        color: Color(0xffEF4444),
        size: 28,
      ),
    );
  }
}

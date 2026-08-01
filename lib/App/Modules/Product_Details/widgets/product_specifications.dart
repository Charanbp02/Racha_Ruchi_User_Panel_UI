// lib/App/Modules/Product_Details/widgets/product_specifications.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductSpecifications extends StatelessWidget {
  final String category;
  final String brand;
  final String sku;
  final double rating;
  final int reviews;
  final bool hasWeightVariants;
  final String weightVariantsDisplay;

  const ProductSpecifications({
    super.key,
    required this.category,
    required this.brand,
    required this.sku,
    required this.rating,
    required this.reviews,
    required this.hasWeightVariants,
    required this.weightVariantsDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Specifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF9FAFB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildSpecTile(
                icon: Iconsax.category,
                title: "Category",
                value: category,
              ),
              const Divider(height: 1, indent: 60),
              _buildSpecTile(icon: Iconsax.bag, title: "Brand", value: brand),
              const Divider(height: 1, indent: 60),
              _buildSpecTile(icon: Iconsax.barcode, title: "SKU", value: sku),
              const Divider(height: 1, indent: 60),
              _buildSpecTile(
                icon: Iconsax.star,
                title: "Rating",
                value: "$rating / 5.0 ($reviews reviews)",
              ),
              if (hasWeightVariants) ...[
                const Divider(height: 1, indent: 60),
                _buildSpecTile(
                  icon: Iconsax.weight,
                  title: "Available Weights",
                  value: weightVariantsDisplay,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: const Color(0xffEF4444)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

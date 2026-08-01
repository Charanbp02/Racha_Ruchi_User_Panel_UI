// lib/App/Modules/Product_Details/widgets/product_info_header.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class ProductInfoHeader extends StatelessWidget {
  final ProductModel product;

  const ProductInfoHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDiscountRatingRow(),
        const SizedBox(height: 20),
        _buildProductName(),
        const SizedBox(height: 8),
        _buildBrandSkuRow(),
      ],
    );
  }

  Widget _buildDiscountRatingRow() {
    return Row(
      children: [
        if (product.discount > 0) _buildDiscountBadge(),
        const Spacer(),
        _buildRatingBadge(),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff10B981), Color(0xff059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            "${product.discount.toInt()}% OFF",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffFEF3C7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 18, color: Color(0xffF59E0B)),
          const SizedBox(width: 4),
          Text(
            product.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xff92400E),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "(${product.reviews})",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      product.name,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildBrandSkuRow() {
    return Row(
      children: [
        _buildInfoChip(icon: Iconsax.tag, label: product.brand),
        const SizedBox(width: 12),
        _buildInfoChip(icon: Iconsax.barcode, label: product.sku),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xff6B7280)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

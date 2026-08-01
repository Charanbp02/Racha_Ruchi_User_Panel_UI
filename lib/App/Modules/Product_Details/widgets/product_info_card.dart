// lib/App/Modules/Product_Details/widgets/product_info_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductInfoCard extends StatelessWidget {
  final String name;
  final String brand;
  final String sku;
  final double price;
  final double originalPrice;
  final double discount;
  final double rating;
  final int reviews;
  final int stock;

  const ProductInfoCard({
    super.key,
    required this.name,
    required this.brand,
    required this.sku,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.reviews,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDiscountAndRatingRow(),
        const SizedBox(height: 20),
        _buildProductName(),
        const SizedBox(height: 8),
        _buildBrandAndSku(),
        const SizedBox(height: 20),
        _buildPriceSection(),
        const SizedBox(height: 24),
        _buildStockStatus(),
      ],
    );
  }

  Widget _buildDiscountAndRatingRow() {
    return Row(
      children: [
        if (discount > 0) _buildDiscountBadge(),
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
            "${discount.toInt()}% OFF",
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
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xff92400E),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "($reviews)",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildBrandAndSku() {
    return Row(
      children: [
        _buildInfoChip(Iconsax.tag, brand),
        const SizedBox(width: 12),
        _buildInfoChip(Iconsax.barcode, sku),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
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

  Widget _buildPriceSection() {
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
        children: [
          Column(
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
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffEF4444),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (originalPrice > price)
                    Text(
                      "₹$originalPrice",
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
          ),
          const Spacer(),
          Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildStockStatus() {
    final bool inStock = stock > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: inStock ? const Color(0xffF0FDF4) : const Color(0xffFEF2F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: inStock ? const Color(0xff86EFAC) : const Color(0xffFECACA),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  inStock ? const Color(0xff86EFAC) : const Color(0xffFECACA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              inStock ? Iconsax.tick_circle : Iconsax.close_circle,
              color:
                  inStock ? const Color(0xff166534) : const Color(0xff991B1B),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inStock ? "In Stock" : "Out of Stock",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        inStock
                            ? const Color(0xff166534)
                            : const Color(0xff991B1B),
                  ),
                ),
                if (inStock)
                  Text(
                    "$stock items available",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff6B7280),
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

// lib/App/Modules/Product_Details/widgets/stock_status.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class StockStatus extends StatelessWidget {
  final ProductModel product;

  const StockStatus({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isInStock = product.stock > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isInStock ? const Color(0xffF0FDF4) : const Color(0xffFEF2F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isInStock ? const Color(0xff86EFAC) : const Color(0xffFECACA),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildStatusIcon(isInStock),
          const SizedBox(width: 12),
          Expanded(child: _buildStatusText(isInStock)),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool isInStock) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isInStock ? const Color(0xff86EFAC) : const Color(0xffFECACA),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isInStock ? Iconsax.tick_circle : Iconsax.close_circle,
        color: isInStock ? const Color(0xff166534) : const Color(0xff991B1B),
        size: 20,
      ),
    );
  }

  Widget _buildStatusText(bool isInStock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isInStock ? "In Stock" : "Out of Stock",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color:
                isInStock ? const Color(0xff166534) : const Color(0xff991B1B),
          ),
        ),
        if (isInStock)
          Text(
            "${product.stock} items available",
            style: const TextStyle(fontSize: 13, color: Color(0xff6B7280)),
          ),
      ],
    );
  }
}

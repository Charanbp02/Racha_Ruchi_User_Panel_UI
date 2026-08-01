// lib/App/Modules/Product_Details/widgets/quantity_selector.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_details_controller.dart';

class QuantitySelector extends StatelessWidget {
  final ProductDetailsController controller;

  const QuantitySelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quantity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Select number of items",
                style: TextStyle(fontSize: 12, color: Color(0xff9CA3AF)),
              ),
            ],
          ),
          const Spacer(),
          _buildQuantityControls(),
        ],
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.decreaseQty,
            icon: const Icon(Icons.remove, color: Color(0xffEF4444), size: 20),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xffFEF2F2),
              shape: const CircleBorder(),
            ),
          ),
          Obx(
            () => SizedBox(
              width: 50,
              child: Text(
                controller.quantity.toString(), // Use getter without .value
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: controller.increaseQty,
            icon: const Icon(Icons.add, color: Color(0xff10B981), size: 20),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xffF0FDF4),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

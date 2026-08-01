// lib/App/Modules/Cart/widgets/cart_summary.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';
import 'package:racharuchi/App/Modules/Cart/widgets/price_detail_row.dart';

class CartSummary extends StatelessWidget {
  final CartController controller;

  const CartSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceDetails(),
            const SizedBox(height: 16),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails() {
    return Column(
      children: [
        PriceDetailRow(
          title: 'Subtotal (${controller.totalItems} items)',
          amount: '₹${controller.getSubtotal().toStringAsFixed(2)}',
        ),
        PriceDetailRow(
          title: 'Delivery Charge',
          amount:
              controller.getDeliveryCharge() == 0
                  ? 'Free'
                  : '₹${controller.getDeliveryCharge().toStringAsFixed(2)}',
        ),
        // ✅ Tax row removed completely
        const Divider(height: 16),
        PriceDetailRow(
          title: 'Total',
          amount: '₹${controller.getTotal().toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.proceedToCheckout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53935),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Proceed to Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

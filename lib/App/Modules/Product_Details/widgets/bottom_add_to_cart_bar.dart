// lib/App/Modules/Product_Details/widgets/bottom_add_to_cart_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Product_Details/controller/product_details_controller.dart';

class BottomAddToCartBar extends StatelessWidget {
  final ProductDetailsController controller;

  const BottomAddToCartBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = controller.productModel.product;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildTotalPrice(product.price),
            const SizedBox(width: 16),
            _buildAddToCartButton(product),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPrice(double price) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Amount",
            style: TextStyle(
              color: Color(0xff9CA3AF),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              "₹${(price * controller.quantity).toStringAsFixed(2)}", // Use getter without .value
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xffEF4444),
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(product) {
    final bool inStock = product.stock > 0;

    return Expanded(
      flex: 3,
      child: Obx(
        () => Container(
          height: 56,
          decoration: BoxDecoration(
            gradient:
                inStock
                    ? const LinearGradient(
                      colors: [Color(0xffEF4444), Color(0xffDC2626)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                    : const LinearGradient(
                      colors: [Colors.grey, Colors.grey],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              if (inStock)
                BoxShadow(
                  color: const Color(0xffEF4444).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon:
                controller
                        .isAddingToCart // Use getter without .value
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Icon(
                      inStock ? Iconsax.shopping_bag : Iconsax.close_circle,
                      size: 22,
                    ),
            label: Text(
              inStock
                  ? (controller.isAddingToCart
                      ? 'Adding...'
                      : 'Add to Cart') // Use getter without .value
                  : 'Out of Stock',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed:
                (inStock &&
                        !controller.isAddingToCart) // Use getter without .value
                    ? () async => await controller.addToCart()
                    : null,
          ),
        ),
      ),
    );
  }
}

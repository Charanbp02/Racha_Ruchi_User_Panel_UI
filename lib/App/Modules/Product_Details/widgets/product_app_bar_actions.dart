// lib/App/Modules/Product_Details/widgets/product_app_bar_actions.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Product_Details/controller/product_details_controller.dart';

class ProductAppBarActions extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductAppBarActions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [_buildBackButton(), const Spacer(), _buildWishlistButton()],
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            color: Colors.black87,
            onPressed: () => Get.back(),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Obx(
            () => IconButton(
              icon: Icon(
                controller.isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                size: 20,
              ),
              color:
                  controller.isInWishlist
                      ? const Color(0xffEF4444)
                      : Colors.grey.shade600,
              onPressed: controller.toggleWishlist,
            ),
          ),
        ),
      ),
    );
  }
}

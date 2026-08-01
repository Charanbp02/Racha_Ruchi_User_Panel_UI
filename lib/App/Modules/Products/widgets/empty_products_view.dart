// lib/App/Modules/Products/widgets/empty_products_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class EmptyProductsView extends StatelessWidget {
  const EmptyProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.searchQuery.value.isNotEmpty
                  ? Iconsax.search_normal_1
                  : Iconsax.box_1,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'No products found'
                  : 'No products available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            if (controller.searchQuery.value.isNotEmpty) ...[
              Text(
                'Try different keywords or check spelling',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: controller.clearSearch,
                icon: const Icon(Iconsax.close_circle, size: 16),
                label: const Text('Clear Search'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ] else
              Text(
                'Pull down to refresh',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }
}

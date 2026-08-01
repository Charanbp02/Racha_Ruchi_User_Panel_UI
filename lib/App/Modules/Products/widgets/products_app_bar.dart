// lib/App/Modules/Products/widgets/products_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class ProductsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return AppBar(
      title: const Text(
        'Products',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [_buildCartIcon(), _buildConnectionStatus(controller)],
      bottom: _buildSearchBar(controller),
    );
  }

  Widget _buildCartIcon() {
    return Obx(
      () => Stack(
        children: [
          IconButton(
            icon: const Icon(Iconsax.shopping_cart, size: 22),
            onPressed: () {
              final cartController = Get.find<CartController>();
              cartController.loadCartItems();
              Get.toNamed('/cart');
            },
          ),
          if (Get.isRegistered<CartController>() &&
              Get.find<CartController>().totalItems > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '${Get.find<CartController>().totalItems}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(ProductsController controller) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.isConnected.value ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              controller.isConnected.value ? 'Live' : 'Offline',
              style: TextStyle(
                fontSize: 12,
                color: controller.isConnected.value ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSearchBar(ProductsController controller) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller.searchController,
            onChanged: (value) => controller.searchProductsRealtime(value),
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Search products by name...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Iconsax.search_normal, size: 20),
              suffixIcon: Obx(
                () =>
                    controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Iconsax.close_circle, size: 18),
                          onPressed: () {
                            controller.clearSearch();
                          },
                        )
                        : const SizedBox.shrink(),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}

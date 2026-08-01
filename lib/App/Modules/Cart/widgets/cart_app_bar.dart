// lib/App/Modules/Cart/widgets/cart_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Obx(
        () => Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Iconsax.shopping_cart,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Cart',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.totalItems}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: _buildBackButton(isDarkMode),
      actions: [
        _buildClearCartButton(controller, isDarkMode),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isDarkMode) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildClearCartButton(CartController controller, bool isDarkMode) {
    return Obx(
      () => IconButton(
        onPressed: controller.cartItems.isEmpty ? null : controller.clearCart,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                controller.cartItems.isEmpty
                    ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100)
                    : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Iconsax.trash,
            size: 18,
            color:
                controller.cartItems.isEmpty
                    ? (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400)
                    : const Color(0xFFE53935),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

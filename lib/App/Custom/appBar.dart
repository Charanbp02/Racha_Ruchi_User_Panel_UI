import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Cart/binding/cart_binding.dart';
import 'package:racharuchi/App/Modules/Cart/view/cart_view.dart';
import 'package:racharuchi/App/Modules/Notifications/binding/notification_binding.dart';
import 'package:racharuchi/App/Modules/Notifications/view/notification_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int notificationCount;
  final int cartItemCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.notificationCount = 0,
    this.cartItemCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          bottom: 10,
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo + Title
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "RC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),

            // Action Buttons
            Row(
              children: [
                // Notification Button
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const NotificationView(),
                      binding: NotificationBinding(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.notification,
                          size: 18,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53935),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              notificationCount > 9
                                  ? '9+'
                                  : '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Cart Button with Badge
                GestureDetector(
                  onTap: () {
                    // Navigate to Cart Page
                    Get.to(
                      () => const CartView(),
                      binding: CartBinding(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.shopping_bag,
                          size: 18,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53935),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cartItemCount > 9 ? '9+' : '$cartItemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

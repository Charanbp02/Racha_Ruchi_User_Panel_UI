// lib/App/Custom/widgets/app_bar_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Custom/widgets/app_bar_icon_button.dart';
import 'package:racharuchi/App/Modules/Cart/binding/cart_binding.dart';
import 'package:racharuchi/App/Modules/Cart/view/cart_view.dart';
import 'package:racharuchi/App/Modules/Notifications/binding/notification_binding.dart';
import 'package:racharuchi/App/Modules/Notifications/view/notification_view.dart';

class AppBarActions extends StatelessWidget {
  final int notificationCount;
  final int cartItemCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;

  const AppBarActions({
    super.key,
    this.notificationCount = 0,
    this.cartItemCount = 0,
    this.onNotificationTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Notification Button
        AppBarIconButton(
          icon: Iconsax.notification,
          onTap: onNotificationTap ?? _defaultNotificationTap,
          badgeCount: notificationCount,
        ),
        const SizedBox(width: 12),

        // Cart Button
        AppBarIconButton(
          icon: Iconsax.shopping_bag,
          onTap: onCartTap ?? _defaultCartTap,
          badgeCount: cartItemCount,
        ),
      ],
    );
  }

  void _defaultNotificationTap() {
    HapticFeedback.lightImpact();
    Get.to(
      () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _defaultCartTap() {
    HapticFeedback.lightImpact();
    Get.to(
      () => const CartView(),
      binding: CartBinding(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 400),
    );
  }
}

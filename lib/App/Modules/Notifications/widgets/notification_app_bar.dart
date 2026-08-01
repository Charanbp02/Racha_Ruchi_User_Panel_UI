// lib/App/Modules/Notifications/widgets/notification_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Notifications/controller/notification_controller.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return AppBar(
      title: const Text(
        'Notifications',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF2D2D2D),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(() {
          if (controller.notifications.isNotEmpty) {
            return _buildPopupMenu(controller);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildPopupMenu(NotificationController controller) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.more, color: Color(0xFF2D2D2D)),
      onSelected: (value) {
        if (value == 'mark_all') {
          controller.markAllAsRead();
        } else if (value == 'clear_all') {
          controller.clearAllNotifications();
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'mark_all',
              child: Row(
                children: [
                  Icon(Iconsax.tick_square, size: 18),
                  SizedBox(width: 8),
                  Text('Mark all as read'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Iconsax.trash, size: 18),
                  SizedBox(width: 8),
                  Text('Clear all'),
                ],
              ),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

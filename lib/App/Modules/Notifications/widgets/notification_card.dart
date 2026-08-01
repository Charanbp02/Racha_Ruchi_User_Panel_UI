// lib/App/Modules/Notifications/widgets/notification_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Notifications/notification_model.dart';
import 'package:racharuchi/App/Modules/Notifications/controller/notification_controller.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_action_button.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_content.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_icon.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final NotificationController controller;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: _buildCardContent(),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Iconsax.trash, color: Colors.white),
    );
  }

  Widget _buildCardContent() {
    return GestureDetector(
      onTap: () => controller.onNotificationTap(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: _buildCardDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationIcon(notification: notification),
            const SizedBox(width: 12),
            Expanded(child: NotificationContent(notification: notification)),
            NotificationActionButton(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color:
          notification.isRead
              ? Colors.white
              : const Color(0xFFE53935).withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color:
            notification.isRead
                ? Colors.grey.shade200
                : const Color(0xFFE53935).withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

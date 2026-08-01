// lib/App/Modules/Notifications/widgets/notification_icon.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Models/Notifications/notification_model.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationModel notification;

  const NotificationIcon({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: notification.type.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          notification.type.icon,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

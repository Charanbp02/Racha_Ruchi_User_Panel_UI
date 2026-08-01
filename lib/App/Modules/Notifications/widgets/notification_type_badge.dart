// lib/App/Modules/Notifications/widgets/notification_type_badge.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Models/Notifications/notification_model.dart';

class NotificationTypeBadge extends StatelessWidget {
  final NotificationType type;

  const NotificationTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: type.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(type.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            type.toString().split('.').last,
            style: TextStyle(
              fontSize: 10,
              color: type.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// lib/App/Modules/Notifications/widgets/notification_content.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Models/Notifications/notification_model.dart';

class NotificationContent extends StatelessWidget {
  final NotificationModel notification;

  const NotificationContent({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow(),
        const SizedBox(height: 4),
        _buildMessage(),
        const SizedBox(height: 6),
        _buildTime(),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            notification.title,
            style: TextStyle(
              fontWeight:
                  notification.isRead ? FontWeight.w500 : FontWeight.bold,
              fontSize: 14,
              color: const Color(0xFF2D2D2D),
            ),
          ),
        ),
        if (!notification.isRead)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildMessage() {
    return Text(
      notification.message,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTime() {
    return Text(
      notification.time,
      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
    );
  }
}

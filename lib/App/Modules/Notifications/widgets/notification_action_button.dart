// lib/App/Modules/Notifications/widgets/notification_action_button.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey.shade600),
    );
  }
}

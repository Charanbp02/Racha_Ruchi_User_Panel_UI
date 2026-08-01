// lib/App/Modules/Notifications/widgets/notification_list.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Notifications/controller/notification_controller.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_card.dart';

class NotificationList extends StatelessWidget {
  final NotificationController controller;

  const NotificationList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return NotificationCard(
          notification: notification,
          controller: controller,
        );
      },
    );
  }
}

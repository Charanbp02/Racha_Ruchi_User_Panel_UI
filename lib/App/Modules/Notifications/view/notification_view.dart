// lib/App/Modules/Notifications/view/notification_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Notifications/controller/notification_controller.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_app_bar.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_loading.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/empty_notification.dart';
import 'package:racharuchi/App/Modules/Notifications/widgets/notification_list.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<NotificationController>()) {
      Get.put(NotificationController());
    }

    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const NotificationAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const NotificationLoading();
        }

        if (controller.notifications.isEmpty) {
          return const EmptyNotification();
        }

        return NotificationList(controller: controller);
      }),
    );
  }
}

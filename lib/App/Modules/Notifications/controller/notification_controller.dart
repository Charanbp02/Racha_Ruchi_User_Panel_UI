import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      notifications.value = [
        NotificationModel(
          id: '1',
          title: 'Order Confirmed! 🎉',
          message:
              'Your order #12345 has been confirmed and will be delivered soon.',
          time: '2 minutes ago',
          type: NotificationType.order,
          isRead: false,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/190/190411.png',
        ),
        NotificationModel(
          id: '2',
          title: 'New Recipe Alert!',
          message: 'Check out our new recipe: Hyderabadi Dum Biryani 🍗',
          time: '1 hour ago',
          type: NotificationType.recipe,
          isRead: false,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
        ),
        NotificationModel(
          id: '3',
          title: 'Special Discount!',
          message: 'Get 30% off on your next order. Use code: RACHA30',
          time: '3 hours ago',
          type: NotificationType.promo,
          isRead: false,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/2331/2331970.png',
        ),
        NotificationModel(
          id: '4',
          title: 'Order Delivered',
          message: 'Your order #12340 has been delivered. Enjoy your meal!',
          time: '1 day ago',
          type: NotificationType.order,
          isRead: true,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/190/190411.png',
        ),
        NotificationModel(
          id: '5',
          title: 'Recipe Liked!',
          message: 'Your recipe "Paneer Butter Masala" got 50 new likes ❤️',
          time: '2 days ago',
          type: NotificationType.like,
          isRead: true,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/1077/1077035.png',
        ),
        NotificationModel(
          id: '6',
          title: 'New Follower',
          message: 'Chef Sanjeev started following you',
          time: '3 days ago',
          type: NotificationType.follow,
          isRead: true,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
        ),
        NotificationModel(
          id: '7',
          title: 'Payment Successful',
          message: 'Your payment of ₹499 has been successfully processed.',
          time: '5 days ago',
          type: NotificationType.payment,
          isRead: true,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/190/190411.png',
        ),
        NotificationModel(
          id: '8',
          title: 'New Comment',
          message: 'User123 commented on your recipe: "Looks delicious!"',
          time: '1 week ago',
          type: NotificationType.comment,
          isRead: true,
          imageUrl: 'https://cdn-icons-png.flaticon.com/512/1380/1380338.png',
        ),
      ];

      updateUnreadCount();
      isLoading.value = false;
    });
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh();
      updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    updateUnreadCount();

    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    updateUnreadCount();

    Get.snackbar(
      'Deleted',
      'Notification removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All'),
        content: const Text(
          'Are you sure you want to clear all notifications?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              notifications.clear();
              unreadCount.value = 0;
              Get.back();
              Get.snackbar(
                'Cleared',
                'All notifications cleared',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void onNotificationTap(NotificationModel notification) {
    markAsRead(notification.id);

    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.order:
        Get.toNamed('/order-details', arguments: notification.id);
        break;
      case NotificationType.recipe:
        Get.toNamed('/recipe-details', arguments: notification.id);
        break;
      case NotificationType.promo:
        Get.toNamed('/offers');
        break;
      case NotificationType.like:
      case NotificationType.comment:
      case NotificationType.follow:
        Get.toNamed('/activity');
        break;
      case NotificationType.payment:
        Get.toNamed('/payment-history');
        break;
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;
  final String imageUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
    required this.imageUrl,
  });
}

enum NotificationType { order, recipe, promo, like, comment, follow, payment }

extension NotificationTypeExtension on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.order:
        return '📦';
      case NotificationType.recipe:
        return '🍳';
      case NotificationType.promo:
        return '🏷️';
      case NotificationType.like:
        return '❤️';
      case NotificationType.comment:
        return '💬';
      case NotificationType.follow:
        return '👤';
      case NotificationType.payment:
        return '💰';
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.order:
        return Color(0xFF4CAF50);
      case NotificationType.recipe:
        return Color(0xFFFF9800);
      case NotificationType.promo:
        return Color(0xFFE53935);
      case NotificationType.like:
        return Color(0xFFE91E63);
      case NotificationType.comment:
        return Color(0xFF2196F3);
      case NotificationType.follow:
        return Color(0xFF9C27B0);
      case NotificationType.payment:
        return Color(0xFF00BCD4);
    }
  }
}

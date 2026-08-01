// lib/App/Models/Notification_Model/notification_model.dart
import 'package:flutter/material.dart';

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
        return const Color(0xFF4CAF50);
      case NotificationType.recipe:
        return const Color(0xFFFF9800);
      case NotificationType.promo:
        return const Color(0xFFE53935);
      case NotificationType.like:
        return const Color(0xFFE91E63);
      case NotificationType.comment:
        return const Color(0xFF2196F3);
      case NotificationType.follow:
        return const Color(0xFF9C27B0);
      case NotificationType.payment:
        return const Color(0xFF00BCD4);
    }
  }
}

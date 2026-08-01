// lib/App/Modules/Notifications/widgets/notification_loading.dart
import 'package:flutter/material.dart';

class NotificationLoading extends StatelessWidget {
  const NotificationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFE53935)),
    );
  }
}

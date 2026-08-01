// lib/App/Custom/app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:racharuchi/App/Custom/widgets/app_bar_actions.dart';
import 'package:racharuchi/App/Custom/widgets/app_bar_logo.dart';
import 'package:racharuchi/App/Custom/widgets/app_bar_title.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int notificationCount;
  final int cartItemCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.notificationCount = 0,
    this.cartItemCount = 0,
    this.onNotificationTap,
    this.onCartTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).padding;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: screenPadding.top + 12,
          left: 20,
          right: 20,
          bottom: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0,
              offset: Offset(0, 0.5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo + Title Section
            Flexible(
              child: Row(
                children: [
                  const AppBarLogo(),
                  const SizedBox(width: 12),
                  AppBarTitle(title: title),
                ],
              ),
            ),

            // Action Buttons Section
            AppBarActions(
              notificationCount: notificationCount,
              cartItemCount: cartItemCount,
              onNotificationTap: onNotificationTap,
              onCartTap: onCartTap,
            ),
          ],
        ),
      ),
    );
  }
}

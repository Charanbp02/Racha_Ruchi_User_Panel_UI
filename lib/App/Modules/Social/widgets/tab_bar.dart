import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Social/controller/social_controller.dart';

class SocialTabBar extends StatelessWidget {
  final SocialController controller;

  const SocialTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabItem(controller, 'Followers', 0),
          _buildTabItem(controller, 'Following', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(SocialController controller, String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                controller.selectedTab.value == index
                    ? const Color(0xFFE53935)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:
                    controller.selectedTab.value == index
                        ? Colors.white
                        : Colors.grey.shade600,
                fontWeight:
                    controller.selectedTab.value == index
                        ? FontWeight.w600
                        : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

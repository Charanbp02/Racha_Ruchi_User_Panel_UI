// lib/App/Modules/Categories/view/category_section_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';
import 'package:racharuchi/App/Modules/Categories/widgets/category_loading_shimmer.dart';
import 'package:racharuchi/App/Modules/Categories/widgets/category_list.dart';

class CategorySectionView extends StatelessWidget {
  const CategorySectionView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<CategoryController>()) {
      Get.put(CategoryController());
    }

    return Obx(() {
      final controller = Get.find<CategoryController>();

      if (controller.isLoading.value) {
        return const CategoryLoadingShimmer();
      }

      // ✅ FIX: Check homePageCategories instead of categories
      final homeCategories = controller.homePageCategories;

      if (homeCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional: Show last updated time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ),
          const SizedBox(height: 8),
          const CategoryList(),
        ],
      );
    });
  }

  // ✅ Format time helper
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

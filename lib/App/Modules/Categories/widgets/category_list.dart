// lib/App/Modules/Categories/widgets/category_list.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';
import 'package:racharuchi/App/Modules/Categories/widgets/category_chip.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Obx(() {
      final categories = controller.homePageCategories;

      if (controller.isLoading.value && categories.isEmpty) {
        return SizedBox(
          height: 44,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        );
      }

      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          // ✅ YouTube-style padding - minimal horizontal padding
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = controller.selectedIndex.value == index;

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: CategoryChip(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  // ✅ Haptic feedback on tap
                  HapticFeedback.lightImpact();
                  controller.selectCategory(index);

                  // ✅ Scroll to selected category (optional)
                  _scrollToSelected(context, index);
                },
              ),
            );
          },
        ),
      );
    });
  }

  void _scrollToSelected(BuildContext context, int index) {
    // Optional: Auto-scroll to selected category
    // This requires a ScrollController
    // You can implement this if needed
  }
}

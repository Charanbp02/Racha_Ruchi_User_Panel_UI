// lib/App/Modules/Categories/widgets/category_section_header.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';

class CategorySectionHeader extends StatelessWidget {
  final String title;
  final bool showViewToggle;

  const CategorySectionHeader({
    super.key,
    this.title = 'Categories',
    this.showViewToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (showViewToggle)
            Row(
              children: [
                IconButton(
                  onPressed: controller.toggleViewMode,
                  icon: Obx(
                    () => Icon(
                      controller.isGridView.value
                          ? Icons.grid_view
                          : Icons.list,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

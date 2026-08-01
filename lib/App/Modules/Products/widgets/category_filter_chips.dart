// lib/App/Modules/Products/widgets/category_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class CategoryFilterChips extends StatelessWidget {
  final ProductsController controller;

  const CategoryFilterChips({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory.value == category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => controller.changeCategory(category),
              backgroundColor: Colors.white,
              selectedColor: Colors.red.shade50,
              side: BorderSide(
                color: isSelected ? Colors.red : Colors.grey.shade300,
              ),
            ),
          );
        },
      ),
    );
  }
}

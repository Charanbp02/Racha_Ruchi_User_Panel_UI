import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';

class RecipesCountWidget extends StatelessWidget {
  final MyRecipesController controller;

  const RecipesCountWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${controller.filteredRecipes.length} recipe videos',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          if (controller.selectedFilter.value != 'All')
            GestureDetector(
              onTap: () => controller.setFilter('All'),
              child: Text(
                'Clear Filter',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

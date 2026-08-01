import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';

class EmptyStateWidget extends StatelessWidget {
  final MyRecipesController controller;

  const EmptyStateWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.video,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Recipe Videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Try searching with different keywords'
                : 'You haven\'t uploaded any recipe videos yet',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          if (controller.searchQuery.value.isEmpty)
            ElevatedButton(
              onPressed: () => controller.addNewRecipe(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text('Upload Your First Recipe'),
            ),
        ],
      ),
    );
  }
}

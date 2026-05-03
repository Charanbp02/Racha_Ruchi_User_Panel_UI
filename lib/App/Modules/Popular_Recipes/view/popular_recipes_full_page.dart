import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Popular_Recipes/popular_recipes.dart';
import 'package:racharuchi/App/Modules/Popular_Recipes/controller/popular_recipes_controller.dart';


class PopularRecipesFullPage extends StatelessWidget {
  const PopularRecipesFullPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PopularRecipesController controller = Get.put(
      PopularRecipesController(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Popular Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF2D2D2D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh, color: Color(0xFFE53935)),
            onPressed: () => controller.refreshRecipes(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              _buildSearchBar(controller),
              const SizedBox(height: 8),
              // Category Filters
              _buildCategoryFilters(controller),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (controller.filteredRecipes.isEmpty) {
          return _buildEmptyState(controller);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = controller.filteredRecipes[index];
            return _buildRecipeCard(recipe, controller);
          },
        );
      }),
    );
  }

  Widget _buildSearchBar(PopularRecipesController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) => controller.searchRecipes(value),
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(
            Iconsax.search_normal,
            size: 20,
            color: Colors.grey,
          ),
          
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(PopularRecipesController controller) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory.value == category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => controller.setCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE53935) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecipeCard(
    PopularRecipeModel recipe,
    PopularRecipesController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.onRecipeTap(recipe),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          height: 140,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          height: 140,
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.error, color: Colors.grey),
                        ),
                  ),
                ),
                // Category Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          recipe.category == 'Non-Veg'
                              ? Colors.red.withOpacity(0.9)
                              : recipe.category == 'Veg'
                              ? Colors.green.withOpacity(0.9)
                              : Colors.orange.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recipe.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        recipe.duration,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.fireplace, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        recipe.calories,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        recipe.rating,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(PopularRecipesController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.document_text,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Recipes Found',
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
                : 'No recipes available in this category',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          if (controller.searchQuery.value.isNotEmpty)
            ElevatedButton(
              onPressed: () => controller.clearSearch(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear Search'),
            ),
        ],
      ),
    );
  }
}

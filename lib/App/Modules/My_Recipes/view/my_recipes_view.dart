import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/My_Recipe_Model/recipe_model.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';

class MyRecipesView extends StatelessWidget {
  const MyRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    final MyRecipesController controller = Get.put(MyRecipesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Recipes',
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
            icon: const Icon(Iconsax.add, color: Color(0xFFE53935)),
            onPressed: () => controller.addNewRecipe(),
          ),
        ],
      ),
      body: Obx(() {
        // Check authentication
        if (!controller.isAuthenticated.value) {
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
                    Iconsax.lock,
                    size: 60,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please login to view your recipe videos',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
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
                  child: const Text('Login Now'),
                ),
              ],
            ),
          );
        }

        // Show loading state
        if (controller.isLoading.value && controller.myRecipes.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        return Column(
          children: [
            // Search Bar
            _buildSearchBar(controller),
            const SizedBox(height: 12),

            // Filter Chips
            _buildFilterChips(controller),
            const SizedBox(height: 12),

            // Recipes Count
            _buildRecipesCount(controller),

            // Recipes List
            Expanded(
              child:
                  controller.filteredRecipes.isEmpty
                      ? _buildEmptyState(controller)
                      : RefreshIndicator(
                        onRefresh: () => controller.refreshData(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = controller.filteredRecipes[index];
                            return _buildRecipeCard(recipe, controller);
                          },
                        ),
                      ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchBar(MyRecipesController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) => controller.searchRecipes(value),
        decoration: InputDecoration(
          hintText: 'Search your recipe videos...',
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
            borderSide: const BorderSide(color: Color(0xFFE53935)),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(MyRecipesController controller) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.filterOptions.length,
        itemBuilder: (context, index) {
          final filter = controller.filterOptions[index];
          final isSelected = controller.selectedFilter.value == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => controller.setFilter(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE53935) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: const Color(0xFFE53935).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Text(
                  filter,
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

  Widget _buildRecipesCount(MyRecipesController controller) {
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

  Widget _buildEmptyState(MyRecipesController controller) {
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

  Widget _buildRecipeCard(RecipeModel recipe, MyRecipesController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Recipe Video Thumbnail
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: 180,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        height: 180,
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Iconsax.video,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
              // Video Icon Overlay
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.play5,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(recipe.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recipe.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Edit/Delete Buttons
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Iconsax.edit,
                          size: 18,
                          color: Color(0xFFE53935),
                        ),
                        onPressed: () => controller.editRecipe(recipe),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Iconsax.trash,
                          size: 18,
                          color: Colors.red,
                        ),
                        onPressed: () => controller.deleteRecipe(recipe.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Recipe Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                GestureDetector(
                  onTap: () => controller.viewRecipe(recipe),
                  child: Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  recipe.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Recipe Meta
                Row(
                  children: [
                    _buildMetaItem(Iconsax.clock, recipe.cookingTime),
                    const SizedBox(width: 16),
                    _buildMetaItem(Iconsax.profile_2user, recipe.servings),
                    const SizedBox(width: 16),
                    _buildMetaItem(Iconsax.chart, recipe.difficulty),
                  ],
                ),
                const SizedBox(height: 10),

                // Stats Row
                Row(
                  children: [
                    _buildStatItem(Iconsax.heart, recipe.likes, Colors.red),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      Iconsax.message,
                      recipe.comments,
                      Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      Iconsax.eye,
                      recipe.viewsCount.toString(),
                      Colors.green,
                    ),
                    const Spacer(),
                    Text(
                      recipe.createdAt,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Published':
        return Colors.green;
      case 'Draft':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

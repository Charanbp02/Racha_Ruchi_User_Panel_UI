import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Popular_Recipes/popular_recipes.dart';
import 'package:racharuchi/App/Modules/Popular_Recipes/controller/popular_recipes_controller.dart';
import 'package:racharuchi/App/Modules/Popular_Recipes/view/popular_recipes_full_page.dart';


class PopularRecipesSection extends StatelessWidget {
  const PopularRecipesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PopularRecipesController controller = Get.put(
      PopularRecipesController(),
    );

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Heading + View All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Recipes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () =>   Get.to(() => const PopularRecipesFullPage()),
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Loading State
          if (controller.isLoading.value)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFE53935)),
              ),
            )
          /// Error State
          else if (controller.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => controller.refreshRecipes(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          /// Empty State
          else if (controller.recipes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text('No recipes available')),
            )
          /// ⭐ Horizontal List
          else
            SizedBox(
              height: 210,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = controller.recipes[index];
                  return _buildRecipeCard(recipe, controller);
                },
              ),
            ),
        ],
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
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image with category badge
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(recipe.imageUrl),
                      fit: BoxFit.cover,
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
                              : Colors.green.withOpacity(0.9),
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

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Duration, Calories & Rating
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
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.fireplace, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(
                        recipe.calories,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 2),
                      Text(
                        recipe.rating,
                        style: const TextStyle(
                          fontSize: 11,
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
}

// Full Page for View All
class PopularRecipesPage extends StatelessWidget {
  const PopularRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PopularRecipesController controller = Get.put(
      PopularRecipesController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Recipes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.refreshRecipes(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (controller.recipes.isEmpty) {
          return const Center(child: Text('No recipes found'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.recipes.length,
          itemBuilder: (context, index) {
            final recipe = controller.recipes[index];
            return _buildFullRecipeCard(recipe, controller);
          },
        );
      }),
    );
  }

  Widget _buildFullRecipeCard(
    PopularRecipeModel recipe,
    PopularRecipesController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.onRecipeTap(recipe),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      recipe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                                : Colors.green.withOpacity(0.9),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 2),
                      Text(recipe.rating, style: const TextStyle(fontSize: 10)),
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
}

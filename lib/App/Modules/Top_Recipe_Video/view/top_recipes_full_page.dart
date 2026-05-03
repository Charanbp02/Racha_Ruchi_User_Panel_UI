import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Top_Recipe_Video/top_recipe_video.dart';
import 'package:racharuchi/App/Modules/Top_Recipe_Video/controller/top_recipes_controller.dart';

class TopRecipeVideosFullPage extends StatelessWidget {
  const TopRecipeVideosFullPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TopRecipesController controller = Get.find<TopRecipesController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Top Recipe Videos',
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (controller.recipes.isEmpty) {
          return _buildEmptyState();
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
            return _buildRecipeCard(recipe, controller);
          },
        );
      }),
    );
  }

  Widget _buildRecipeCard(RecipeModel recipe, TopRecipesController controller) {
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
            // Thumbnail
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
                // Play Button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                // Views Badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          recipe.views,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ],
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
                  const SizedBox(height: 4),
                  Text(
                    recipe.chef,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 10,
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
                      const Icon(Icons.star, size: 10, color: Colors.amber),
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

  Widget _buildEmptyState() {
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
              Iconsax.video_play,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Videos Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later for new videos',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

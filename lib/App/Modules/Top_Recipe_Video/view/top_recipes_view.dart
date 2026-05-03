import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Top_Recipe_Video/top_recipe_video.dart';
import 'package:racharuchi/App/Modules/Top_Recipe_Video/controller/top_recipes_controller.dart';
import 'package:racharuchi/App/Modules/Top_Recipe_Video/view/top_recipes_full_page.dart';

class TopRecipeVideosSection extends StatelessWidget {
  const TopRecipeVideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TopRecipesController controller = Get.put(TopRecipesController());

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top Recipe Videos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const TopRecipeVideosFullPage());
                  },
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

          if (controller.isLoading.value)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFE53935)),
              ),
            )
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
          else if (controller.recipes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text('No recipes available')),
            )
          else
            SizedBox(
              height: 180,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = controller.recipes[index];
                  return _buildVideoCard(recipe, controller);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(RecipeModel recipe, TopRecipesController controller) {
    return GestureDetector(
      onTap: () => controller.onRecipeTap(recipe),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(recipe.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                        size: 24,
                      ),
                    ),
                  ),
                ),
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
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              recipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.access_time, size: 10, color: Colors.grey),
                const SizedBox(width: 2),
                Text(
                  recipe.duration,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.star, size: 10, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  recipe.rating,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

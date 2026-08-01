import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';
import 'package:racharuchi/App/Modules/My_Recipes/widgets/empty_state.dart';
import 'package:racharuchi/App/Modules/My_Recipes/widgets/filter_chips.dart';
import 'package:racharuchi/App/Modules/My_Recipes/widgets/recipe_card.dart';
import 'package:racharuchi/App/Modules/My_Recipes/widgets/recipes_count.dart';
import 'package:racharuchi/App/Modules/My_Recipes/widgets/search_bar.dart';
import 'package:racharuchi/App/Modules/My_Recipes/widgets/uploading_card.dart';

class MyRecipesView extends StatelessWidget {
  const MyRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    final MyRecipesController controller = Get.put(MyRecipesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Obx(() {
            if (!controller.isAuthenticated.value) {
              return _buildLoginRequired();
            }

            if (controller.isLoading.value && controller.myRecipes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE53935)),
              );
            }

            return Column(
              children: [
                SearchBarWidget(controller: controller),
                const SizedBox(height: 12),
                FilterChipsWidget(controller: controller),
                const SizedBox(height: 12),
                RecipesCountWidget(controller: controller),
                Expanded(
                  child:
                      controller.filteredRecipes.isEmpty
                          ? EmptyStateWidget(controller: controller)
                          : RefreshIndicator(
                            onRefresh: () => controller.refreshData(),
                            child: _buildRecipeList(controller),
                          ),
                ),
              ],
            );
          }),
          _buildUploadProgressIndicator(controller),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D2D2D)),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildLoginRequired() {
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
              Icons.lock_outline,
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Login Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(MyRecipesController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount:
          controller.filteredRecipes.length + (controller.isUploading ? 1 : 0),
      itemBuilder: (context, index) {
        if (controller.isUploading && index == 0) {
          return UploadingCardWidget(controller: controller);
        }

        final recipe =
            controller.filteredRecipes[controller.isUploading
                ? index - 1
                : index];
        return RecipeCardWidget(recipe: recipe, controller: controller);
      },
    );
  }

  Widget _buildUploadProgressIndicator(MyRecipesController controller) {
    return Obx(() {
      if (!controller.uploadController.isUploading.value) {
        return const SizedBox();
      }

      return Positioned(
        bottom: 20,
        left: 16,
        right: 16,
        child: GestureDetector(
          onTap: () {
            controller.uploadController.restoreUpload();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.cloud_upload, color: Color(0xFFE53935)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Uploading Recipe...",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "${(controller.uploadController.uploadProgress.value * 100).toInt()}%",
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: controller.uploadController.uploadProgress.value,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

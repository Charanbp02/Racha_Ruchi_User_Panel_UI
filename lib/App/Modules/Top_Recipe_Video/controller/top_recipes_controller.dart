import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Top_Recipe_Video/top_recipe_video.dart';
import 'package:racharuchi/App/Modules/Top_Recipe_Video/view/top_recipes_full_page.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/binding/video_player_binding.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/video_player_view.dart';

class TopRecipesController extends GetxController {
  var recipes = <RecipeModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  void fetchRecipes() {
    isLoading.value = true;
    errorMessage.value = '';

    Future.delayed(const Duration(milliseconds: 500), () {
      recipes.value = [
        RecipeModel(
          id: '1',
          title: 'Chicken Biryani Recipe',
          duration: '10 min',
          imageUrl:
              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
          videoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // ✅ Working video
          views: '1.2M',
          rating: '4.8',
          chef: 'Chef Ramesh',
          description:
              'Learn how to make perfect Hyderabadi Dum Biryani at home',
        ),
        RecipeModel(
          id: '2',
          title: 'Paneer Butter Masala',
          duration: '15 min',
          imageUrl:
              'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8',
          videoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // ✅ Working video
          views: '890K',
          rating: '4.7',
          chef: 'Chef Priya',
          description: 'Restaurant style creamy paneer butter masala',
        ),
        RecipeModel(
          id: '3',
          title: 'Masala Dosa Recipe',
          duration: '8 min',
          imageUrl:
              'https://images.unsplash.com/photo-1589301760014-3b6c3c3f5f5c',
          videoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // ✅ Working video
          views: '2.1M',
          rating: '4.9',
          chef: 'Chef Kumar',
          description: 'Crispy dosa with potato masala filling',
        ),
        RecipeModel(
          id: '4',
          title: 'Butter Chicken Recipe',
          duration: '20 min',
          imageUrl:
              'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398',
          videoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // ✅ Working video
          views: '1.5M',
          rating: '4.8',
          chef: 'Chef Sanjeev',
          description: 'Famous Punjabi butter chicken recipe',
        ),
      ];
      isLoading.value = false;
    });
  }

  void refreshRecipes() {
    fetchRecipes();
  }

  void onRecipeTap(RecipeModel recipe) {
    Get.to(
      () => const VideoPlayerView(),
      arguments: {
        'videoUrl': recipe.videoUrl ?? '',
        'title': recipe.title,
        'channelName': recipe.chef,
        'channelImage': 'https://randomuser.me/api/portraits/men/1.jpg',
        'videoId': recipe.id,
      },
      binding: VideoPlayerBinding(), // ✅ Add this line
    );
  }

  void onViewAllTap() {
    Get.to(() => const TopRecipeVideosFullPage());
  }
}

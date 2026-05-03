import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Popular_Recipes/popular_recipes.dart';
import 'package:racharuchi/App/Modules/Popular_Recipes/view/popular_recipes_full_page.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/binding/video_player_binding.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/video_player_view.dart';

class PopularRecipesController extends GetxController {
  var recipes = <PopularRecipeModel>[].obs;
  var filteredRecipes = <PopularRecipeModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;

  final List<String> categories = ['All', 'Veg', 'Non-Veg', 'Dessert'];

  @override
  void onInit() {
    super.onInit();
    fetchPopularRecipes();
  }

  void fetchPopularRecipes() {
    isLoading.value = true;
    errorMessage.value = '';

    Future.delayed(const Duration(milliseconds: 500), () {
      recipes.value = [
        PopularRecipeModel(
          id: '1',
          title: 'Chicken Biryani',
          duration: '30 min',
          rating: '4.5',
          imageUrl:
              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
          calories: '450',
          category: 'Non-Veg',
        ),
        PopularRecipeModel(
          id: '2',
          title: 'Paneer Butter Masala',
          duration: '25 min',
          rating: '4.7',
          imageUrl:
              'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8',
          calories: '380',
          category: 'Veg',
        ),
        PopularRecipeModel(
          id: '3',
          title: 'Masala Dosa',
          duration: '15 min',
          rating: '4.8',
          imageUrl:
              'https://images.unsplash.com/photo-1589301760014-3b6c3c3f5f5c',
          calories: '250',
          category: 'Veg',
        ),
        PopularRecipeModel(
          id: '4',
          title: 'Butter Chicken',
          duration: '35 min',
          rating: '4.6',
          imageUrl:
              'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398',
          calories: '520',
          category: 'Non-Veg',
        ),
        PopularRecipeModel(
          id: '5',
          title: 'Gulab Jamun',
          duration: '20 min',
          rating: '4.4',
          imageUrl:
              'https://images.unsplash.com/photo-1589301760014-3b6c3c3f5f5c',
          calories: '320',
          category: 'Dessert',
        ),
        PopularRecipeModel(
          id: '6',
          title: 'Chicken Tikka',
          duration: '28 min',
          rating: '4.7',
          imageUrl:
              'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0',
          calories: '480',
          category: 'Non-Veg',
        ),
        PopularRecipeModel(
          id: '7',
          title: 'Veg Biryani',
          duration: '30 min',
          rating: '4.5',
          imageUrl:
              'https://images.unsplash.com/photo-1563379091339-03b21bb4e6d8',
          calories: '350',
          category: 'Veg',
        ),
      ];
      applyFilters();
      isLoading.value = false;
    });
  }

  void applyFilters() {
    var filtered = recipes.toList();

    // Apply category filter
    if (selectedCategory.value != 'All') {
      filtered =
          filtered
              .where((recipe) => recipe.category == selectedCategory.value)
              .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (recipe) => recipe.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList();
    }

    filteredRecipes.value = filtered;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void searchRecipes(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';
    applyFilters();
  }

  void refreshRecipes() {
    fetchPopularRecipes();
  }

 void onRecipeTap(PopularRecipeModel recipe) {
    Get.to(
      () => const VideoPlayerView(),
      arguments: {
        'videoUrl': recipe.videoUrl ?? recipe.imageUrl, // Use actual video URL
        'title': recipe.title,
      },
      binding: VideoPlayerBinding(),
    );
  }

  void onViewAllTap() {
    Get.to(() => const PopularRecipesFullPage());
  }
}

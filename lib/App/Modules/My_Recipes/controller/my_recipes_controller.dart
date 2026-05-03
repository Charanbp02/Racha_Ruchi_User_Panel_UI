import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/My_Recipe_Model/recipe_model.dart';

class MyRecipesController extends GetxController {
  var myRecipes = <RecipeModel>[].obs;
  var filteredRecipes = <RecipeModel>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;

  final List<String> filterOptions = ['All', 'Published', 'Draft', 'Private'];

  @override
  void onInit() {
    super.onInit();
    loadMyRecipes();
  }

  void loadMyRecipes() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      myRecipes.value = [
        RecipeModel(
          id: '1',
          title: 'Chicken Biryani',
          description: 'Hyderabadi Dum Biryani with aromatic spices',
          imageUrl:
              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
          cookingTime: '45 min',
          servings: '4-6',
          difficulty: 'Medium',
          likes: '1,234',
          comments: '89',
          status: 'Published',
          createdAt: '2024-03-15',
          cuisine: 'Indian',
          category: 'Non-Veg',
        ),
        RecipeModel(
          id: '2',
          title: 'Paneer Butter Masala',
          description: 'Creamy restaurant style paneer curry',
          imageUrl:
              'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8',
          cookingTime: '30 min',
          servings: '4',
          difficulty: 'Easy',
          likes: '2,345',
          comments: '156',
          status: 'Published',
          createdAt: '2024-03-10',
          cuisine: 'North Indian',
          category: 'Veg',
        ),
        RecipeModel(
          id: '3',
          title: 'Masala Dosa',
          description: 'Crispy dosa with potato masala filling',
          imageUrl:
              'https://images.unsplash.com/photo-1589301760014-3b6c3c3f5f5c',
          cookingTime: '20 min',
          servings: '2-3',
          difficulty: 'Medium',
          likes: '3,456',
          comments: '234',
          status: 'Published',
          createdAt: '2024-03-05',
          cuisine: 'South Indian',
          category: 'Veg',
        ),
        RecipeModel(
          id: '4',
          title: 'Butter Chicken',
          description: 'Famous Punjabi butter chicken recipe',
          imageUrl:
              'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398',
          cookingTime: '50 min',
          servings: '4-5',
          difficulty: 'Hard',
          likes: '4,567',
          comments: '345',
          status: 'Published',
          createdAt: '2024-02-28',
          cuisine: 'North Indian',
          category: 'Non-Veg',
        ),
        RecipeModel(
          id: '5',
          title: 'Garlic Naan',
          description: 'Soft and fluffy garlic naan bread',
          imageUrl:
              'https://images.unsplash.com/photo-1604135307499-6a4f9e2b11a0',
          cookingTime: '15 min',
          servings: '4',
          difficulty: 'Easy',
          likes: '567',
          comments: '45',
          status: 'Draft',
          createdAt: '2024-03-12',
          cuisine: 'Indian',
          category: 'Veg',
        ),
        RecipeModel(
          id: '6',
          title: 'Gulab Jamun',
          description: 'Soft and juicy Indian dessert',
          imageUrl:
              'https://images.unsplash.com/photo-1589301760014-3b6c3c3f5f5c',
          cookingTime: '25 min',
          servings: '6',
          difficulty: 'Medium',
          likes: '6,789',
          comments: '567',
          status: 'Published',
          createdAt: '2024-02-20',
          cuisine: 'Indian',
          category: 'Dessert',
        ),
      ];
      applyFilters();
      isLoading.value = false;
    });
  }

  void applyFilters() {
    var filtered = myRecipes.toList();

    // Apply status filter
    if (selectedFilter.value != 'All') {
      filtered =
          filtered
              .where((recipe) => recipe.status == selectedFilter.value)
              .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (recipe) =>
                    recipe.title.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    recipe.description.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ),
              )
              .toList();
    }

    filteredRecipes.value = filtered;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
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

  void deleteRecipe(String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              myRecipes.removeWhere((recipe) => recipe.id == id);
              applyFilters();
              Get.back();
              Get.snackbar(
                'Deleted',
                'Recipe deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void editRecipe(RecipeModel recipe) {
    Get.toNamed('/edit-recipe', arguments: recipe);
  }

  void viewRecipe(RecipeModel recipe) {
    Get.toNamed('/recipe-detail', arguments: recipe);
  }

  void addNewRecipe() {
    Get.toNamed('/add-recipe');
  }
}


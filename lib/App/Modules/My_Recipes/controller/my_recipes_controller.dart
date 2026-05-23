import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racharuchi/App/Models/My_Recipe_Model/recipe_model.dart';

class MyRecipesController extends GetxController {
  var myRecipes = <RecipeModel>[].obs;
  var filteredRecipes = <RecipeModel>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;
  var isAuthenticated = false.obs;

  final List<String> filterOptions = ['All', 'Published', 'Draft'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _recipesSubscription;
  StreamSubscription<User?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupAuthListener();
  }

  @override
  void onClose() {
    _recipesSubscription?.cancel();
    _authSubscription?.cancel();
    super.onClose();
  }

  void _setupAuthListener() {
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        isAuthenticated.value = true;
        loadMyRecipes();
      } else {
        isAuthenticated.value = false;
        myRecipes.clear();
        filteredRecipes.clear();
        isLoading.value = false;
      }
    });
  }

  void loadMyRecipes() {
    final user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      myRecipes.clear();
      filteredRecipes.clear();
      return;
    }

    isLoading.value = true;

    try {
      // Cancel existing subscription
      _recipesSubscription?.cancel();

      // Real-time listener for user's recipe videos
      _recipesSubscription = _firestore
          .collection('recipe_videos')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              final List<RecipeModel> recipes = [];

              for (var doc in snapshot.docs) {
                final data = doc.data();
                try {
                  final recipe = RecipeModel(
                    id: doc.id,
                    title: data['title'] ?? 'Untitled Recipe',
                    description: data['description'] ?? '',
                    imageUrl: data['thumbnailUrl'] ?? data['imageUrl'] ?? '',
                    cookingTime: data['duration'] ?? '30 min',
                    servings: '4-6',
                    difficulty: 'Medium',
                    likes: (data['likes'] ?? 0).toString(),
                    comments: (data['comments'] ?? 0).toString(),
                    status: data['isActive'] == true ? 'Published' : 'Draft',
                    createdAt:
                        data['createdAt'] != null
                            ? (data['createdAt'] as Timestamp)
                                .toDate()
                                .toString()
                                .split(' ')[0]
                            : DateTime.now().toString().split(' ')[0],
                    cuisine: data['category'] ?? 'Indian',
                    category: data['category'] ?? 'Veg',
                    userId: data['userId'] ?? '',
                    videoUrl: data['videoUrl'] ?? '',
                    tags: List<String>.from(data['tags'] ?? []),
                    ingredients: List<Map<String, String>>.from(
                      data['ingredients'] ?? [],
                    ),
                    likesCount: data['likes'] ?? 0,
                    commentsCount: data['comments'] ?? 0,
                    viewsCount: data['views'] ?? 0,
                    updatedAt:
                        data['updatedAt'] != null
                            ? (data['updatedAt'] as Timestamp).toDate()
                            : DateTime.now(),
                    isActive: data['isActive'] ?? true,
                    isFavorite: data['isFavorite'] ?? false,
                  );
                  recipes.add(recipe);
                } catch (e) {
                  print('Error parsing recipe ${doc.id}: $e');
                }
              }

              myRecipes.value = recipes;
              applyFilters();
              isLoading.value = false;

              print('📱 Loaded ${recipes.length} videos for user ${user.uid}');
            },
            onError: (error) {
              print('Error loading recipes: $error');
              isLoading.value = false;
              _showErrorSnackbar('Failed to load recipes');
            },
          );
    } catch (e) {
      print('Error setting up listener: $e');
      isLoading.value = false;
      _showErrorSnackbar('Failed to load recipes');
    }
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
        content: const Text(
          'Are you sure you want to delete this recipe video?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              try {
                // Delete from Firestore
                await _firestore.collection('recipe_videos').doc(id).delete();

                Get.snackbar(
                  'Deleted',
                  'Recipe video deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete recipe video',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
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
    _incrementViewCount(recipe.id);
    Get.toNamed('/recipe-detail', arguments: recipe);
  }

  void addNewRecipe() {
    Get.toNamed('/add-recipe');
  }

  Future<void> _incrementViewCount(String id) async {
    try {
      await _firestore.collection('recipe_videos').doc(id).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }

  Future<void> refreshData() async {
    loadMyRecipes();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

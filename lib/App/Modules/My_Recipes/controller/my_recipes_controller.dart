import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racharuchi/App/Models/My_Recipe_Model/recipe_model.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:share_plus/share_plus.dart';

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

  late UploadController uploadController;

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<UploadController>()) {
      Get.put(UploadController(), permanent: true);
    }

    uploadController = Get.find<UploadController>();

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

              print(
                '📱 Found ${snapshot.docs.length} videos for user ${user.uid}',
              );

              for (var doc in snapshot.docs) {
                final data = doc.data();
                try {
                  // Debug: Print each document
                  print('Processing video: ${doc.id}');
                  print('Video data: $data');

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
                    status: _getStatusFromData(data),
                    createdAt: _formatDate(data['createdAt']),
                    cuisine:
                        data['category'] ?? data['categoryName'] ?? 'Indian',
                    category: data['category'] ?? data['categoryName'] ?? 'Veg',
                    userId: data['userId'] ?? '',
                    videoUrl: data['videoUrl'] ?? '',
                    tags: List<String>.from(data['tags'] ?? []),
                    ingredients: _parseIngredients(data['ingredients']),
                    likesCount: data['likes'] ?? 0,
                    commentsCount: data['comments'] ?? 0,
                    viewsCount: data['views'] ?? 0,
                    updatedAt: _parseTimestamp(data['updatedAt']),
                    isActive: data['isActive'] ?? true,
                  );
                  recipes.add(recipe);
                } catch (e) {
                  print('Error parsing recipe ${doc.id}: $e');
                  print('Data that caused error: ${doc.data()}');
                }
              }

              myRecipes.value = recipes;
              applyFilters();
              isLoading.value = false;

              print('✅ Loaded ${recipes.length} videos for user ${user.uid}');
            },
            onError: (error) {
              print('❌ Error loading recipes: $error');
              isLoading.value = false;
              _showErrorSnackbar('Failed to load recipes: $error');
            },
          );
    } catch (e) {
      print('❌ Error setting up listener: $e');
      isLoading.value = false;
      _showErrorSnackbar('Failed to load recipes');
    }
  }

  Future<void> uploadThumbnail(String recipeId, XFile imageFile) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFFE53935)),
              SizedBox(height: 16),
              Text(
                'Uploading thumbnail...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black54,
      );

      // Compress and upload image to Firebase Storage
      final File file = File(imageFile.path);

      // Create a unique filename
      final String fileName =
          '$recipeId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('recipe_thumbnails')
          .child(fileName);

      // Upload the file with metadata
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'recipeId': recipeId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      await storageRef.putFile(file, metadata);

      // Get the download URL
      final String downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore document with new thumbnail URL
      await _firestore.collection('recipe_videos').doc(recipeId).update({
        'thumbnailUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update the local recipe model
      final int index = myRecipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        myRecipes[index] = myRecipes[index].copyWith(
          imageUrl: downloadUrl,
          updatedAt: DateTime.now(),
        );
        applyFilters();
      }

      Get.back(); // Close loading dialog

      Get.snackbar(
        'Success',
        'Thumbnail uploaded successfully! ✅',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.back(); // Close loading dialog if open

      print('Error uploading thumbnail: $e');
      Get.snackbar(
        'Error',
        'Failed to upload thumbnail: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // lib/App/Modules/My_Recipes/controller/my_recipes_controller.dart

  Future<void> removeThumbnail(String recipeId) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFFE53935)),
              SizedBox(height: 16),
              Text(
                'Removing thumbnail...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black54,
      );

      // Get current recipe to find the thumbnail URL
      final DocumentSnapshot doc =
          await _firestore.collection('recipe_videos').doc(recipeId).get();

      // FIX: Properly access the thumbnailUrl field from the document data
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      final String? currentThumbnailUrl = data?['thumbnailUrl'] as String?;

      // If there's a thumbnail URL, try to delete it from storage
      if (currentThumbnailUrl != null && currentThumbnailUrl.isNotEmpty) {
        try {
          // Extract the path from the URL
          final Reference ref = FirebaseStorage.instance.refFromURL(
            currentThumbnailUrl,
          );
          await ref.delete();
          print('✅ Thumbnail deleted from storage');
        } catch (e) {
          // File might not exist or already deleted
          print('Error deleting thumbnail from storage: $e');
        }
      }

      // Update Firestore document with empty thumbnail
      await _firestore.collection('recipe_videos').doc(recipeId).update({
        'thumbnailUrl': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update the local recipe model
      final int index = myRecipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        myRecipes[index] = myRecipes[index].copyWith(
          imageUrl: '',
          updatedAt: DateTime.now(),
        );
        applyFilters();
      }

      Get.back(); // Close loading dialog

      Get.snackbar(
        'Success',
        'Thumbnail removed successfully! 🗑️',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.back(); // Close loading dialog if open

      print('Error removing thumbnail: $e');
      Get.snackbar(
        'Error',
        'Failed to remove thumbnail: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  String _getStatusFromData(Map<String, dynamic> data) {
    // Check if video is active/published
    if (data['isActive'] == true) {
      return 'Published';
    }
    return 'Draft';
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime.now().toString().split(' ')[0];
    }

    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate().toString().split(' ')[0];
      } else if (timestamp is DateTime) {
        return timestamp.toString().split(' ')[0];
      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    return DateTime.now().toString().split(' ')[0];
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime.now();
    }

    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is DateTime) {
        return timestamp;
      }
    } catch (e) {
      print('Error parsing timestamp: $e');
    }

    return DateTime.now();
  }

  List<Map<String, String>> _parseIngredients(dynamic ingredientsData) {
    if (ingredientsData == null) return [];

    try {
      if (ingredientsData is List) {
        return ingredientsData.map((ing) {
          if (ing is Map) {
            return {
              'name': ing['name']?.toString() ?? '',
              'quantity': ing['quantity']?.toString() ?? '',
            };
          }
          return {'name': '', 'quantity': ''};
        }).toList();
      }
    } catch (e) {
      print('Error parsing ingredients: $e');
    }

    return [];
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
    print('🔍 Filter applied: ${filtered.length} recipes shown');
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
                // First, get the video document to access videoUrl
                final doc =
                    await _firestore.collection('recipe_videos').doc(id).get();
                final videoUrl = doc.data()?['videoUrl'];

                // Delete from Firestore
                await _firestore.collection('recipe_videos').doc(id).delete();

                // Optional: Delete video from Storage if needed
                // if (videoUrl != null && videoUrl.isNotEmpty) {
                //   try {
                //     final storageRef = FirebaseStorage.instance.refFromURL(videoUrl);
                //     await storageRef.delete();
                //   } catch (e) {
                //     print('Error deleting video from storage: $e');
                //   }
                // }

                Get.snackbar(
                  'Deleted',
                  'Recipe video deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                print('Error deleting recipe: $e');
                Get.snackbar(
                  'Error',
                  'Failed to delete recipe video: $e',
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

  void addNewRecipe() {
    Get.toNamed('/upload-video', arguments: {'uploadType': 'recipe'});
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

  bool get isUploading {
    return uploadController.isUploading.value;
  }

  double get uploadProgress {
    return uploadController.uploadProgress.value;
  }

  bool get isUploadMinimized {
    return uploadController.isUploadMinimized.value;
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

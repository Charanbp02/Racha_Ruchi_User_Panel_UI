// lib/App/Modules/Categories/controller/category_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';

class CategoryController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedIndex = 0.obs; // ✅ "All" is selected by default
  var isGridView = false.obs;
  var searchQuery = ''.obs;
  var lastUpdated = DateTime.now().obs;

  // ✅ Add "All" category option
  final Map<String, dynamic> allCategory = {
    'id': 'all',
    'name': 'All',
    'icon': '📋',
    'isActive': true,
    'showOnHome': true,
  };

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _categorySubscription;

  // ✅ FILTERED CATEGORIES FOR SEARCH (includes "All")
  List<Map<String, dynamic>> get filteredCategories {
    List<Map<String, dynamic>> result = [];

    // Always include "All" category first
    result.add(allCategory);

    // Add active categories
    if (searchQuery.value.isEmpty) {
      result.addAll(categories);
    } else {
      final filtered =
          categories.where((category) {
            return category['name'].toString().toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
          }).toList();
      result.addAll(filtered);
    }

    return result;
  }

  // ✅ HOME PAGE CATEGORIES (includes "All" for home page)
  List<Map<String, dynamic>> get homePageCategories {
    List<Map<String, dynamic>> result = [];

    // Always include "All" category first
    result.add(allCategory);

    // Add categories that are active and show on home
    final homeCategories =
        categories.where((category) {
          return category['isActive'] == true && category['showOnHome'] == true;
        }).toList();

    result.addAll(homeCategories);
    return result;
  }

  @override
  void onClose() {
    _categorySubscription?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesRealtime();
  }

  // ✅ REAL-TIME FETCH CATEGORIES
  void fetchCategoriesRealtime() {
    isLoading.value = true;
    _categorySubscription?.cancel();

    _categorySubscription = _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            categories.value =
                snapshot.docs.map((doc) {
                  final data = doc.data();
                  return {
                    'id': doc.id,
                    'name': data['name'] ?? '',
                    'icon': data['icon'] ?? '🍽️',
                    'isActive': data['isActive'] ?? true,
                    'showOnHome': data['showOnHome'] ?? true,
                    'imageUrl': data['imageUrl'] ?? '',
                    'description': data['description'] ?? '',
                    'productCount': data['productCount'] ?? 0,
                    'createdAt': data['createdAt'],
                  };
                }).toList();

            lastUpdated.value = DateTime.now();
            isLoading.value = false;
          },
          onError: (error) {
            print('❌ Category stream error: $error');
            isLoading.value = false;
          },
        );
  }

  // ✅ MANUAL REFRESH
  Future<void> refreshCategories() async {
    fetchCategoriesRealtime();
  }

  // ✅ Select category and navigate
  void selectCategory(int index) {
    selectedIndex.value = index;
    final categoriesList = filteredCategories;

    if (index >= 0 && index < categoriesList.length) {
      final selected = categoriesList[index];
      print('Selected category: ${selected['name']}');

      // ✅ If "All" is selected, update VideosController to show all videos
      if (selected['id'] == 'all') {
        if (Get.isRegistered<VideosController>()) {
          final videosController = Get.find<VideosController>();
          videosController.updateCategory('All');
        }
        // No navigation - stay on home page
      } else {
        // ✅ Navigate to category videos view for specific categories
        Get.toNamed(
          '/category-videos',
          arguments: {
            'categoryId': selected['id'],
            'categoryName': selected['name'],
            'categoryIcon': selected['icon'] ?? '📁',
            'categoryImage': selected['imageUrl'] ?? '',
          },
        );
      }
    }
  }

  // ✅ Reset to "All" (called when returning from category page)
  void resetToAll() {
    selectedIndex.value = 0;
    if (Get.isRegistered<VideosController>()) {
      final videosController = Get.find<VideosController>();
      videosController.updateCategory('All');
    }
  }

  void toggleViewMode() {
    isGridView.toggle();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (query.isNotEmpty) {
      selectedIndex.value = -1;
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    selectedIndex.value = 0;
  }
}

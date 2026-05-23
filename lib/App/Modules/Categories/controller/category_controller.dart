import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final QuerySnapshot categorySnapshot =
          await _firestore
              .collection('categories')
              .where('isActive', isEqualTo: true)
              .orderBy('createdAt')
              .get();

      categories.value =
          categorySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'name': data['name'] ?? '',
              'icon': data['icon'] ?? '🍽️',
              'isActive': data['isActive'] ?? true,
              'imageUrl': data['imageUrl'],
            };
          }).toList();

      print('✅ Loaded ${categories.length} categories for user app');
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int index) {
    selectedIndex.value = index;
    final selected = categories[index];
    print('Selected: ${selected['name']}');

    // Navigate to category products page
    Get.toNamed(
      '/category-products',
      arguments: {
        'categoryId': selected['id'],
        'categoryName': selected['name'],
      },
    );
  }

  Future<void> refreshCategories() async {
    await fetchCategories();
  }
}

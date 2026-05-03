import 'package:get/get.dart';

class ProductsController extends GetxController {
  var selectedCategory = 'All'.obs;
  var isGridView = true.obs;

  final categories = ['All', 'Cookware', 'Kitchen', 'Appliances', 'Books'];

  // Make products reactive with .obs
  var products =
      <Map<String, dynamic>>[
        {
          'name': 'Non-Stick Kadhai',
          'price': '₹1,299',
          'image':
              'https://images.unsplash.com/photo-1584990347449-a9d037f4f96a?w=400',
          'rating': 4.5,
          'category': 'Cookware',
        },
        {
          'name': 'Masala Dabba',
          'price': '₹599',
          'image':
              'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',
          'rating': 4.8,
          'category': 'Kitchen',
        },
        {
          'name': 'Garlic Press',
          'price': '₹399',
          'image':
              'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',
          'rating': 4.3,
          'category': 'Kitchen',
        },
        {
          'name': 'Iron Tava',
          'price': '₹899',
          'image':
              'https://images.unsplash.com/photo-1584990347449-a9d037f4f96a?w=400',
          'rating': 4.6,
          'category': 'Cookware',
        },
        {
          'name': 'Mixer Grinder',
          'price': '₹3,499',
          'image':
              'https://images.unsplash.com/photo-1584990347449-a9d037f4f96a?w=400',
          'rating': 4.4,
          'category': 'Appliances',
        },
      ].obs;

  // Filtered products based on category
  var filteredProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filterProducts(); // Initial filter
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  void filterProducts() {
    if (selectedCategory.value == 'All') {
      filteredProducts.value = products;
    } else {
      filteredProducts.value =
          products
              .where((product) => product['category'] == selectedCategory.value)
              .toList();
    }
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }
}

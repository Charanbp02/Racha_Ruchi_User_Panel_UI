import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class ProductsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var selectedCategory = 'All'.obs;
  var isGridView = true.obs;

  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;

  final categories = ['All', 'Cookware', 'Kitchen', 'Appliances', 'Books'];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final snapshot = await firestore.collection('products').get();

      // Add this check
      if (snapshot.docs.isEmpty) {
        products.value = [];
        filteredProducts.value = [];
        Get.snackbar('Info', 'No products found');
        return;
      }

      products.value =
          snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();

      filterProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
      print('Error fetching products: $e'); // Add logging
    } finally {
      isLoading(false);
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  void filterProducts() {
    if (selectedCategory.value == 'All') {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) => product.category == selectedCategory.value),
      );
    }
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }
}

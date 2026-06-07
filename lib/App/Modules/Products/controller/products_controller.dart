// lib/App/Modules/Products/controller/products_controller.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class ProductsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  var isLoading = true.obs;
  var selectedCategory = 'All'.obs;
  var isConnected = true.obs;
  var lastUpdateTime = DateTime.now().obs;
  var isSearching = false.obs;
  var searchResultCount = 0.obs;
  var exactMatchProducts = <ProductModel>[].obs;
  var startsWithProducts = <ProductModel>[].obs;
  var containsProducts = <ProductModel>[].obs;

  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var categories = <String>[].obs;

  Timer? _searchDebounceTimer;

  late Stream<List<ProductModel>> _productsStream;
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeRealtimeProducts();
    _fetchCategories();
    searchController.addListener(_onSearchTextChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchTextChanged);
    searchController.dispose();
    _productsSubscription?.cancel();
    _searchDebounceTimer?.cancel();
    super.onClose();
  }

  void _onSearchTextChanged() {
    if (_searchDebounceTimer?.isActive ?? false) _searchDebounceTimer!.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      searchProductsRealtime(searchController.text);
    });
  }

  void _initializeRealtimeProducts() {
    print('🔄 Initializing real-time products listener...');

    _productsStream = _firestore
        .collection('products')
        .where('isInStock', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print('📡 Real-time update received from Firestore');
          return snapshot.docs.map((doc) {
            return ProductModel.fromMap(doc.data(), doc.id);
          }).toList();
        });

    _productsSubscription = _productsStream.listen(
      (productList) {
        if (!isLoading.value && products.isNotEmpty) {
          final addedCount = productList.length - products.length;
          final removedCount = products.length - productList.length;

          if (addedCount > 0) {
            _showRealtimeNotification('✨ $addedCount new product(s) added!');
          } else if (removedCount > 0) {
            _showRealtimeNotification('📦 $removedCount product(s) removed');
          } else if (productList.length == products.length) {
            _showRealtimeNotification(
              '🔄 Products list updated',
              isUpdate: true,
            );
          }
        }

        products.assignAll(productList);
        searchProductsRealtime(searchController.text);
        isLoading.value = false;
        lastUpdateTime.value = DateTime.now();
        isConnected.value = true;

        print('✅ Products updated: ${productList.length} products available');
      },
      onError: (error) {
        print('❌ Error in real-time stream: $error');
        isLoading.value = false;
        isConnected.value = false;

        Get.snackbar(
          'Connection Issue',
          'Unable to fetch latest products. Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      },
    );
  }

  void _showRealtimeNotification(String message, {bool isUpdate = false}) {
    Get.snackbar(
      isUpdate ? 'Products Updated' : 'New Arrivals',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isUpdate ? Colors.blue.shade700 : Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 12,
      icon: Icon(
        isUpdate ? Iconsax.refresh : Iconsax.gift,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      if (snapshot.docs.isNotEmpty) {
        categories.value = [
          'All',
          ...snapshot.docs.map((doc) => doc['name'] as String),
        ];
      } else {
        categories.value = [
          'All',
          'Cookware',
          'Kitchen',
          'Appliances',
          'Books',
          'Spices',
          'Ready to Cook',
        ];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      categories.value = ['All', 'Cookware', 'Kitchen', 'Appliances', 'Books'];
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    searchProductsRealtime(searchController.text);
  }

  void searchProductsRealtime(String query) {
    isSearching.value = true;
    searchQuery.value = query.trim();

    List<ProductModel> tempList = products.toList();

    if (selectedCategory.value != "All") {
      tempList =
          tempList
              .where((product) => product.category == selectedCategory.value)
              .toList();
    }

    if (query.isNotEmpty && query.trim().isNotEmpty) {
      final searchTerm = searchQuery.value.toLowerCase();

      exactMatchProducts.clear();
      startsWithProducts.clear();
      containsProducts.clear();

      List<ProductModel> matchedProducts = [];

      for (var product in tempList) {
        final productName = product.name.toLowerCase();

        if (productName == searchTerm) {
          exactMatchProducts.add(product);
          matchedProducts.add(product);
        } else if (productName.startsWith(searchTerm)) {
          startsWithProducts.add(product);
          matchedProducts.add(product);
        } else if (productName.contains(searchTerm)) {
          containsProducts.add(product);
          matchedProducts.add(product);
        } else if (product.description.toLowerCase().contains(searchTerm) ||
            product.brand.toLowerCase().contains(searchTerm) ||
            product.category.toLowerCase().contains(searchTerm)) {
          containsProducts.add(product);
          matchedProducts.add(product);
        }
      }

      startsWithProducts.sort((a, b) => a.name.compareTo(b.name));
      containsProducts.sort((a, b) => a.name.compareTo(b.name));

      final prioritizedList = <ProductModel>[];
      prioritizedList.addAll(exactMatchProducts);
      prioritizedList.addAll(startsWithProducts);
      prioritizedList.addAll(containsProducts);

      filteredProducts.assignAll(prioritizedList);
      searchResultCount.value = filteredProducts.length;
    } else {
      filteredProducts.assignAll(tempList);
      searchResultCount.value = tempList.length;
      exactMatchProducts.clear();
      startsWithProducts.clear();
      containsProducts.clear();
    }

    isSearching.value = false;
  }

  int get exactMatchCount => exactMatchProducts.length;
  int get startsWithCount => startsWithProducts.length;
  int get containsCount => containsProducts.length;

  // Get products by weight variant
  List<ProductModel> getProductsByWeightVariant(String weight) {
    return products
        .where((product) => product.weightVariants.contains(weight))
        .toList();
  }

  // Get products that have weight variants
  List<ProductModel> get productsWithWeightVariants {
    return products.where((product) => product.hasWeightVariants).toList();
  }

  // Get all unique weight variants across products
  List<String> getAllWeightVariants() {
    final variants = <String>{};
    for (var product in products) {
      variants.addAll(product.weightVariants);
    }
    return variants.toList()..sort();
  }

  Future<void> refreshProducts() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    selectedCategory.value = 'All';
    searchProductsRealtime('');
  }

  List<ProductModel> get featuredProducts {
    return products.where((product) => product.isFeatured).toList();
  }

  List<ProductModel> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }
}

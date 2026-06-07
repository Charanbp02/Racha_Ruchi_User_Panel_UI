// lib/App/Modules/Product_Details/controller/product_details_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Product_Details_Model/product_details_model.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class ProductDetailsController extends GetxController {
  late ProductDetailsModel productModel;

  final RxInt _quantity = 1.obs;
  final RxString _selectedWeight = ''.obs;
  final RxInt _selectedImageIndex = 0.obs;
  final RxBool _isInWishlist = false.obs;
  final RxBool _isAddingToCart = false.obs;

  @override
  void onInit() {
    super.onInit();
    productModel = Get.arguments as ProductDetailsModel;
    // Auto-select first weight variant if available
    if (productModel.hasWeightVariants &&
        productModel.weightVariants.isNotEmpty) {
      _selectedWeight.value = productModel.weightVariants.first;
    }
  }

  int get quantity => _quantity.value;
  String get selectedWeight => _selectedWeight.value;
  int get selectedImageIndex => _selectedImageIndex.value;
  bool get isInWishlist => _isInWishlist.value;
  bool get isAddingToCart =>
      _isAddingToCart.value; // This returns bool, not RxBool

  void increaseQty() {
    if (quantity <
        (productModel.product.stock > 10 ? 10 : productModel.product.stock)) {
      _quantity.value++;
    } else {
      Get.snackbar(
        'Limit Reached',
        'Maximum ${productModel.product.stock > 10 ? 10 : productModel.product.stock} items allowed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void decreaseQty() {
    if (quantity > 1) {
      _quantity.value--;
    }
  }

  void selectWeight(String weight) {
    if (_selectedWeight.value == weight) {
      _selectedWeight.value = '';
    } else {
      _selectedWeight.value = weight;
    }
  }

  void selectImage(int index) {
    _selectedImageIndex.value = index;
  }

  void toggleWishlist() {
    _isInWishlist.value = !_isInWishlist.value;
    Get.snackbar(
      _isInWishlist.value ? 'Added to Wishlist' : 'Removed from Wishlist',
      _isInWishlist.value
          ? '${productModel.product.name} added to your wishlist'
          : '${productModel.product.name} removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _isInWishlist.value ? Colors.green : Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> addToCart() async {
    // Validation
    if (productModel.product.stock <= 0) {
      Get.snackbar(
        'Out of Stock',
        'This product is currently out of stock',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (productModel.hasWeightVariants && selectedWeight.isEmpty) {
      Get.snackbar(
        'Select Weight',
        'Please select a weight variant before adding to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _isAddingToCart.value = true;

    try {
      final cartController = Get.find<CartController>();

      await cartController.addToCart(
        product: productModel.product,
        quantity: quantity,
        selectedWeight: selectedWeight.isNotEmpty ? selectedWeight : null,
      );

      // Show success message
      String variantInfo =
          selectedWeight.isNotEmpty ? ' ($selectedWeight)' : '';
      Get.snackbar(
        'Added to Cart',
        '$quantity x ${productModel.product.name}$variantInfo added to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        mainButton: TextButton(
          onPressed: () => Get.toNamed('/cart'),
          child: const Text(
            'VIEW CART',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isAddingToCart.value = false;
    }
  }

  double get totalPrice => productModel.product.price * quantity;
}

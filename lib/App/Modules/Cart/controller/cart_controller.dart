// lib/App/Modules/Cart/controller/cart_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racharuchi/App/Models/Cart_Model/cart_models.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var cartItems = <CartItemModel>[].obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var selectedAddress = 0.obs;
  var deliveryCharge = 40.0.obs;
  var taxPercentage = 5.0.obs;
  var discountAmount = 0.0.obs;
  var appliedCoupon = ''.obs;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  // Load cart items from Firebase
  Future<void> loadCartItems() async {
    if (currentUserId == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    try {
      final cartDoc =
          await _firestore
              .collection('carts')
              .doc(currentUserId)
              .collection('items')
              .get();

      final items =
          cartDoc.docs.map((doc) {
            return CartItemModel.fromJson(doc.data());
          }).toList();

      cartItems.assignAll(items);
      print('✅ Loaded ${cartItems.length} items from cart');
    } catch (e) {
      print('❌ Error loading cart: $e');
      _showSnackbar('Error', 'Failed to load cart items', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Add product to cart with Firebase
  Future<void> addToCart({
    required ProductModel product,
    int quantity = 1,
    String? selectedWeight,
  }) async {
    if (currentUserId == null) {
      _showSnackbar(
        'Login Required',
        'Please login to add items to cart',
        isError: true,
      );
      return;
    }

    isUpdating.value = true;

    try {
      // Check if item already exists in cart with same variant
      final existingItemIndex = cartItems.indexWhere(
        (item) =>
            item.id == product.id && item.selectedWeight == selectedWeight,
      );

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        final existingItem = cartItems[existingItemIndex];
        final newQuantity = existingItem.quantity + quantity;

        await _updateCartItemInFirebase(
          product.id,
          newQuantity,
          selectedWeight,
        );

        cartItems[existingItemIndex].quantity = newQuantity;
        cartItems.refresh();

        _showSnackbar(
          'Cart Updated',
          '${product.name} quantity increased to $newQuantity',
        );
      } else {
        // Add new item
        final cartItem = CartItemModel(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: quantity,
          imageUrl: product.mainImage,
          restaurant: product.brand,
          isVeg: true, // You can determine based on product category
          selectedWeight: selectedWeight,
          category: product.category,
          brand: product.brand,
        );

        await _addCartItemToFirebase(cartItem);
        cartItems.add(cartItem);

        _showSnackbar(
          'Added to Cart',
          '${product.name}${selectedWeight != null ? ' ($selectedWeight)' : ''} added to cart',
        );
      }

      // Update cart count in UI
      update();
    } catch (e) {
      print('❌ Error adding to cart: $e');
      _showSnackbar('Error', 'Failed to add item to cart', isError: true);
    } finally {
      isUpdating.value = false;
    }
  }

  // Add cart item to Firebase
  Future<void> _addCartItemToFirebase(CartItemModel item) async {
    await _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .doc('${item.id}_${item.selectedWeight ?? 'default'}')
        .set(item.toJson());
  }

  // Update cart item in Firebase
  Future<void> _updateCartItemInFirebase(
    String productId,
    int newQuantity,
    String? selectedWeight,
  ) async {
    await _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .doc('${productId}_${selectedWeight ?? 'default'}')
        .update({'quantity': newQuantity});
  }

  // Increment quantity
  Future<void> incrementQuantity(int index) async {
    if (currentUserId == null) return;

    isUpdating.value = true;

    try {
      final item = cartItems[index];
      final newQuantity = item.quantity + 1;

      await _updateCartItemInFirebase(
        item.id,
        newQuantity,
        item.selectedWeight,
      );

      cartItems[index].quantity = newQuantity;
      cartItems.refresh();

      _saveToStorage();
    } catch (e) {
      print('❌ Error incrementing quantity: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Decrement quantity
  Future<void> decrementQuantity(int index) async {
    if (currentUserId == null) return;

    isUpdating.value = true;

    try {
      final item = cartItems[index];

      if (item.quantity > 1) {
        final newQuantity = item.quantity - 1;
        await _updateCartItemInFirebase(
          item.id,
          newQuantity,
          item.selectedWeight,
        );

        cartItems[index].quantity = newQuantity;
        cartItems.refresh();
      } else {
        await removeItem(index);
      }

      _saveToStorage();
    } catch (e) {
      print('❌ Error decrementing quantity: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Remove item from cart
  Future<void> removeItem(int index) async {
    if (currentUserId == null) return;

    final item = cartItems[index];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Item'),
        content: Text('Remove ${item.displayName} from cart?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isUpdating.value = true;

              try {
                await _firestore
                    .collection('carts')
                    .doc(currentUserId)
                    .collection('items')
                    .doc('${item.id}_${item.selectedWeight ?? 'default'}')
                    .delete();

                cartItems.removeAt(index);
                _saveToStorage();
                _showSnackbar('Removed', 'Item removed from cart');
              } catch (e) {
                print('❌ Error removing item: $e');
                _showSnackbar('Error', 'Failed to remove item', isError: true);
              } finally {
                isUpdating.value = false;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  // Clear entire cart
  Future<void> clearCart() async {
    if (currentUserId == null) return;

    if (cartItems.isEmpty) {
      _showSnackbar('Cart Empty', 'No items to clear', isError: true);
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear your cart?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isUpdating.value = true;

              try {
                // Delete all items from Firebase
                final batch = _firestore.batch();
                final itemsRef = _firestore
                    .collection('carts')
                    .doc(currentUserId)
                    .collection('items');

                final snapshot = await itemsRef.get();
                for (var doc in snapshot.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();

                cartItems.clear();
                discountAmount.value = 0;
                appliedCoupon.value = '';

                _saveToStorage();
                _showSnackbar('Cleared', 'Cart cleared successfully');
              } catch (e) {
                print('❌ Error clearing cart: $e');
                _showSnackbar('Error', 'Failed to clear cart', isError: true);
              } finally {
                isUpdating.value = false;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Sync cart with Firebase (real-time)
  void syncCartWithFirebase() {
    if (currentUserId == null) return;

    _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .snapshots()
        .listen((snapshot) {
          final items =
              snapshot.docs.map((doc) {
                return CartItemModel.fromJson(doc.data());
              }).toList();

          cartItems.assignAll(items);
          print('🔄 Cart synced: ${items.length} items');
        });
  }

  double getSubtotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double getTax() {
    return (getSubtotal() * taxPercentage.value) / 100;
  }

  double getTotal() {
    return getSubtotal() +
        deliveryCharge.value +
        getTax() -
        discountAmount.value;
  }

  int get totalItems {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  void applyCoupon(String couponCode) {
    if (couponCode.isEmpty) {
      _showSnackbar('Error', 'Please enter a coupon code', isError: true);
      return;
    }

    if (appliedCoupon.value == couponCode) {
      _showSnackbar(
        'Already Applied',
        'This coupon is already applied',
        isError: true,
      );
      return;
    }

    // Coupon validation logic
    if (couponCode.toUpperCase() == 'SAVE20') {
      discountAmount.value = 20.0;
      appliedCoupon.value = couponCode.toUpperCase();
      _showSnackbar(
        'Coupon Applied!',
        'You saved ₹${discountAmount.value.toStringAsFixed(2)}',
      );
    } else if (couponCode.toUpperCase() == 'SAVE10') {
      discountAmount.value = 10.0;
      appliedCoupon.value = couponCode.toUpperCase();
      _showSnackbar(
        'Coupon Applied!',
        'You saved ₹${discountAmount.value.toStringAsFixed(2)}',
      );
    } else if (couponCode.toUpperCase() == 'FREEDELIVERY') {
      deliveryCharge.value = 0;
      appliedCoupon.value = couponCode.toUpperCase();
      _showSnackbar('Coupon Applied!', 'Free delivery applied');
    } else {
      _showSnackbar(
        'Invalid Coupon',
        'Please enter a valid coupon code',
        isError: true,
      );
    }
  }

  void removeCoupon() {
    if (appliedCoupon.value.isNotEmpty) {
      discountAmount.value = 0;
      deliveryCharge.value = 40.0;
      appliedCoupon.value = '';
      _showSnackbar('Coupon Removed', 'Coupon has been removed');
    }
  }

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      _showSnackbar(
        'Cart Empty',
        'Add items to your cart first',
        isError: true,
      );
      return;
    }

    Get.toNamed(
      '/checkout',
      arguments: {
        'items': cartItems,
        'subtotal': getSubtotal(),
        'deliveryCharge': deliveryCharge.value,
        'tax': getTax(),
        'discount': discountAmount.value,
        'total': getTotal(),
        'coupon': appliedCoupon.value,
      },
    );
  }

  void _saveToStorage() {
    // Save to local storage for offline access
    // You can implement SharedPreferences or GetStorage here
    print('Cart saved locally: ${cartItems.length} items');
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}

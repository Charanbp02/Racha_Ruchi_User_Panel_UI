// lib/App/Modules/Cart/controller/cart_controller.dart
import 'dart:async';

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

  // Store settings from Firebase with real-time updates
  var deliveryCharge = 0.0.obs;
  var minimumOrderAmount = 0.0.obs;
  var freeDeliveryAbove = 0.0.obs;

  // Stream subscriptions
  Stream<QuerySnapshot>? _cartStream;
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<DocumentSnapshot>? _storeSubscription; // ✅ New

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get total cart items count for badge
  int get cartItemCount {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();
    _setupStoreListener(); // ✅ Real-time store settings
    _setupAuthListener();
    loadCartItems();
  }

  @override
  void onClose() {
    _cartSubscription?.cancel();
    _storeSubscription?.cancel(); // ✅ Clean up
    super.onClose();
  }

  // ✅ Real-time store settings listener
  void _setupStoreListener() {
    // Cancel existing subscription
    _storeSubscription?.cancel();

    // Listen to store config changes in real-time
    _storeSubscription = _firestore
        .collection('stores')
        .doc('config')
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data()!;

              deliveryCharge.value = (data['deliveryCharge'] ?? 0).toDouble();
              minimumOrderAmount.value =
                  (data['minimumOrderAmount'] ?? 0).toDouble();
              freeDeliveryAbove.value =
                  (data['freeDeliveryAbove'] ?? 0).toDouble();

              print('🔄 Store settings updated in real-time:');
              print('   📦 Delivery: ₹$deliveryCharge');
              print('   📋 Min Order: ₹$minimumOrderAmount');
              print('   🆓 Free Delivery Above: ₹$freeDeliveryAbove');

              // Update UI
              update();
            } else {
              print('⚠️ Store config not found, using default values');
              // Set fallback values
              deliveryCharge.value = 40.0;
              minimumOrderAmount.value = 0.0;
              freeDeliveryAbove.value = 0.0;
            }
          },
          onError: (error) {
            print('❌ Real-time store settings error: $error');
            // Set fallback values on error
            deliveryCharge.value = 40.0;
            minimumOrderAmount.value = 0.0;
            freeDeliveryAbove.value = 0.0;
          },
        );
  }

  // Listen to auth changes
  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User logged in, setup real-time sync
        setupRealTimeSync();
      } else {
        // User logged out, clear cart
        _cartSubscription?.cancel();
        cartItems.clear();
      }
    });
  }

  // Setup real-time Firebase sync for cart
  void setupRealTimeSync() {
    if (currentUserId == null) return;

    // Cancel existing subscription
    _cartSubscription?.cancel();

    // Setup new real-time listener
    _cartSubscription = _firestore
        .collection('carts')
        .doc(currentUserId)
        .collection('items')
        .snapshots()
        .listen(
          (snapshot) {
            final items =
                snapshot.docs.map((doc) {
                  return CartItemModel.fromJson(doc.data());
                }).toList();

            cartItems.assignAll(items);
            print('🔄 Cart synced in real-time: ${items.length} items');

            // Update cart count in UI
            update();
          },
          onError: (error) {
            print('❌ Real-time sync error: $error');
          },
        );
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

      // Setup real-time sync after initial load
      setupRealTimeSync();
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
          isVeg: true,
          selectedWeight: selectedWeight,
          category: product.category,
          brand: product.brand,
        );

        await _addCartItemToFirebase(cartItem);

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
      } else {
        await removeItem(index);
      }
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

  // Calculate subtotal
  double getSubtotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Calculate delivery charge with free delivery logic
  double getDeliveryCharge() {
    if (getSubtotal() >= freeDeliveryAbove.value &&
        freeDeliveryAbove.value > 0) {
      return 0;
    }
    return deliveryCharge.value;
  }

  // Calculate total (TAX REMOVED)
  double getTotal() {
    return getSubtotal() + getDeliveryCharge();
  }

  // Get total number of items
  int get totalItems {
    int total = 0;
    for (var item in cartItems) {
      total += item.quantity;
    }
    return total;
  }

  // Proceed to checkout with validation
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      _showSnackbar(
        'Cart Empty',
        'Add items to your cart first',
        isError: true,
      );
      return;
    }

    if (getSubtotal() < minimumOrderAmount.value &&
        minimumOrderAmount.value > 0) {
      _showSnackbar(
        'Minimum Order Required',
        'Minimum order amount is ₹${minimumOrderAmount.value.toStringAsFixed(2)}',
        isError: true,
      );
      return;
    }

    Get.toNamed(
      '/checkout',
      arguments: {
        'items': cartItems,
        'subtotal': getSubtotal(),
        'deliveryCharge': getDeliveryCharge(),
        'total': getTotal(),
        'minimumOrderAmount': minimumOrderAmount.value,
        'freeDeliveryAbove': freeDeliveryAbove.value,
      },
    );
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

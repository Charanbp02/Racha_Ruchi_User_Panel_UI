import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Cart_Model/cart_models.dart';

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;
  var isLoading = false.obs;
  var selectedAddress = 0.obs;
  var deliveryCharge = 40.0.obs;
  var taxPercentage = 5.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  void loadCartItems() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      cartItems.value = [
        CartItemModel(
          id: '1',
          name: 'Chicken Biryani',
          price: 299.0,
          quantity: 1,
          imageUrl:
              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
          restaurant: 'Biryani House',
          isVeg: false,
        ),
        CartItemModel(
          id: '2',
          name: 'Paneer Butter Masala',
          price: 249.0,
          quantity: 2,
          imageUrl:
              'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8',
          restaurant: 'Punjabi Dhaba',
          isVeg: true,
        ),
        CartItemModel(
          id: '3',
          name: 'Garlic Naan',
          price: 45.0,
          quantity: 3,
          imageUrl:
              'https://images.unsplash.com/photo-1604135307499-6a4f9e2b11a0',
          restaurant: 'Punjabi Dhaba',
          isVeg: true,
        ),
        CartItemModel(
          id: '4',
          name: 'Masala Dosa',
          price: 89.0,
          quantity: 1,
          imageUrl:
              'https://images.unsplash.com/photo-1589301760014-3b6c3c3f5f5c',
          restaurant: 'South Indian Cafe',
          isVeg: true,
        ),
      ];
      isLoading.value = false;
    });
  }

  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      removeItem(index);
    }
    cartItems.refresh();
  }

  void removeItem(int index) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Item'),
        content: Text('Remove ${cartItems[index].name} from cart?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              cartItems.removeAt(index);
              Get.back();
              Get.snackbar(
                'Removed',
                'Item removed from cart',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
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
    return getSubtotal() + deliveryCharge.value + getTax();
  }

  void clearCart() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear your cart?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              cartItems.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'Cart cleared successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
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

  void applyCoupon(String couponCode) {
    if (couponCode == 'SAVE20') {
      Get.snackbar(
        'Coupon Applied',
        'You saved ₹20 on your order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Invalid Coupon',
        'Please enter a valid coupon code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Add items to your cart first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(
      '/checkout',
      arguments: {'items': cartItems, 'total': getTotal()},
    );
  }
}


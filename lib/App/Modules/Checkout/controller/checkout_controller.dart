// lib/App/Modules/Checkout/controller/checkout_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racharuchi/App/Models/Checkout_Model/checkout_model.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';

class CheckoutController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late CartController cartController;

  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final selectedPaymentMethod = PaymentMethod.cod.obs;
  final isLoading = false.obs;
  final isPlacingOrder = false.obs;
  final addresses = <AddressModel>[].obs;
  final isLoadingAddresses = false.obs;
  final isAddressPickerOpen = false.obs;

  final isAddingNewAddress = false.obs;
  final isProcessing = false.obs;
  final subtotal = 0.0.obs;
  final deliveryCharge = 0.0.obs;
  final discount = 0.0.obs;
  final couponDiscount = 0.0.obs;
  final gst = 0.0.obs;
  final grandTotal = 0.0.obs;
  final selectedCoupon = ''.obs;
  final isCouponApplied = false.obs;

  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController alternatePhoneController =
      TextEditingController();
  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  final paymentMethods = ['Cash on Delivery', 'UPI'].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadAddresses();
    calculateTotals();
  }

  void _initializeControllers() {
    try {
      if (Get.isRegistered<CartController>()) {
        cartController = Get.find<CartController>();
      } else {
        cartController = Get.put(CartController());
      }
    } catch (e) {
      cartController = Get.put(CartController());
    }
  }

  void calculateTotals() {
    subtotal.value = cartController.getSubtotal();
    deliveryCharge.value = cartController.getDeliveryCharge();
    gst.value = subtotal.value * 0.05;
    grandTotal.value =
        subtotal.value +
        deliveryCharge.value +
        gst.value -
        discount.value -
        couponDiscount.value;
  }

  Future<void> loadAddresses() async {
    isLoadingAddresses.value = true;
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print('User not logged in');
        isLoadingAddresses.value = false;
        return;
      }

      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('addresses')
              .get();

      final addressList =
          snapshot.docs.map((doc) {
            return AddressModel.fromMap(doc.data(), doc.id);
          }).toList();

      addressList.sort((a, b) {
        if (a.isDefault && !b.isDefault) return -1;
        if (!a.isDefault && b.isDefault) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      addresses.value = addressList;

      final defaultAddress = addressList.firstWhereOrNull((a) => a.isDefault);
      if (defaultAddress != null) {
        selectedAddress.value = defaultAddress;
      } else if (addressList.isNotEmpty) {
        selectedAddress.value = addressList.first;
      } else {
        selectedAddress.value = null;
      }

      print('✅ Loaded ${addressList.length} addresses');
    } catch (e) {
      print('❌ Error loading addresses: $e');
      Get.snackbar(
        'Error',
        'Failed to load addresses',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void toggleAddNewAddress() {
    isAddingNewAddress.value = !isAddingNewAddress.value;
    if (!isAddingNewAddress.value) {
      clearAddressForm();
    }
  }

  void clearAddressForm() {
    contactNameController.clear();
    mobileNumberController.clear();
    alternatePhoneController.clear();
    addressLineController.clear();
    addressLine2Controller.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    countryController.clear();
  }

  Future<void> addNewAddress() async {
    if (!addressFormKey.currentState!.validate()) return;

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'Please login to add address');
        return;
      }

      // Create new address WITHOUT userId (since it's not in the model)
      final newAddress = AddressModel(
        id: '', // Will be set by Firestore
        type: 'Home',
        name: contactNameController.text,
        phone: mobileNumberController.text,
        alternatePhone:
            alternatePhoneController.text.isNotEmpty
                ? alternatePhoneController.text
                : null,
        addressLine1: addressLineController.text,
        addressLine2:
            addressLine2Controller.text.isNotEmpty
                ? addressLine2Controller.text
                : null,
        landmark:
            landmarkController.text.isNotEmpty ? landmarkController.text : null,
        city: cityController.text,
        state: stateController.text,
        pincode: pincodeController.text,
        country:
            countryController.text.isNotEmpty
                ? countryController.text
                : 'India',
        isDefault: addresses.isEmpty,
        latitude: null,
        longitude: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .add(newAddress.toMap());

      final addedAddress = newAddress.copyWith(id: docRef.id);
      addresses.add(addedAddress);

      if (addresses.length == 1 || newAddress.isDefault) {
        selectedAddress.value = addedAddress;
      }

      isAddingNewAddress.value = false;
      clearAddressForm();

      Get.snackbar(
        'Success',
        'Address added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      loadAddresses();
    } catch (e) {
      print('Error adding address: $e');
      Get.snackbar(
        'Error',
        'Failed to add address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(address.id)
          .delete();

      addresses.remove(address);

      if (selectedAddress.value?.id == address.id) {
        selectedAddress.value = addresses.isNotEmpty ? addresses.first : null;
      }

      Get.snackbar(
        'Success',
        'Address deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting address: $e');
      Get.snackbar(
        'Error',
        'Failed to delete address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
    Get.back();
    isAddressPickerOpen.value = false;
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = PaymentMethod.values.firstWhere(
      (e) => e.displayName == method,
      orElse: () => PaymentMethod.cod,
    );
  }

  void updateQuantity(dynamic item, int change) {
    final index = cartController.cartItems.indexOf(item);

    if (index == -1) return;

    final newQty = cartController.cartItems[index].quantity + change;

    if (newQty >= 1 && newQty <= 10) {
      cartController.cartItems[index].quantity = newQty;

      cartController.cartItems.refresh(); // UI rebuild

      calculateTotals();
    }
  }

  void updateWeight(dynamic item, String newWeight) {
    item.selectedWeight = newWeight;
    calculateTotals();
  }

  void applyCoupon() {
    final code = couponController.text.trim();
    if (code.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a coupon code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (code.toUpperCase() == 'SAVE10') {
      couponDiscount.value = subtotal.value * 0.1;
      isCouponApplied.value = true;
      selectedCoupon.value = code;
      calculateTotals();
      Get.snackbar(
        'Success',
        'Coupon applied! You saved ₹${couponDiscount.value.toStringAsFixed(2)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Invalid Coupon',
        'This coupon code is not valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeCoupon() {
    couponDiscount.value = 0;
    isCouponApplied.value = false;
    selectedCoupon.value = '';
    couponController.clear();
    calculateTotals();
  }

  Future<void> placeOrder() async {
    if (!canPlaceOrder) {
      Get.snackbar(
        'Cannot Place Order',
        'Please select a shipping address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Your cart is empty. Please add items to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isProcessing.value = true;

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar(
          'Login Required',
          'Please login to place order',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final currentAddress = selectedAddress.value;
      if (currentAddress == null) {
        Get.snackbar(
          'Error',
          'No shipping address selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final orderItems =
          cartController.cartItems.map((item) {
            return OrderItemModel(
              productId: item.id,
              name: item.name,
              price: item.price,
              quantity: item.quantity,
              imageUrl: item.imageUrl,
              selectedWeight: item.selectedWeight,
              total: item.price * item.quantity,
            );
          }).toList();

      final addressMap = currentAddress.toMap();

      final orderRef = _firestore.collection('orders').doc();
      final order = CheckoutModel(
        id: orderRef.id,
        userId: userId,
        items: orderItems,
        subtotal: subtotal.value,
        deliveryCharge: deliveryCharge.value,
        discount: discount.value + couponDiscount.value,
        couponCode: isCouponApplied.value ? selectedCoupon.value : null,
        total: grandTotal.value,
        paymentMethod: selectedPaymentMethod.value,
        status: OrderStatus.pending,
        shippingAddress: addressMap,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await orderRef.set(order.toMap());
      await cartController.clearCart();

      // Success dialog
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Order Placed Successfully!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Order #${orderRef.id.substring(0, 8).toUpperCase()}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/my-orders');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Order Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.offAllNamed('/product');
                  },
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      print('Error placing order: $e');
      Get.snackbar(
        'Order Failed',
        'Failed to place order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isProcessing.value = false;
    }
  }

  bool get isAddressSelected => selectedAddress.value != null;

  bool get canPlaceOrder {
    return selectedAddress.value != null && cartController.cartItems.isNotEmpty;
  }

  int get itemCount => cartController.totalItems;

  String getFormattedAddress(AddressModel address) {
    return address.formattedAddress; // Use the built-in getter
  }

  bool get hasSavedAddresses => addresses.isNotEmpty;

  @override
  void onClose() {
    contactNameController.dispose();
    mobileNumberController.dispose();
    alternatePhoneController.dispose();
    addressLineController.dispose();
    addressLine2Controller.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    countryController.dispose();
    couponController.dispose();
    super.onClose();
  }
}

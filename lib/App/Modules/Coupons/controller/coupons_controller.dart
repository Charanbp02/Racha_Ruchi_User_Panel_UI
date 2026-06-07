// lib/App/Modules/Coupons/controller/coupons_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Coupons_Model/coupons_models.dart';

class CouponsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var availableCoupons = <CouponModel>[].obs;
  var usedCoupons = <CouponModel>[].obs;
  var expiredCoupons = <CouponModel>[].obs;
  var isLoading = false.obs;
  var selectedTab = 0.obs;
  var appliedCoupon = Rx<CouponModel?>(null);

  StreamSubscription<QuerySnapshot>? _couponsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeRealtimeCoupons(); // Real-time listener instead of one-time load
  }

  @override
  void onClose() {
    _couponsSubscription?.cancel();
    super.onClose();
  }

  // REAL-TIME LISTENER - Updates automatically when admin makes changes
  void _initializeRealtimeCoupons() {
    isLoading.value = true;

    _couponsSubscription = _firestore
        .collection('coupons')
        .where('isEnabled', isEqualTo: true)
        .snapshots()
        .listen(
          (snapshot) {
            final allCoupons =
                snapshot.docs.map((doc) {
                  return CouponModel.fromMap(doc.data(), doc.id);
                }).toList();

            final now = DateTime.now();

            // Separate coupons into categories in real-time
            availableCoupons.value =
                allCoupons.where((coupon) {
                  return coupon.isValid && coupon.validTill.isAfter(now);
                }).toList();

            expiredCoupons.value =
                allCoupons.where((coupon) {
                  return coupon.validTill.isBefore(now) || coupon.isExpired;
                }).toList();

            isLoading.value = false;

            // Show notification when new coupons are added in real-time
            if (!isLoading.value && allCoupons.isNotEmpty) {
              _showRealtimeNotification(allCoupons.length);
            }

            print('✅ Real-time coupons updated: ${allCoupons.length} coupons');
          },
          onError: (error) {
            print('❌ Error loading coupons: $error');
            isLoading.value = false;

            // Fallback to sample data for testing
            _loadSampleData();
          },
        );
  }

  void _showRealtimeNotification(int count) {
    Get.snackbar(
      'New Offers Available!',
      '$count coupon(s) available. Check them out!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFE53935),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 12,
      icon: const Icon(Iconsax.gift, color: Colors.white, size: 20),
    );
  }

  void _loadSampleData() {
    availableCoupons.value = [
      CouponModel(
        id: '1',
        code: 'SAVE20',
        title: '20% Off on First Order',
        description: 'Get 20% discount on your first order',
        discount: '20%',
        minOrder: 299,
        maxDiscount: 150,
        validTill: DateTime.now().add(const Duration(days: 30)),
        type: CouponType.percentage,
        isNew: true,
        isTrending: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CouponModel(
        id: '2',
        code: 'FLAT100',
        title: 'Flat ₹100 Off',
        description: 'Flat discount on orders above ₹499',
        discount: '₹100',
        minOrder: 499,
        maxDiscount: 100,
        validTill: DateTime.now().add(const Duration(days: 45)),
        type: CouponType.flat,
        isNew: true,
        isTrending: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void copyCouponCode(String code) {
    // Copy to clipboard
    Get.snackbar(
      'Coupon Copied!',
      '$code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> applyCoupon(CouponModel coupon, [double orderTotal = 0]) async {
    if (!coupon.canApply(orderTotal)) {
      Get.snackbar(
        'Cannot Apply Coupon',
        'Minimum order amount is ${coupon.formattedMinOrder}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Apply Coupon'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apply coupon ${coupon.code}?'),
            const SizedBox(height: 8),
            Text(
              coupon.description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Min Order: ${coupon.formattedMinOrder}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (orderTotal > 0)
              Text(
                'You save: ₹${coupon.calculateDiscount(orderTotal).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              appliedCoupon.value = coupon;

              Get.snackbar(
                'Coupon Applied!',
                '${coupon.code} applied successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void removeAppliedCoupon() {
    appliedCoupon.value = null;
    Get.snackbar(
      'Coupon Removed',
      'Coupon has been removed from your order',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  // Manual refresh (pull to refresh)
  Future<void> refreshCoupons() async {
    isLoading.value = true;
    // Stream will automatically update
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }
}

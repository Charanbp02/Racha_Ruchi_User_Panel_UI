import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Coupons_Model/coupons_models.dart';

class CouponsController extends GetxController {
  var availableCoupons = <CouponModel>[].obs;
  var usedCoupons = <CouponModel>[].obs;
  var expiredCoupons = <CouponModel>[].obs;
  var isLoading = false.obs;
  var selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  void loadCoupons() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      availableCoupons.value = [
        CouponModel(
          id: '1',
          code: 'SAVE20',
          title: '20% Off on First Order',
          description: 'Get 20% discount on your first order',
          discount: '20%',
          minOrder: '₹299',
          maxDiscount: '₹150',
          validTill: '31 Dec 2024',
          type: CouponType.percentage,
          isNew: true,
          isTrending: true,
        ),
        CouponModel(
          id: '2',
          code: 'FLAT100',
          title: 'Flat ₹100 Off',
          description: 'Flat discount on orders above ₹499',
          discount: '₹100',
          minOrder: '₹499',
          maxDiscount: '₹100',
          validTill: '15 Jan 2025',
          type: CouponType.flat,
          isNew: true,
          isTrending: false,
        ),
        CouponModel(
          id: '3',
          code: 'FREEDEL',
          title: 'Free Delivery',
          description: 'Free delivery on orders above ₹399',
          discount: 'Free',
          minOrder: '₹399',
          maxDiscount: '₹50',
          validTill: '31 Jan 2025',
          type: CouponType.freeDelivery,
          isNew: false,
          isTrending: true,
        ),
        CouponModel(
          id: '4',
          code: 'WEEKEND30',
          title: '30% Off Weekend Special',
          description: 'Special weekend discount',
          discount: '30%',
          minOrder: '₹599',
          maxDiscount: '₹200',
          validTill: '30 Nov 2024',
          type: CouponType.percentage,
          isNew: false,
          isTrending: true,
        ),
        CouponModel(
          id: '5',
          code: 'BOGO50',
          title: 'Buy 1 Get 1 at 50%',
          description: 'Buy one item get second at 50% off',
          discount: '50%',
          minOrder: '₹399',
          maxDiscount: '₹250',
          validTill: '31 Dec 2024',
          type: CouponType.bogo,
          isNew: true,
          isTrending: false,
        ),
      ];

      usedCoupons.value = [
        CouponModel(
          id: '6',
          code: 'WELCOME50',
          title: 'Welcome Discount',
          description: 'Welcome offer for new users',
          discount: '50%',
          minOrder: '₹199',
          maxDiscount: '₹100',
          validTill: '15 Oct 2024',
          type: CouponType.percentage,
          usedOn: '15 Oct 2024',
          isNew: false,
          isTrending: false,
        ),
      ];

      expiredCoupons.value = [
        CouponModel(
          id: '7',
          code: 'FESTIVE40',
          title: 'Festival Special',
          description: 'Festive season discount',
          discount: '40%',
          minOrder: '₹399',
          maxDiscount: '₹300',
          validTill: '30 Sep 2024',
          type: CouponType.percentage,
          isNew: false,
          isTrending: false,
          isExpired: true,
        ),
      ];

      isLoading.value = false;
    });
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

  void applyCoupon(CouponModel coupon) {
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
              'Min Order: ${coupon.minOrder}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
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
}


enum CouponType { percentage, flat, freeDelivery, bogo }

extension CouponTypeExtension on CouponType {
  String get icon {
    switch (this) {
      case CouponType.percentage:
        return '%';
      case CouponType.flat:
        return '₹';
      case CouponType.freeDelivery:
        return '🚚';
      case CouponType.bogo:
        return '🎁';
    }
  }

  Color get color {
    switch (this) {
      case CouponType.percentage:
        return const Color(0xFF4CAF50);
      case CouponType.flat:
        return const Color(0xFFFF9800);
      case CouponType.freeDelivery:
        return const Color(0xFF2196F3);
      case CouponType.bogo:
        return const Color(0xFF9C27B0);
    }
  }
}

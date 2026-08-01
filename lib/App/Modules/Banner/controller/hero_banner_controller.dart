import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeroBannerController extends GetxController {
  // Observable variables
  var banners = <BannerItem>[].obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;

  // Track listener subscription
  StreamSubscription<QuerySnapshot>? _bannerSubscription;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _setupRealtimeBannerListener();
  }

  @override
  void onClose() {
    // Clean up listener when controller is disposed
    _bannerSubscription?.cancel();
    super.onClose();
  }

  // Setup real-time listener for banners
  void _setupRealtimeBannerListener() {
    isLoading.value = true;

    // Create a query for active banners ordered by 'order' field
    final Query query = _firestore
        .collection('banners')
        .where('isActive', isEqualTo: true)
        .orderBy('order');

    // Listen to real-time updates
    _bannerSubscription = query.snapshots().listen(
      (QuerySnapshot snapshot) {
        try {
          // Update banners with real-time data
          final updatedBanners =
              snapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return BannerItem(
                  id: doc.id,
                  imageUrl: data['imageUrl'] ?? '',
                  title: data['title'] ?? '',
                  subtitle: data['description'] ?? '',
                  badge: _getBadgeText(data['type']),
                  type: data['type'] ?? 'home',
                  order: data['order'] ?? 0,
                  link: data['link'],
                );
              }).toList();

          // Update the observable list
          banners.assignAll(updatedBanners);
          isLoading.value = false;

          // Reset current index if out of bounds
          if (currentIndex.value >= banners.length) {
            currentIndex.value = 0;
          }

          print('Banners updated in real-time: ${banners.length} items');
        } catch (e) {
          print('Error processing banner update: $e');
          isLoading.value = false;
        }
      },
      onError: (error) {
        print('Error in banner real-time listener: $error');
        isLoading.value = false;
        // Optionally show error to user
        Get.snackbar(
          'Error',
          'Failed to load banners',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      },
    );
  }

  // Get badge text based on banner type
  String _getBadgeText(String type) {
    switch (type) {
      case 'offer':
        return 'SPECIAL OFFER';
      case 'promo':
        return 'PROMOTION';
      case 'category':
        return 'NEW ARRIVAL';
      case 'home':
        return 'FEATURED';
      default:
        return 'LIMITED TIME';
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void onBannerTap(int index) {
    if (index < 0 || index >= banners.length) return;

    final banner = banners[index];
    print('Banner tapped: ${banner.title}');

    // Navigate based on banner type or link
    if (banner.link != null && banner.link!.isNotEmpty) {
      // Open link in web view or navigate to route
      Get.toNamed(banner.link!);
    } else {
      // Default navigation based on type
      switch (banner.type) {
        case 'offer':
          Get.toNamed('/offers');
          break;
        case 'promo':
          Get.toNamed('/promotions');
          break;
        case 'category':
          Get.toNamed('/categories');
          break;
        default:
          Get.toNamed('/products');
      }
    }
  }

  // Manual refresh (for pull-to-refresh functionality)
  Future<void> refreshBanners() async {
    isLoading.value = true;
    // The listener will automatically update the data
    // But we can force a refresh by re-subscribing
    _bannerSubscription?.cancel();
    _setupRealtimeBannerListener();
  }
}

// BannerItem Model
class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String badge;
  final String type;
  final int order;
  final String? link;

  BannerItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.type,
    required this.order,
    this.link,
  });
}

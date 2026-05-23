import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeroBannerController extends GetxController {
  // Observable variables
  var banners = <BannerItem>[].obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  // Fetch banners from Firestore
  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;

      final QuerySnapshot bannerSnapshot =
          await _firestore
              .collection('banners')
              .where('isActive', isEqualTo: true) // Only active banners
              .orderBy('order')
              .get();

      banners.value =
          bannerSnapshot.docs.map((doc) {
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

      isLoading.value = false;
    } catch (e) {
      print('Error fetching banners: $e');
      isLoading.value = false;
    }
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

  // Refresh banners (call when app comes to foreground)
  Future<void> refreshBanners() async {
    await fetchBanners();
  }
}

// BannerItem Model (Updated)
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

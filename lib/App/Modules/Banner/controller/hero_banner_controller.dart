import 'package:get/get.dart';

class HeroBannerController extends GetxController {
  // Observable variables
  var banners = <BannerItem>[].obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  void fetchBanners() {
    isLoading.value = true;

    // Add your banner data here - replace with actual data source
    banners.value = [
      BannerItem(
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
        title: 'Special Offer',
        subtitle: 'Get 50% off on first order',
        badge: 'LIMITED TIME',
      ),
      BannerItem(
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
        title: 'Free Delivery',
        subtitle: 'On orders above ₹499',
        badge: 'FREE DELIVERY',
      ),
      BannerItem(
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
        title: 'Weekend Special',
        subtitle: 'Buy 1 Get 1 Free',
        badge: 'BOGO',
      ),
    ];

    isLoading.value = false;
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void onBannerTap(int index) {
    print('Banner tapped: ${banners[index].title}');
    // Add navigation logic here
  }
}

// BannerItem Model
class BannerItem {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String badge;

  BannerItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}

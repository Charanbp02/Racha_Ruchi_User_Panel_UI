import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:racharuchi/App/Modules/Banner/controller/hero_banner_controller.dart';

class HeroBannerView extends StatefulWidget {
  final bool autoPlay;
  final Duration autoPlayInterval;

  const HeroBannerView({
    super.key,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
  });

  @override
  State<HeroBannerView> createState() => _HeroBannerViewState();
}

class _HeroBannerViewState extends State<HeroBannerView>
    with SingleTickerProviderStateMixin {
  late final CarouselSliderController _carouselController;
  late final AnimationController _animationController;
  late final HeroBannerController controller;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Register or find controller with proper lifecycle
    if (!Get.isRegistered<HeroBannerController>()) {
      controller = Get.put(HeroBannerController(), permanent: false);
    } else {
      controller = Get.find<HeroBannerController>();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.isLoading.value && controller.banners.isEmpty) {
        return _buildLoadingShimmer();
      }

      // Empty state
      if (controller.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      // Banner carousel - YouTube style (edge-to-edge)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // No ClipRRect - full width, no border radius
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 200,
                  autoPlay: widget.autoPlay,
                  autoPlayInterval: widget.autoPlayInterval,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: false, // Disabled for YouTube style
                  viewportFraction: 1.0, // Full width
                  enableInfiniteScroll: controller.banners.length > 1,
                  pauseAutoPlayOnTouch: true,
                  onPageChanged: (index, reason) {
                    controller.onPageChanged(index);
                    _animationController.forward(from: 0);
                  },
                ),
                items:
                    controller.banners.asMap().entries.map((entry) {
                      final index = entry.key;
                      final banner = entry.value;
                      return GestureDetector(
                        onTap: () => controller.onBannerTap(index),
                        child: _buildBannerCard(banner),
                      );
                    }).toList(),
              ),
              // Navigation buttons (show only if more than 1 banner)
              if (controller.banners.length > 1) ...[
                _buildNavigationButton(
                  left: 8,
                  icon: Icons.chevron_left,
                  onTap:
                      () => _carouselController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                ),
                _buildNavigationButton(
                  right: 8,
                  icon: Icons.chevron_right,
                  onTap:
                      () => _carouselController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Modern indicators
          _buildModernIndicators(),
          const SizedBox(height: 8),
        ],
      );
    });
  }

  Widget _buildNavigationButton({
    double? left,
    double? right,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 22, color: const Color(0xFFD32F2F)),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      height: 200,
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
        ),
      ),
    );
  }

  Widget _buildBannerCard(BannerItem banner) {
    return Container(
      // No margin - full width
      decoration: BoxDecoration(
        // No border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with loading state
          Image.network(
            banner.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFD32F2F),
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              );
            },
          ),
          // Gradient Overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.5, 0.7, 1.0],
              ),
            ),
          ),
          // Content
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge with gradient
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_offer_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        banner.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  banner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernIndicators() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            controller.banners.asMap().entries.map((entry) {
              final isActive = controller.currentIndex.value == entry.key;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient:
                      isActive
                          ? const LinearGradient(
                            colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                          )
                          : null,
                  color: isActive ? null : Colors.grey.withValues(alpha: 0.4),
                ),
              );
            }).toList(),
      ),
    );
  }
}

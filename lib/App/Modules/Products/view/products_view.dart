// lib/App/Modules/Products/view/products_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';
import 'package:racharuchi/App/Modules/Products/widgets/product_search_bar.dart';
import 'package:racharuchi/App/Modules/Products/widgets/search_results_info.dart';
import 'package:racharuchi/App/Modules/Products/widgets/products_grid.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
      appBar: _buildAppBar(controller, isDarkMode),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return _buildLoadingState(isDarkMode);
        }

        return Column(
          children: [
            SearchResultsInfo(controller: controller),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshProducts,
                color: const Color(0xFFE53935),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    _buildSearchSections(controller),
                    ProductsGrid(controller: controller),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ProductsController controller,
    bool isDarkMode,
  ) {
    return AppBar(
      title: Text(
        'Shop',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      centerTitle: false,

      actions: [_buildCartButton()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ProductSearchBar(controller: controller),
      ),
    );
  }

  Widget _buildCartButton() {
    return Obx(
      () => Stack(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.shopping_cart,
                size: 20,
                color: Color(0xFFE53935),
              ),
            ),
            onPressed: () {
              final cartController = Get.find<CartController>();
              cartController.loadCartItems();
              Get.toNamed('/cart');
            },
          ),
          if (Get.isRegistered<CartController>() &&
              Get.find<CartController>().totalItems > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '${Get.find<CartController>().totalItems}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: const Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSections(ProductsController controller) {
    return Obx(() {
      if (controller.searchQuery.value.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverList(
        delegate: SliverChildListDelegate([
          if (controller.exactMatchProducts.isNotEmpty)
            _buildSectionHeader(
              title: 'Exact Matches',
              icon: Iconsax.star1,
              color: Colors.green,
              count: controller.exactMatchProducts.length,
            ),
          if (controller.startsWithProducts.isNotEmpty)
            _buildSectionHeader(
              title: 'Starts With',
              icon: Iconsax.direct_right,
              color: const Color(0xFFFF9800),
              count: controller.startsWithProducts.length,
            ),
          if (controller.containsProducts.isNotEmpty)
            _buildSectionHeader(
              title: 'Contains',
              icon: Iconsax.search_normal,
              color: const Color(0xFF9C27B0),
              count: controller.containsProducts.length,
            ),
        ]),
      );
    });
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Products View with Bottom Navigation
class ProductsViewWithBottomNav extends StatelessWidget {
  const ProductsViewWithBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
      appBar: _buildAppBar(controller, isDarkMode),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return _buildLoadingState(isDarkMode);
        }

        return Column(
          children: [
            SearchResultsInfo(controller: controller),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshProducts,
                color: const Color(0xFFE53935),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    _buildSearchSections(controller),
                    ProductsGrid(controller: controller),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomNav(isDarkMode),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ProductsController controller,
    bool isDarkMode,
  ) {
    return AppBar(
      title: Text(
        'Shop',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      centerTitle: false,
      actions: [
        _buildCartButton(),
        _buildConnectionStatus(controller, isDarkMode),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ProductSearchBar(controller: controller),
      ),
    );
  }

  Widget _buildCartButton() {
    return Obx(
      () => Stack(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.shopping_cart,
                size: 20,
                color: Color(0xFFE53935),
              ),
            ),
            onPressed: () {
              final cartController = Get.find<CartController>();
              cartController.loadCartItems();
              Get.toNamed('/cart');
            },
          ),
          if (Get.isRegistered<CartController>() &&
              Get.find<CartController>().totalItems > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '${Get.find<CartController>().totalItems}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(
    ProductsController controller,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            controller.isConnected.value
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.isConnected.value ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            controller.isConnected.value ? 'Live' : 'Offline',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: controller.isConnected.value ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: const Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSections(ProductsController controller) {
    return Obx(() {
      if (controller.searchQuery.value.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverList(
        delegate: SliverChildListDelegate([
          if (controller.exactMatchProducts.isNotEmpty)
            _buildSectionHeader(
              title: 'Exact Matches',
              icon: Iconsax.star1,
              color: Colors.green,
              count: controller.exactMatchProducts.length,
            ),
          if (controller.startsWithProducts.isNotEmpty)
            _buildSectionHeader(
              title: 'Starts With',
              icon: Iconsax.direct_right,
              color: const Color(0xFFFF9800),
              count: controller.startsWithProducts.length,
            ),
          if (controller.containsProducts.isNotEmpty)
            _buildSectionHeader(
              title: 'Contains',
              icon: Iconsax.search_normal,
              color: const Color(0xFF9C27B0),
              count: controller.containsProducts.length,
            ),
        ]),
      );
    });
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFE53935),
          unselectedItemColor:
              isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.shopping_bag),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

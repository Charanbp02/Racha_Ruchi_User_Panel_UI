// lib/App/Modules/Products/widgets/products_grid.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';
import 'package:racharuchi/App/Modules/Products/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final ProductsController controller;

  const ProductsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.filteredProducts.isEmpty) {
        return _buildEmptyState(isDarkMode);
      }

      return SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = controller.filteredProducts[index];
            final isExactMatch = controller.exactMatchProducts.contains(
              product,
            );
            final isStartsWithMatch = controller.startsWithProducts.contains(
              product,
            );

            return ProductCard(
              product: product,
              searchQuery: controller.searchQuery.value,
              isExactMatch: isExactMatch,
              isStartsWithMatch: isStartsWithMatch,
            );
          }, childCount: controller.filteredProducts.length),
        ),
      );
    });
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.searchQuery.value.isNotEmpty
                      ? Iconsax.search_normal_1
                      : Iconsax.box_1,
                  size: 56,
                  color:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                controller.searchQuery.value.isNotEmpty
                    ? 'No products found'
                    : 'No products available',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.searchQuery.value.isNotEmpty
                    ? 'Try different keywords or check spelling'
                    : 'Check back later for new products',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              if (controller.searchQuery.value.isNotEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.clearSearch,
                  icon: const Icon(Iconsax.close_circle, size: 18),
                  label: Text(
                    'Clear Search',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative: Products Grid with Loading Shimmer
class ProductsGridWithShimmer extends StatelessWidget {
  final ProductsController controller;

  const ProductsGridWithShimmer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value && controller.filteredProducts.isEmpty) {
        return SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildShimmerCard(isDarkMode),
              childCount: 6,
            ),
          ),
        );
      }

      if (controller.filteredProducts.isEmpty) {
        return _buildEmptyState(isDarkMode);
      }

      return SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final product = controller.filteredProducts[index];
            final isExactMatch = controller.exactMatchProducts.contains(
              product,
            );
            final isStartsWithMatch = controller.startsWithProducts.contains(
              product,
            );

            return ProductCard(
              product: product,
              searchQuery: controller.searchQuery.value,
              isExactMatch: isExactMatch,
              isStartsWithMatch: isStartsWithMatch,
            );
          }, childCount: controller.filteredProducts.length),
        ),
      );
    });
  }

  Widget _buildShimmerCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE53935),
                strokeWidth: 2,
              ),
            ),
          ),
          // Content shimmer
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.searchQuery.value.isNotEmpty
                      ? Iconsax.search_normal_1
                      : Iconsax.box_1,
                  size: 56,
                  color:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                controller.searchQuery.value.isNotEmpty
                    ? 'No products found'
                    : 'No products available',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.searchQuery.value.isNotEmpty
                    ? 'Try different keywords or check spelling'
                    : 'Check back later for new products',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              if (controller.searchQuery.value.isNotEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.clearSearch,
                  icon: const Icon(Iconsax.close_circle, size: 18),
                  label: Text(
                    'Clear Search',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

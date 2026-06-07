// lib/App/Modules/Products/view/products_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Product_Details_Model/product_details_model.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());
    // Initialize CartController if not already initialized
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Cart Icon with Badge
          Obx(
            () => Stack(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.shopping_cart, size: 22),
                  onPressed: () {
                    final cartController = Get.find<CartController>();
                    cartController.loadCartItems();
                    Get.toNamed('/cart');
                  },
                ),
                if (Get.isRegistered<CartController>() &&
                    Get.find<CartController>().totalItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${Get.find<CartController>().totalItems}',
                        style: const TextStyle(
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
          ),
          // Connection Status
          Obx(
            () => Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          controller.isConnected.value
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    controller.isConnected.value ? 'Live' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          controller.isConnected.value
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: (value) => controller.searchProductsRealtime(value),
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search products by name...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(Iconsax.search_normal, size: 20),
                  suffixIcon: Obx(
                    () =>
                        controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Iconsax.close_circle, size: 18),
                              onPressed: () {
                                controller.clearSearch();
                              },
                            )
                            : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading products...'),
              ],
            ),
          );
        }

        return Column(
          children: [
            /// Categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final isSelected =
                      controller.selectedCategory.value == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => controller.changeCategory(category),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.red.shade50,
                      side: BorderSide(
                        color: isSelected ? Colors.red : Colors.grey.shade300,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Search Results Info with Detailed Breakdown
            Obx(
              () =>
                  controller.searchQuery.value.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.search_normal,
                                        size: 16,
                                        color: Colors.blue.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Found ${controller.filteredProducts.length} result(s) for "${controller.searchQuery.value}"',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          controller.clearSearch();
                                        },
                                        style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Clear',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red.shade600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Show breakdown of match types
                                  if (controller.exactMatchCount > 0 ||
                                      controller.startsWithCount > 0 ||
                                      controller.containsCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          if (controller.exactMatchCount > 0)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '🎯 Exact: ${controller.exactMatchCount}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green.shade800,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          if (controller.startsWithCount > 0)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '📝 Starts with: ${controller.startsWithCount}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.orange.shade800,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          if (controller.containsCount > 0)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.purple.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '🔍 Contains: ${controller.containsCount}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.purple.shade800,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),

            /// Products Grid with Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshProducts,
                color: Colors.red,
                child: CustomScrollView(
                  slivers: [
                    // Show categorized sections when searching
                    Obx(() {
                      if (controller.searchQuery.value.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Exact Matches Section
                          if (controller.exactMatchProducts.isNotEmpty)
                            _buildSearchSection(
                              title: 'Exact Matches',
                              icon: Iconsax.star1,
                              color: Colors.green,
                              count: controller.exactMatchProducts.length,
                            ),

                          // Starts With Section
                          if (controller.startsWithProducts.isNotEmpty)
                            _buildSearchSection(
                              title: 'Starts With',
                              icon: Iconsax.direct_right,
                              color: Colors.orange,
                              count: controller.startsWithProducts.length,
                            ),

                          // Contains Section
                          if (controller.containsProducts.isNotEmpty)
                            _buildSearchSection(
                              title: 'Contains',
                              icon: Iconsax.search_normal,
                              color: Colors.purple,
                              count: controller.containsProducts.length,
                            ),
                        ]),
                      );
                    }),

                    // Products Grid
                    Obx(() {
                      if (controller.filteredProducts.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  controller.searchQuery.value.isNotEmpty
                                      ? Iconsax.search_normal_1
                                      : Iconsax.box_1,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.searchQuery.value.isNotEmpty
                                      ? 'No products found'
                                      : 'No products available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (controller
                                    .searchQuery
                                    .value
                                    .isNotEmpty) ...[
                                  Text(
                                    'Try different keywords or check spelling',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: controller.clearSearch,
                                    icon: Icon(Iconsax.close_circle, size: 16),
                                    label: const Text('Clear Search'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ] else
                                  Text(
                                    'Pull down to refresh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = controller.filteredProducts[index];
                            final isExactMatch = controller.exactMatchProducts
                                .contains(product);
                            final isStartsWithMatch = controller
                                .startsWithProducts
                                .contains(product);

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  '/product-details',
                                  arguments: ProductDetailsModel(
                                    product: product,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      isExactMatch
                                          ? Border.all(
                                            color: Colors.green,
                                            width: 2,
                                          )
                                          : isStartsWithMatch
                                          ? Border.all(
                                            color: Colors.orange,
                                            width: 1.5,
                                          )
                                          : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _buildProductCard(
                                  product,
                                  controller.searchQuery.value,
                                  isExactMatch: isExactMatch,
                                ),
                              ),
                            );
                          }, childCount: controller.filteredProducts.length),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchSection({
    required String title,
    required IconData icon,
    required Color color,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    ProductModel product,
    String searchQuery, {
    bool isExactMatch = false,
  }) {
    final cartController = Get.find<CartController>();
    String imageUrl = product.images.isNotEmpty ? product.images.first : '';

    // Fix image URL if needed
    if (imageUrl.contains('token=') &&
        (imageUrl.endsWith('token=') || imageUrl.contains('token=&'))) {
      imageUrl = imageUrl.replaceAll(RegExp(r'&token=[^&]*'), '');
      imageUrl = imageUrl.replaceAll(RegExp(r'\?token=[^&]*'), '');
    }

    // Highlight search text in product name
    Widget productName = Text(
      product.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    );

    if (searchQuery.isNotEmpty &&
        product.name.toLowerCase().contains(searchQuery.toLowerCase())) {
      final text = product.name;
      final query = searchQuery.toLowerCase();
      final startIndex = text.toLowerCase().indexOf(query);
      final endIndex = startIndex + query.length;

      productName = RichText(
        text: TextSpan(
          text: text.substring(0, startIndex),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: text.substring(startIndex, endIndex),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.red,
                backgroundColor: Colors.yellow,
              ),
            ),
            TextSpan(
              text: text.substring(endIndex),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isExactMatch ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isExactMatch)
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.star1, color: Colors.white, size: 10),
                  SizedBox(width: 4),
                  Text(
                    'Best Match',
                    style: TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child:
                  imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.image,
                                    size: 40,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      )
                      : Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Iconsax.image,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productName,
                const SizedBox(height: 4),
                // Rating Row
                Row(
                  children: [
                    const Icon(Iconsax.star1, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (product.reviews > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviews})',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                // Price Row
                Row(
                  children: [
                    Text(
                      "₹${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    if (product.originalPrice > product.price) ...[
                      const SizedBox(width: 8),
                      Text(
                        "₹${product.originalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${product.discount.toStringAsFixed(0)}% OFF",
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Weight Variants
                if (product.hasWeightVariants) ...[
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          product.weightVariants.take(3).map((weight) {
                            return Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                weight,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  if (product.weightVariants.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '+${product.weightVariants.length - 3} more',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 8),
                // Add to Cart Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (product.isInStock && product.stock > 0) &&
                                  !cartController.isUpdating.value
                              ? () {
                                // Show weight variant selection if multiple options
                                if (product.hasWeightVariants &&
                                    product.weightVariants.length > 1) {
                                  _showWeightVariantBottomSheet(product);
                                } else {
                                  // Add to cart directly
                                  cartController.addToCart(
                                    product: product,
                                    quantity: 1,
                                    selectedWeight:
                                        product.hasWeightVariants
                                            ? product.weightVariants.first
                                            : null,
                                  );
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            product.isInStock && product.stock > 0
                                ? Colors.red
                                : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          cartController.isUpdating.value
                              ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                product.isInStock && product.stock > 0
                                    ? 'Add to Cart'
                                    : 'Out of Stock',
                                style: const TextStyle(fontSize: 12),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to show weight variant selection
  void _showWeightVariantBottomSheet(ProductModel product) {
    final cartController = Get.find<CartController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Weight',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a weight variant for ${product.name}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ...product.weightVariants.map((weight) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Iconsax.weight,
                    size: 20,
                    color: Colors.red.shade700,
                  ),
                ),
                title: Text(
                  weight,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    if (product.originalPrice > product.price)
                      Text(
                        "₹${product.originalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Get.back();
                  cartController.addToCart(
                    product: product,
                    quantity: 1,
                    selectedWeight: weight,
                  );
                },
              );
            }).toList(),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

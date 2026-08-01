// lib/App/Modules/Products/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';
import 'package:racharuchi/App/Models/Product_Details_Model/product_details_model.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String searchQuery;
  final bool isExactMatch;
  final bool isStartsWithMatch;

  const ProductCard({
    super.key,
    required this.product,
    required this.searchQuery,
    this.isExactMatch = false,
    this.isStartsWithMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String imageUrl = product.images.isNotEmpty ? product.images.first : '';

    // Fix image URL if needed
    if (imageUrl.contains('token=') &&
        (imageUrl.endsWith('token=') || imageUrl.contains('token=&'))) {
      imageUrl = imageUrl.replaceAll(RegExp(r'&token=[^&]*'), '');
      imageUrl = imageUrl.replaceAll(RegExp(r'\?token=[^&]*'), '');
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/product-details',
          arguments: ProductDetailsModel(product: product),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border:
              isExactMatch
                  ? Border.all(color: Colors.green, width: 2)
                  : isStartsWithMatch
                  ? Border.all(color: Colors.orange, width: 1.5)
                  : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
                isExactMatch
                    ? Colors.green.shade50
                    : (isDarkMode ? Colors.grey.shade800 : Colors.white),
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
              if (isExactMatch) _buildBestMatchBadge(),
              Expanded(child: _buildProductImage(imageUrl, isDarkMode)),
              _buildProductInfo(cartController, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestMatchBadge() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.star1, color: Colors.white, size: 10),
          const SizedBox(width: 4),
          Text(
            'Best Match',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imageUrl, bool isDarkMode) {
    return ClipRRect(
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
                      color:
                          isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color:
                          isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.image,
                            size: 40,
                            color:
                                isDarkMode
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image not available',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
              )
              : Container(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                child: Icon(
                  Iconsax.image,
                  size: 40,
                  color:
                      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
              ),
    );
  }

  Widget _buildProductInfo(CartController cartController, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductName(isDarkMode),
          const SizedBox(height: 4),
          _buildRating(),
          const SizedBox(height: 6),
          _buildPrice(),
          if (product.hasWeightVariants) ...[
            const SizedBox(height: 6),
            _buildWeightVariants(),
          ],
          const SizedBox(height: 8),
          _buildAddToCartButton(cartController, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildProductName(bool isDarkMode) {
    if (searchQuery.isNotEmpty &&
        product.name.toLowerCase().contains(searchQuery.toLowerCase())) {
      final text = product.name;
      final query = searchQuery.toLowerCase();
      final startIndex = text.toLowerCase().indexOf(query);
      final endIndex = startIndex + query.length;

      return RichText(
        text: TextSpan(
          text: text.substring(0, startIndex),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          children: [
            TextSpan(
              text: text.substring(startIndex, endIndex),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.red,
                backgroundColor: Colors.yellow,
              ),
            ),
            TextSpan(
              text: text.substring(endIndex),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text(
      product.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Iconsax.star1, color: Colors.amber, size: 14),
        const SizedBox(width: 4),
        Text(
          product.rating.toStringAsFixed(1),
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        if (product.reviews > 0) ...[
          const SizedBox(width: 4),
          Text(
            '(${product.reviews})',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPrice() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 2,
      children: [
        Text(
          "₹${product.price.toStringAsFixed(2)}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE53935),
            fontSize: 14,
          ),
        ),
        if (product.originalPrice > product.price) ...[
          Text(
            "₹${product.originalPrice.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              decoration: TextDecoration.lineThrough,
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${product.discount.toStringAsFixed(0)}% OFF",
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeightVariants() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            product.weightVariants.take(3).map((weight) {
              return Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: Text(
                  weight,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: Colors.grey.shade700,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAddToCartButton(CartController cartController, bool isDarkMode) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              (product.isInStock && product.stock > 0) &&
                      !cartController.isUpdating.value
                  ? () {
                    if (product.hasWeightVariants &&
                        product.weightVariants.length > 1) {
                      _showWeightVariantBottomSheet(product);
                    } else {
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
                    ? const Color(0xFFE53935)
                    : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
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
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }

  void _showWeightVariantBottomSheet(ProductModel product) {
    final cartController = Get.find<CartController>();
    final isDarkMode = Get.isDarkMode ?? false;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Weight',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a weight variant for ${product.name}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ...product.weightVariants.map((weight) {
              return _buildWeightOption(
                weight,
                product,
                cartController,
                isDarkMode,
              );
            }),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor:
                    isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _buildWeightOption(
    String weight,
    ProductModel product,
    CartController cartController,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        Get.back();
        cartController.addToCart(
          product: product,
          quantity: 1,
          selectedWeight: weight,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.weight,
                size: 22,
                color: const Color(0xFFE53935),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weight,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    "In Stock",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${product.price.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE53935),
                    fontSize: 16,
                  ),
                ),
                if (product.originalPrice > product.price)
                  Text(
                    "₹${product.originalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

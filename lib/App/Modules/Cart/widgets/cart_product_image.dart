// lib/App/Modules/Cart/widgets/cart_product_image.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CartProductImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final bool showBadge;

  const CartProductImage({
    super.key,
    required this.imageUrl,
    this.width = 70,
    this.height = 70,
    this.borderRadius = 12,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(isDarkMode),
            errorWidget: (context, url, error) => _buildErrorWidget(isDarkMode),
          ),
        ),
        if (showBadge) _buildBadge(),
      ],
    );
  }

  Widget _buildPlaceholder(bool isDarkMode) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: const Color(0xFFE53935),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(bool isDarkMode) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.gallery,
            size: 24,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            'No Image',
            style: GoogleFonts.poppins(
              fontSize: 8,
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'NEW',
          style: GoogleFonts.poppins(
            fontSize: 7,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Alternative: CartProductImage with Discount Badge
class CartProductImageWithDiscount extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final double? discount;

  const CartProductImageWithDiscount({
    super.key,
    required this.imageUrl,
    this.width = 70,
    this.height = 70,
    this.borderRadius = 12,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(isDarkMode),
            errorWidget: (context, url, error) => _buildErrorWidget(isDarkMode),
          ),
        ),
        if (discount != null && discount! > 0) _buildDiscountBadge(),
      ],
    );
  }

  Widget _buildPlaceholder(bool isDarkMode) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: const Color(0xFFE53935),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(bool isDarkMode) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.gallery,
            size: 24,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            'No Image',
            style: GoogleFonts.poppins(
              fontSize: 8,
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Positioned(
      bottom: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '${discount!.toInt()}% OFF',
          style: GoogleFonts.poppins(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Alternative: CartProductImage with Stock Status
class CartProductImageWithStatus extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final bool isInStock;

  const CartProductImageWithStatus({
    super.key,
    required this.imageUrl,
    this.width = 70,
    this.height = 70,
    this.borderRadius = 12,
    this.isInStock = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(isDarkMode),
            errorWidget: (context, url, error) => _buildErrorWidget(isDarkMode),
          ),
        ),
        if (!isInStock) _buildOutOfStockOverlay(),
      ],
    );
  }

  Widget _buildPlaceholder(bool isDarkMode) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: const Color(0xFFE53935),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(bool isDarkMode) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.gallery,
            size: 24,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            'No Image',
            style: GoogleFonts.poppins(
              fontSize: 8,
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutOfStockOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            'Out of Stock',
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

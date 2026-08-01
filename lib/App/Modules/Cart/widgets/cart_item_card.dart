// lib/App/Modules/Cart/widgets/cart_item_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:racharuchi/App/Models/Cart_Model/cart_models.dart';
import 'package:racharuchi/App/Modules/Cart/controller/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final int index;
  final CartController controller;

  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProductImage(isDarkMode),
          const SizedBox(width: 14),
          Expanded(child: _buildProductDetails(isDarkMode)),
          _buildQuantityControls(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildProductImage(bool isDarkMode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: item.imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              width: 70,
              height: 70,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFE53935),
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => Container(
              width: 70,
              height: 70,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
              child: Icon(
                Iconsax.gallery,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
            ),
      ),
    );
  }

  Widget _buildProductDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVegIndicator(isDarkMode),
        const SizedBox(height: 6),
        _buildProductName(isDarkMode),
        const SizedBox(height: 4),
        _buildBrand(isDarkMode),
        const SizedBox(height: 6),
        _buildPrice(isDarkMode),
      ],
    );
  }

  Widget _buildVegIndicator(bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: item.isVeg ? Colors.green : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: item.isVeg ? Colors.green.shade700 : Colors.red.shade700,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: item.isVeg ? Colors.green.shade700 : Colors.red.shade700,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.restaurant,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (item.selectedWeight != null && item.selectedWeight!.isNotEmpty) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.selectedWeight!,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProductName(bool isDarkMode) {
    return Text(
      item.displayName,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBrand(bool isDarkMode) {
    if (item.brand == null || item.brand!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      item.brand!,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPrice(bool isDarkMode) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 2,
      children: [
        Text(
          '₹${item.price.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: const Color(0xFFE53935),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'In Stock',
            style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildQuantityButtons(isDarkMode),
        const SizedBox(height: 8),
        _buildDeleteButton(isDarkMode),
      ],
    );
  }

  Widget _buildQuantityButtons(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade700
                : const Color(0xFFE53935).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade600 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Iconsax.minus,
            onTap: () => controller.decrementQuantity(index),
            isDarkMode: isDarkMode,
          ),
          SizedBox(
            width: 28,
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Iconsax.add,
            onTap: () => controller.incrementQuantity(index),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return IconButton(
      icon: Icon(icon, size: 14),
      onPressed: onTap,
      color: isDarkMode ? Colors.grey.shade300 : const Color(0xFFE53935),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      splashRadius: 14,
    );
  }

  Widget _buildDeleteButton(bool isDarkMode) {
    return GestureDetector(
      onTap: () => controller.removeItem(index),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Iconsax.trash,
          size: 14,
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

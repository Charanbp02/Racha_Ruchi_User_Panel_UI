// lib/App/Modules/Products/widgets/product_search_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class ProductSearchBar extends StatelessWidget {
  final ProductsController controller;

  const ProductSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller.searchController,
          onChanged: (value) => controller.searchProductsRealtime(value),
          autofocus: false,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Search products by name...',
            hintStyle: GoogleFonts.poppins(
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Iconsax.search_normal,
              size: 20,
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
            suffixIcon: Obx(
              () =>
                  controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color:
                              isDarkMode
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade500,
                        ),
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
    );
  }
}

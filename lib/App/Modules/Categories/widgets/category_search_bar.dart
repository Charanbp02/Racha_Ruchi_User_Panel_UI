// lib/App/Modules/Categories/widgets/category_search_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';

class CategorySearchBar extends StatelessWidget {
  final String hintText;
  final EdgeInsetsGeometry padding;
  final bool autoFocus;
  final VoidCallback? onSearchTap;

  const CategorySearchBar({
    super.key,
    this.hintText = 'Search categories...',
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.autoFocus = false,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Search icon
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                Icons.search_rounded,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            // Search input
            Expanded(
              child: Obx(() {
                final query = controller.searchQuery.value;
                return TextField(
                  autofocus: autoFocus,
                  onChanged: controller.updateSearch,
                  onTap: onSearchTap,
                  controller: TextEditingController(text: query)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: query.length),
                    ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color:
                          isDarkMode
                              ? Colors.grey.shade500
                              : Colors.grey.shade500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    suffixIcon:
                        query.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                controller.clearSearch();
                                // Clear the text field
                                final textField = TextEditingController(
                                  text: '',
                                );
                                textField.clear();
                              },
                              icon: Icon(
                                Icons.close_rounded,
                                size: 20,
                                color:
                                    isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                              ),
                              splashRadius: 20,
                            )
                            : null,
                  ),
                );
              }),
            ),
            // Optional microphone / voice search button
            if (false) // Enable if voice search is available
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {
                    // Implement voice search
                  },
                  icon: Icon(
                    Icons.keyboard_voice_rounded,
                    color:
                        isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                    size: 22,
                  ),
                  splashRadius: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

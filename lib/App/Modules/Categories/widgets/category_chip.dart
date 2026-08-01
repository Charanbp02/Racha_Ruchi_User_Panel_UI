// lib/App/Modules/Categories/widgets/category_chip.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChip extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Check if this is the "All" category
    final bool isAllCategory = category['id'] == 'all';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE53935) : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or emoji for the category
            if (isAllCategory) ...[
              Icon(
                Icons.apps_rounded,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
            ] else if (_hasEmoji) ...[
              Text(
                category['emoji'] ?? '📁',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
            ] else if (_hasImage) ...[
              _buildCategoryImage(),
              const SizedBox(width: 6),
            ],
            // Category name
            _buildCategoryName(isAllCategory, isSelected),
          ],
        ),
      ),
    );
  }

  bool get _hasImage {
    return category['imageUrl'] != null &&
        category['imageUrl'].toString().isNotEmpty;
  }

  bool get _hasEmoji {
    return category['emoji'] != null && category['emoji'].toString().isNotEmpty;
  }

  Widget _buildCategoryImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        category['imageUrl'],
        width: 22,
        height: 22,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.category_rounded,
              size: 14,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryName(bool isAllCategory, bool isSelected) {
    return Text(
      category['name'] ?? '',
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color:
            isSelected
                ? Colors.white
                : isAllCategory
                ? Colors.grey.shade700
                : Colors.black87,
        letterSpacing: isSelected ? 0.2 : 0.0,
      ),
    );
  }
}

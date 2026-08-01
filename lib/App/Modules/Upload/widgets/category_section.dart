// lib/App/Modules/Upload/widgets/category_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class CategorySection extends StatelessWidget {
  final UploadController controller;

  const CategorySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }
          return _buildCategoryFields();
        }),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Column(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFE53935),
              ),
            ),
            SizedBox(height: 12),
            Text('Loading categories...'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Field
        _buildSearchField(),
        const SizedBox(height: 16),

        // Main Category Dropdown
        _buildMainCategoryDropdown(),
        const SizedBox(height: 16),

        // SubCategory Dropdown
        _buildSubCategoryDropdown(),
        const SizedBox(height: 12),

        // Selected category info
        _buildSelectedCategoryInfo(),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.categorySearchController,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: 'Search categories...',
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Colors.grey.shade500,
          size: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: Obx(() {
          if (controller.categorySearchQuery.value.isNotEmpty) {
            return IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: Colors.grey.shade500,
              ),
              onPressed: () {
                controller.categorySearchController.clear();
                controller.searchCategory('');
              },
              splashRadius: 20,
            );
          }
          return const SizedBox.shrink(); // ✅ Fixed: Return widget instead of null
        }),
      ),
      onChanged: controller.searchCategory,
    );
  }

  Widget _buildMainCategoryDropdown() {
    return Obx(() {
      final categories = controller.filteredCategories;

      if (categories.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Center(
            child: Text(
              controller.categorySearchQuery.value.isNotEmpty
                  ? 'No categories found'
                  : 'No categories available',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }

      final uniqueCategories = categories.toSet().toList();
      final String currentValue = controller.selectedCategoryId.value;
      final bool valueExists = uniqueCategories.any(
        (cat) => cat.id == currentValue,
      );

      if (!valueExists && currentValue.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.selectedCategoryId.value == currentValue) {
            controller.clearCategorySelection();
          }
        });
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Main Category *',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            key: ValueKey('category_dropdown_${uniqueCategories.length}'),
            initialValue: valueExists ? currentValue : null,
            decoration: InputDecoration(
              hintText: 'Select Main Category',
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items:
                uniqueCategories.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.id,
                    child: Row(
                      children: [
                        Text(e.icon, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            e.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectCategory(value);
              }
            },
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
              size: 28,
            ),
            dropdownColor: Colors.white,
            elevation: 8,
            style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
          ),
        ],
      );
    });
  }

  Widget _buildSubCategoryDropdown() {
    return Obx(() {
      if (controller.selectedCategoryId.value.isEmpty) {
        return const SizedBox();
      }

      if (controller.subCategories.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFE53935),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Loading subcategories...',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }

      final uniqueSubCategories = controller.subCategories.toSet().toList();
      final String currentSubValue = controller.selectedSubCategoryId.value;
      final bool subValueExists = uniqueSubCategories.any(
        (sub) => sub.id == currentSubValue,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sub Category *',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            key: ValueKey('subcategory_dropdown_${uniqueSubCategories.length}'),
            initialValue: subValueExists ? currentSubValue : null,
            decoration: InputDecoration(
              hintText: 'Select Sub Category',
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items:
                uniqueSubCategories.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(
                      e.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectSubCategory(value);
              }
            },
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
              size: 28,
            ),
            dropdownColor: Colors.white,
            elevation: 8,
            style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
          ),
        ],
      );
    });
  }

  Widget _buildSelectedCategoryInfo() {
    return Obx(() {
      if (controller.selectedCategoryId.value.isEmpty) {
        return const SizedBox();
      }

      final bool hasSubCategory =
          controller.selectedSubCategoryId.value.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              hasSubCategory
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFF4757).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                hasSubCategory
                    ? Colors.green.shade300
                    : const Color(0xFFFF4757).withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasSubCategory ? Icons.check_circle : Icons.warning_amber_rounded,
              color: hasSubCategory ? Colors.green : const Color(0xFFFF4757),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.selectedCategoryName.value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (controller.selectedSubCategoryName.value.isNotEmpty)
                    Text(
                      '→ ${controller.selectedSubCategoryName.value}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  if (controller.selectedSubCategoryName.value.isEmpty)
                    Text(
                      'Please select a subcategory',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFFF4757),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: controller.clearCategorySelection,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

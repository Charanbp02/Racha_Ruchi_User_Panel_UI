// lib/App/Modules/Products/widgets/search_results_info.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Products/controller/products_controller.dart';

class SearchResultsInfo extends StatelessWidget {
  final ProductsController controller;

  const SearchResultsInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.searchQuery.value.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
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
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.clearSearch,
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Clear',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.red.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildMatchBreakdown(),
                    ],
                  ),
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildMatchBreakdown() {
    return Obx(() {
      if (controller.exactMatchCount > 0 ||
          controller.startsWithCount > 0 ||
          controller.containsCount > 0) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (controller.exactMatchCount > 0)
                _buildMatchChip(
                  label: '🎯 Exact: ${controller.exactMatchCount}',
                  color: Colors.green,
                ),
              if (controller.startsWithCount > 0)
                _buildMatchChip(
                  label: '📝 Starts with: ${controller.startsWithCount}',
                  color: Colors.orange,
                ),
              if (controller.containsCount > 0)
                _buildMatchChip(
                  label: '🔍 Contains: ${controller.containsCount}',
                  color: Colors.purple,
                ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildMatchChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// lib/App/Modules/Product_Details/widgets/weight_variants_selector.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_details_controller.dart';

class WeightVariantsSelector extends StatelessWidget {
  final ProductDetailsController controller;

  const WeightVariantsSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final variants = controller.productModel.weightVariants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Weight",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                variants.map((weight) {
                  final isSelected =
                      controller.selectedWeight ==
                      weight; // Use getter without .value
                  return _buildWeightChip(weight, isSelected);
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightChip(String weight, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectWeight(weight),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffEF4444) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xffEF4444) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          weight,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

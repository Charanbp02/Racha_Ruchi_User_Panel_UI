// lib/App/Modules/Upload/widgets/ingredient_list.dart
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class IngredientList extends StatelessWidget {
  final UploadController controller;

  const IngredientList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.ingredients.isEmpty ? _buildEmptyState() : _buildList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.note, color: Colors.grey.shade400, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'No ingredients added yet',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add ingredients for your recipe',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.ingredients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ingredient = controller.ingredients[index];
        return _buildIngredientItem(ingredient, index);
      },
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          _buildIcon(ingredient.name),
          const SizedBox(width: 12),
          Expanded(child: _buildInfo(ingredient)),
          _buildDeleteButton(index),
        ],
      ),
    );
  }

  Widget _buildIcon(String name) {
    // Get first letter for avatar
    final String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(Ingredient ingredient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingredient.name,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (ingredient.quantity.isNotEmpty)
          Text(
            ingredient.quantity,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteButton(int index) {
    return IconButton(
      onPressed: () => controller.removeIngredient(index),
      splashRadius: 20,
      padding: const EdgeInsets.all(4),
      icon: Icon(Icons.close_rounded, size: 20, color: Colors.grey.shade400),
      hoverColor: Colors.grey.shade100,
    );
  }
}

// Alternative: Animated Ingredient List
class AnimatedIngredientList extends StatelessWidget {
  final UploadController controller;

  const AnimatedIngredientList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.ingredients.isEmpty ? _buildEmptyState() : _buildList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.note, color: Colors.grey.shade400, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'No ingredients added yet',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add ingredients for your recipe',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.ingredients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ingredient = controller.ingredients[index];
        return _buildAnimatedIngredientItem(ingredient, index);
      },
    );
  }

  Widget _buildAnimatedIngredientItem(Ingredient ingredient, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(ingredient.name),
          const SizedBox(width: 12),
          Expanded(child: _buildInfo(ingredient)),
          _buildDeleteButton(index),
        ],
      ),
    );
  }

  Widget _buildIcon(String name) {
    final String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(Ingredient ingredient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingredient.name,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (ingredient.quantity.isNotEmpty)
          Text(
            ingredient.quantity,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteButton(int index) {
    return GestureDetector(
      onTap: () => controller.removeIngredient(index),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade600),
      ),
    );
  }
}

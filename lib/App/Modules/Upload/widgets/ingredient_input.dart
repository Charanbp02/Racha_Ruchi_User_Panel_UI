// lib/App/Modules/Upload/widgets/ingredient_input.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class IngredientInput extends StatelessWidget {
  final UploadController controller;

  const IngredientInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          _buildIngredientNameField(),
          const SizedBox(width: 4),
          _buildDivider(),
          const SizedBox(width: 4),
          _buildQuantityField(),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildIngredientNameField() {
    return Expanded(
      flex: 3,
      child: TextField(
        controller: controller.ingredientTextController,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Ingredient name',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onSubmitted: (_) => controller.addIngredient(),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.grey.shade300);
  }

  Widget _buildQuantityField() {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: controller.ingredientQuantityController,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Quantity',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onSubmitted: (_) => controller.addIngredient(),
      ),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      onPressed: controller.addIngredient,
      splashRadius: 20,
      padding: const EdgeInsets.all(4),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}

// Alternative: Ingredient Input with Autocomplete
class IngredientInputWithSuggestions extends StatelessWidget {
  final UploadController controller;
  final List<String> suggestions;

  const IngredientInputWithSuggestions({
    super.key,
    required this.controller,
    this.suggestions = const [
      'Salt',
      'Pepper',
      'Sugar',
      'Flour',
      'Eggs',
      'Butter',
      'Milk',
      'Cream',
      'Cheese',
      'Garlic',
      'Onion',
      'Tomato',
      'Potato',
      'Rice',
      'Pasta',
      'Olive Oil',
      'Vegetable Oil',
      'Honey',
      'Vanilla',
      'Cinnamon',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          _buildIngredientNameField(),
          const SizedBox(width: 4),
          _buildDivider(),
          const SizedBox(width: 4),
          _buildQuantityField(),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildIngredientNameField() {
    return Expanded(
      flex: 3,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return suggestions.where((String option) {
            return option.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        },
        onSelected: (String selection) {
          controller.ingredientTextController.text = selection;
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Ingredient name',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onSubmitted: (_) => controller.addIngredient(),
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.grey.shade300);
  }

  Widget _buildQuantityField() {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: controller.ingredientQuantityController,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Quantity',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onSubmitted: (_) => controller.addIngredient(),
      ),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      onPressed: controller.addIngredient,
      splashRadius: 20,
      padding: const EdgeInsets.all(4),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}

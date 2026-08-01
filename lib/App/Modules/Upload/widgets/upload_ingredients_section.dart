// lib/App/Modules/Upload/widgets/ingredients_section.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/ingredient_input.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/ingredient_list.dart';

class IngredientsSection extends StatelessWidget {
  final UploadController controller;

  const IngredientsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IngredientInput(controller: controller),
        const SizedBox(height: 16),
        IngredientList(controller: controller),
      ],
    );
  }
}

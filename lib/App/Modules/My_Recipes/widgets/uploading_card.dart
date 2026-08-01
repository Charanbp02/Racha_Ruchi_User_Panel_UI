import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/My_Recipes/controller/my_recipes_controller.dart';

class UploadingCardWidget extends StatelessWidget {
  final MyRecipesController controller;

  const UploadingCardWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_upload, color: Color(0xFFE53935)),
              SizedBox(width: 10),
              Text(
                "Uploading Recipe...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => LinearProgressIndicator(value: controller.uploadProgress)),
          const SizedBox(height: 8),
          Obx(() => Text("${(controller.uploadProgress * 100).toInt()}%")),
        ],
      ),
    );
  }
}

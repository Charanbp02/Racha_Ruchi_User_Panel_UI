// lib/App/Modules/Upload/view/upload_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Upload/binding/upload_binding.dart';
import 'package:racharuchi/App/Modules/Upload/config/upload_constants.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/upload_app_bar.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/video_selection_section.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/text_input_field.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/upload_ingredients_section.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/category_section.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/upload_progress_overlay.dart';
import 'package:racharuchi/App/Modules/Upload/widgets/mini_progress_bar.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    UploadBinding().dependencies();
    final UploadController controller = Get.find<UploadController>();

    controller.onUploadMinimized = () {
      Get.back();
    };

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const UploadAppBar(),
      bottomNavigationBar: _buildUploadButton(controller),
      body: Obx(
        () => Stack(
          children: [
            _buildMainContent(controller),
            if (controller.isUploading.value &&
                !controller.isUploadMinimized.value)
              UploadProgressOverlay(controller: controller),
            if (controller.isUploading.value &&
                controller.isUploadMinimized.value)
              MiniProgressBar(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(UploadController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YouTube-style section header
          _buildSectionHeader(
            icon: Icons.video_library_rounded,
            title: 'Video',
            subtitle: 'Select a video to upload',
          ),
          const SizedBox(height: 12),
          VideoSelectionSection(controller: controller),

          const SizedBox(height: 24),

          // Title section
          _buildSectionHeader(
            icon: Icons.title_rounded,
            title: 'Title',
            subtitle: 'Give your video a catchy title',
          ),

          TextInputField(
            label: '',
            hintText: 'e.g., Creamy Garlic Pasta',
            maxLength: UploadConstants.maxTitleLength,
            onChanged: (value) {
              controller.videoTitle.value = value;
              controller.checkUploadEnabled();
            },
          ),

          const SizedBox(height: 24),

          // Description section
          _buildSectionHeader(
            icon: Icons.description_rounded,
            title: 'Description',
            subtitle: 'Share the story behind your recipe',
          ),

          TextInputField(
            label: '',
            hintText: 'Share the story behind your recipe...',
            maxLines: 4,
            maxLength: UploadConstants.maxDescriptionLength,
            onChanged: (value) => controller.videoDescription.value = value,
          ),

          const SizedBox(height: 24),

          // Ingredients section
          _buildSectionHeader(
            icon: Icons.restaurant_rounded,
            title: 'Ingredients',
            subtitle: 'List all the ingredients needed',
          ),
          const SizedBox(height: 12),
          IngredientsSection(controller: controller),

          const SizedBox(height: 24),

          // Category section
          _buildSectionHeader(
            icon: Icons.category_rounded,
            title: 'Category',
            subtitle: 'Choose a category for your video',
          ),
          const SizedBox(height: 12),
          CategorySection(controller: controller),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadButton(UploadController controller) {
    return Obx(() {
      final isEnabled = controller.isUploadEnabled.value;
      final isUploading = controller.isUploading.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicator when uploading
            if (isUploading) ...[
              SizedBox(
                height: 4,
                child: LinearProgressIndicator(
                  value: controller.uploadProgress.value / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFFE53935),
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Upload button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isEnabled && !isUploading
                        ? () => controller.uploadVideo()
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isEnabled
                          ? const Color(0xFFE53935)
                          : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isUploading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else if (isEnabled)
                      Icon(
                        Icons.cloud_upload_rounded,
                        size: 20,
                        color: Colors.white,
                      )
                    else
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    const SizedBox(width: 10),
                    Text(
                      isUploading
                          ? 'Uploading... ${controller.uploadProgress.value.toInt()}%'
                          : isEnabled
                          ? 'Upload Video'
                          : 'Complete all fields to upload',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isEnabled || isUploading
                                ? Colors.white
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// lib/App/Modules/Upload/widgets/mini_progress_bar.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class MiniProgressBar extends StatelessWidget {
  final UploadController controller;

  const MiniProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: controller.restoreUpload,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildThumbnail(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildProgressInfo()),
                  _buildCancelButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
        image:
            controller.selectedThumbnailUrl.value.isNotEmpty
                ? DecorationImage(
                  image: FileImage(File(controller.selectedThumbnailUrl.value)),
                  fit: BoxFit.cover,
                )
                : null,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child:
          controller.selectedThumbnailUrl.value.isEmpty
              ? Center(
                child: Icon(
                  Iconsax.video,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              )
              : null,
    );
  }

  Widget _buildProgressInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            controller.videoTitle.value.isNotEmpty
                ? controller.videoTitle.value
                : 'Uploading video...',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Obx(
                    () => Container(
                      height: 4,
                      width: Get.width * 0.6 * controller.uploadProgress.value,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => Text(
                '${(controller.uploadProgress.value * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(
          () => Row(
            children: [
              if (controller.uploadSpeed.value.isNotEmpty) ...[
                Icon(
                  Icons.speed_rounded,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  controller.uploadSpeed.value,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (controller.estimatedTimeRemaining.value.isNotEmpty) ...[
                Icon(
                  Icons.timer_rounded,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  controller.estimatedTimeRemaining.value,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: controller.cancelUpload,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade600),
      ),
    );
  }
}

// Alternative: Animated Mini Progress Bar
class AnimatedMiniProgressBar extends StatelessWidget {
  final UploadController controller;

  const AnimatedMiniProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: controller.restoreUpload,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildThumbnail(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildProgressInfo()),
                  _buildCancelButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
        image:
            controller.selectedThumbnailUrl.value.isNotEmpty
                ? DecorationImage(
                  image: FileImage(File(controller.selectedThumbnailUrl.value)),
                  fit: BoxFit.cover,
                )
                : null,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child:
          controller.selectedThumbnailUrl.value.isEmpty
              ? Center(
                child: Icon(
                  Iconsax.video,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              )
              : null,
    );
  }

  Widget _buildProgressInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            controller.videoTitle.value.isNotEmpty
                ? controller.videoTitle.value
                : 'Uploading video...',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 4,
                      width: Get.width * 0.6 * controller.uploadProgress.value,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => Text(
                '${(controller.uploadProgress.value * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(
          () => Row(
            children: [
              if (controller.uploadSpeed.value.isNotEmpty) ...[
                Icon(
                  Icons.speed_rounded,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  controller.uploadSpeed.value,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (controller.estimatedTimeRemaining.value.isNotEmpty) ...[
                Icon(
                  Icons.timer_rounded,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  controller.estimatedTimeRemaining.value,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: controller.cancelUpload,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade600),
      ),
    );
  }
}

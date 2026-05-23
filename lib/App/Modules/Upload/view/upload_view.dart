import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/binding/upload_binding.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    UploadBinding().dependencies();
    final UploadController controller = Get.find<UploadController>();

    // Set callback for when upload is minimized
    controller.onUploadMinimized = () {
      // Return to previous screen but keep upload running
      Get.back();
    };

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Share Your Recipe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Iconsax.arrow_left,
              color: Color(0xFF1A1A1A),
              size: 20,
            ),
          ),
          onPressed: () {
            // If uploading, minimize instead of cancel
            if (controller.isUploading.value) {
              controller.minimizeUpload();
            } else {
              controller.cancelUpload();
            }
          },
        ),
        actions: [
          Obx(
            () => Container(
              margin: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed:
                    controller.isUploading.value
                        ? null
                        : () => controller.uploadVideo(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isUploading.value
                          ? Colors.grey.shade300
                          : const Color(0xFFFF4757),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color:
                        controller.isUploading.value
                            ? Colors.grey.shade600
                            : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVideoSelection(controller),
                  const SizedBox(height: 24),
                  _buildTitleInput(controller),
                  const SizedBox(height: 20),
                  _buildDescriptionInput(controller),
                  const SizedBox(height: 24),
                  _buildIngredientsSection(controller),
                  const SizedBox(height: 24),
                  _buildCategorySection(controller),
                  const SizedBox(height: 24),
                  _buildTagsSection(controller),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // Full screen upload overlay
            if (controller.isUploading.value &&
                !controller.isUploadMinimized.value)
              _buildUploadProgress(controller),
            // Mini progress bar at bottom (Instagram style)
            if (controller.isUploading.value &&
                controller.isUploadMinimized.value)
              _buildMiniProgressBar(controller),
          ],
        ),
      ),
    );
  }

  // Instagram-style mini progress bar at bottom
  Widget _buildMiniProgressBar(UploadController controller) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => controller.restoreUpload(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Thumbnail preview
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      image:
                          controller.selectedThumbnailUrl.value.isNotEmpty
                              ? DecorationImage(
                                image: FileImage(
                                  File(controller.selectedThumbnailUrl.value),
                                ),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        controller.selectedThumbnailUrl.value.isEmpty
                            ? const Icon(
                              Iconsax.video,
                              size: 20,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  // Progress info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            'Uploading ${controller.videoTitle.value.isNotEmpty ? controller.videoTitle.value : 'video'}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Stack(
                          children: [
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                            Obx(
                              () => Container(
                                height: 3,
                                width:
                                    Get.width *
                                    0.7 *
                                    controller.uploadProgress.value,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0095F6),
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Obx(
                          () => Text(
                            '${(controller.uploadProgress.value * 100).toInt()}% • ${_getUploadStatus(controller.uploadProgress.value)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Cancel button
                  GestureDetector(
                    onTap: () => controller.cancelUpload(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.close_circle,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getUploadStatus(double progress) {
    if (progress < 0.10) return 'Compressing...';
    if (progress < 0.60) return 'Uploading...';
    if (progress < 0.80) return 'Processing...';
    if (progress < 0.95) return 'Finalizing...';
    return 'Almost done';
  }

  Widget _buildUploadProgress(UploadController controller) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: controller.uploadProgress.value),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            // Determine current step based on progress
            String statusText = 'Preparing...';
            if (value < 0.10) {
              statusText = 'Compressing video...';
            } else if (value < 0.60) {
              statusText = 'Uploading video...';
            } else if (value < 0.80) {
              statusText = 'Uploading thumbnail...';
            } else if (value < 0.95) {
              statusText = 'Saving recipe...';
            } else {
              statusText = 'Almost done!';
            }

            return GestureDetector(
              onTap: () => controller.minimizeUpload(),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular Progress Indicator
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: value,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF0095F6),
                            ),
                          ),
                          Obx(
                            () => Text(
                              '${(controller.uploadProgress.value * 100).toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xFF262626),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Uploading...',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF262626),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Minimize and Cancel buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => controller.minimizeUpload(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.grey.shade50,
                            ),
                            child: Text(
                              'Minimize',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextButton(
                            onPressed: () => controller.cancelUpload(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.red.shade50,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoTypeIndicator(UploadController controller) {
    return Obx(() {
      if (controller.videoDurationInSeconds.value == 0) {
        return const SizedBox.shrink();
      }

      final isShorts = controller.videoType.value == 'shorts';
      final durationDisplay = controller.videoDuration.value;
      final durationInSeconds = controller.videoDurationInSeconds.value;

      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isShorts
                    ? [const Color(0xFF4A90E2), const Color(0xFF357ABD)]
                    : [const Color(0xFFFF4757), const Color(0xFFE63946)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isShorts
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFFFF4757))
                  .withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isShorts ? Iconsax.video_vertical : Iconsax.video,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isShorts ? 'YouTube Shorts' : 'Long Video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Duration: $durationDisplay ($durationInSeconds seconds)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isShorts)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '#Shorts',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildVideoSelection(UploadController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recipe Video',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  controller.selectedVideoPath.isEmpty
                      ? _buildVideoPicker(controller)
                      : _buildVideoPreview(controller),
            ),
          ),
          _buildVideoTypeIndicator(controller),
        ],
      ),
    );
  }

  Widget _buildVideoPicker(UploadController controller) {
    return InkWell(
      onTap: () => controller.pickVideo(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4757).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.video_add,
                size: 40,
                color: Color(0xFFFF4757),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap to select video',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'MP4, MOV • Max 25 minutes',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview(UploadController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        controller.videoPlayerController.value != null &&
                controller.videoPlayerController.value!.value.isInitialized
            ? VideoPlayer(controller.videoPlayerController.value!)
            : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () => controller.toggleVideoPlay(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                controller.isVideoPlaying.value ? Iconsax.pause : Iconsax.play5,
                color: const Color(0xFFFF4757),
                size: 32,
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () => controller.pickVideo(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Iconsax.edit_2,
                color: Color(0xFFFF4757),
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: controller.ingredientTextController,
                  decoration: InputDecoration(
                    hintText: 'Ingredient name',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: controller.ingredientQuantityController,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.addIngredient(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4757).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.add,
                    color: Color(0xFFFF4757),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.ingredients.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final ingredient = controller.ingredients[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4757).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.subtitle,
                        size: 16,
                        color: Color(0xFFFF4757),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ingredient.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (ingredient.quantity.isNotEmpty)
                            Text(
                              ingredient.quantity,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.removeIngredient(index),
                      icon: const Icon(
                        Iconsax.trash,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (controller.ingredients.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Iconsax.note, color: Colors.grey.shade400, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'No ingredients added yet',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add ingredients for your recipe',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitleInput(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recipe Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) => controller.videoTitle.value = value,
            maxLines: 1,
            maxLength: 100,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'e.g., Creamy Garlic Pasta',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionInput(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) => controller.videoDescription.value = value,
            maxLines: 3,
            maxLength: 500,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Share the story behind your recipe...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                controller.categories.map((category) {
                  final isSelected = category.isSelected;
                  return FilterChip(
                    avatar: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                    label: Text(
                      category.name,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    selected: isSelected,
                    onSelected:
                        (selected) => controller.selectCategory(category.id),
                    selectedColor: const Color(0xFFFF4757).withOpacity(0.1),
                    checkmarkColor: const Color(0xFFFF4757),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color:
                          isSelected
                              ? const Color(0xFFFF4757)
                              : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(UploadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Tags',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                controller.suggestedTags.map((tag) {
                  final isSelected = controller.selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () => controller.toggleTag(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFFF4757) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFFFF4757)
                                  : Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 5,
                            ),
                        ],
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        if (controller.selectedTags.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF4757).withOpacity(0.05),
                  const Color(0xFFFF4757).withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF4757).withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4757).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.tag,
                    size: 14,
                    color: Color(0xFFFF4757),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => Text(
                      'Selected: ${controller.selectedTags.join(" · ")}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

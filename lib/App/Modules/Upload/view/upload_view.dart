import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/binding/upload_binding.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';
import 'package:video_player/video_player.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    UploadBinding().dependencies();
    final UploadController controller = Get.find<UploadController>();

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
          onPressed: () => controller.cancelUpload(),
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
                  // Video Selection
                  _buildVideoSelection(controller),
                  const SizedBox(height: 24),

                  // Title Input
                  _buildTitleInput(controller),
                  const SizedBox(height: 20),

                  // Description Input
                  _buildDescriptionInput(controller),
                  const SizedBox(height: 24),

                  // Category Selection
                  _buildCategorySection(controller),
                  const SizedBox(height: 24),

                  // Tags Section
                  _buildTagsSection(controller),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Upload Progress
            if (controller.isUploading.value) _buildUploadProgress(controller),
          ],
        ),
      ),
    );
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
              'MP4, MOV • Max 5 minutes',
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

        // Gradient Overlay
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

        // Play/Pause Button
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

        // Change Video Button
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

  Widget _buildUploadProgress(UploadController controller) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: controller.uploadProgress.value),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4757), Color(0xFFFF6B6B)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4757).withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Iconsax.send_2,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Uploading Your Recipe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we process your video',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: Get.width * 0.6 * value,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF4757), Color(0xFFFF6B6B)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Text(
                      '${(controller.uploadProgress.value * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFFFF4757),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => controller.cancelUpload(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

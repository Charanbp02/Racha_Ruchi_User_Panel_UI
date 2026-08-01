// lib/App/Modules/All_Videos/view/videos_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';
import 'package:racharuchi/App/Modules/All_Videos/widgets/video_card.dart';
import 'package:racharuchi/App/Modules/All_Videos/widgets/empty_state.dart';
import 'package:racharuchi/App/Modules/All_Videos/widgets/video_options_sheet.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';

class VideosView extends StatelessWidget {
  const VideosView({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    // ✅ Check if controller already exists, if not create one
    final VideosController controller;
    if (Get.isRegistered<VideosController>()) {
      controller = Get.find<VideosController>();
    } else {
      controller = Get.put(VideosController());
    }

    return _buildVideoList(controller);
  }

  Widget _buildVideoList(VideosController controller) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final videos = controller.filteredVideos;
      final selectedCategory = controller.selectedCategory.value;

      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE53935),
            strokeWidth: 2,
          ),
        );
      }

      if (videos.isEmpty) {
        return const EmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Show category filter indicator (only when category is selected)
          if (embedded && selectedCategory != 'All') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_list,
                          size: 14,
                          color: Color(0xFFE53935),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Category: $selectedCategory',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.updateCategory('All');
                      // ✅ Update category controller selection
                      if (Get.isRegistered<CategoryController>()) {
                        final categoryController =
                            Get.find<CategoryController>();
                        categoryController.selectedIndex.value = 0;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Clear filter',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
          // ✅ Updated ListView with proper padding for YouTube-style feed
          ListView.builder(
            shrinkWrap: true,
            physics:
                embedded
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 16,
            ), // ✅ YouTube-style padding
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return VideoCard(
                video: video,
                onTap: () => controller.playVideo(video),
                onMenuTap: () => _showVideoOptions(video, controller),
              );
            },
          ),
        ],
      );
    });
  }

  void _showVideoOptions(VideoModel video, VideosController controller) {
    Get.bottomSheet(
      VideoOptionsSheet(video: video, controller: controller),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
    );
  }
}

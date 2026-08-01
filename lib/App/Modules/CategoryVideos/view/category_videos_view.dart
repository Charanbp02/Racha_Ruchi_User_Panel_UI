// lib/App/Modules/CategoryVideos/view/category_videos_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/CategoryVideos/controller/category_videos_controller.dart';
import 'package:racharuchi/App/Modules/CategoryVideos/widgets/category_video_card.dart';
import 'package:racharuchi/App/Modules/CategoryVideos/widgets/category_video_shimmer.dart';
import 'package:racharuchi/App/Modules/CategoryVideos/widgets/empty_category_state.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';

class CategoryVideosView extends StatelessWidget {
  const CategoryVideosView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<CategoryVideosController>()) {
      Get.put(CategoryVideosController());
    }

    final controller = Get.find<CategoryVideosController>();

    return Scaffold(
      appBar: _buildAppBar(context, controller),
      body: WillPopScope(
        onWillPop: () async {
          // ✅ Reset to "All" when going back
          _resetToAll();
          return true;
        },
        child: _buildBody(context, controller),
      ),
    );
  }

  void _resetToAll() {
    // ✅ Reset videos controller to "All"
    if (Get.isRegistered<VideosController>()) {
      final videosController = Get.find<VideosController>();
      videosController.resetToAll();
    }

    // ✅ Reset category controller to "All"
    if (Get.isRegistered<CategoryController>()) {
      final categoryController = Get.find<CategoryController>();
      categoryController.selectedIndex.value = 0;
    }
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    CategoryVideosController controller,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // ✅ Reset to "All" when going back via back button
          _resetToAll();
          Get.back();
        },
      ),
      title: Obx(() {
        return Row(
          children: [
            Text(
              controller.categoryIcon.value,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Text(
              controller.categoryName.value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        );
      }),
      actions: [
        Obx(() {
          if (controller.videos.isNotEmpty) {
            return IconButton(
              icon: const Icon(Iconsax.search_normal),
              onPressed: () => _showSearchDialog(context, controller),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: _buildCategoryInfo(controller),
      ),
    );
  }

  Widget _buildCategoryInfo(CategoryVideosController controller) {
    return Obx(() {
      final count = controller.videos.length;
      final filteredCount = controller.filteredVideos.length;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              count == 0
                  ? 'No videos'
                  : '$count ${count == 1 ? 'video' : 'videos'}',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            if (controller.searchQuery.value.isNotEmpty && count > 0) ...[
              Text(
                ' (showing $filteredCount)',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const Spacer(),
            if (controller.isLoading.value)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFE53935),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, CategoryVideosController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.videos.isEmpty) {
        return const CategoryVideoShimmer();
      }

      if (controller.videos.isEmpty) {
        return const EmptyCategoryState();
      }

      final videos = controller.filteredVideos;

      if (videos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.search_normal, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No videos found',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.clearSearch,
                child: const Text('Clear Search'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshVideos,
        color: const Color(0xFFE53935),
        child: ListView.builder(
          // ✅ YouTube-style padding - no horizontal padding
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return CategoryVideoCard(
              video: video,
              onTap: () {
                // ✅ Navigate to video player with callback to reset on return
                Get.toNamed('/video-player', arguments: video)?.then((_) {
                  _resetToAll();
                });
              },
              onChannelTap: () => controller.navigateToChannel(video.channelId),
            );
          },
        ),
      );
    });
  }

  void _showSearchDialog(
    BuildContext context,
    CategoryVideosController controller,
  ) {
    final searchController = TextEditingController();
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Search ${controller.categoryName.value}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  prefixIcon: const Icon(Iconsax.search_normal),
                  suffixIcon: Obx(() {
                    if (controller.searchQuery.value.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          controller.clearSearch();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: controller.updateSearch,
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.searchQuery.value.isNotEmpty) {
                  final results = controller.filteredVideos.length;
                  return Text(
                    '$results videos found',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.clearSearch();
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

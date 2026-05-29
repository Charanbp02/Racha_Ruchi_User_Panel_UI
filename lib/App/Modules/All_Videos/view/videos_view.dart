import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';
import 'package:share_plus/share_plus.dart';

class VideosView extends StatelessWidget {
  VideosView({super.key, this.embedded = false});
  final bool embedded;

  final VideosController controller = Get.put(VideosController());

  @override
  Widget build(BuildContext context) {
    return _buildVideoList();
  }

  Widget _buildVideoList() {
    final controller = Get.find<VideosController>();

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final videos = controller.filteredVideos;

      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE53935)),
        );
      }

      if (videos.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return _buildVideoCard(video, controller);
        },
      );
    });
  }

  Widget _reportOption({
    required String title,
    required String reason,
    required VideoModel video,
    required VideosController controller,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      onTap: () async {
        Get.back();

        await controller.reportVideo(video: video, reason: reason);

        Get.snackbar(
          'Reported',
          'Thanks for your feedback',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  Widget _buildVideoCard(VideoModel video, VideosController controller) {
    return GestureDetector(
      onTap: () => controller.playVideo(video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with duration overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    video.thumbnailUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE53935),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Iconsax.video,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.formattedDuration,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Video info row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel Avatar
                GestureDetector(
                  onTap: () => controller.navigateToChannel(video.channelId),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(video.channelAvatar),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
                const SizedBox(width: 12),

                // Video details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Channel name with verified badge
                      GestureDetector(
                        onTap:
                            () => controller.navigateToChannel(video.channelId),
                        child: Row(
                          children: [
                            Text(
                              video.channelName,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (video.isVerified) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Iconsax.verify,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Views and time
                      Text(
                        '${video.formattedViews} • ${video.formattedTimeAgo}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),

                      // Description preview
                      if (video.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          video.description,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Menu button
                IconButton(
                  onPressed: () => _showVideoOptions(video, controller),
                  icon: const Icon(Iconsax.more, color: Colors.grey),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.video_play, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No videos found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showVideoOptions(VideoModel video, VideosController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Iconsax.like, color: Colors.black87),
                title: const Text('Like'),
                onTap: () {
                  Get.back();
                  controller.likeVideo(video);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.share, color: Colors.black87),
                title: const Text('Share'),
                onTap: () async {
                  Get.back();

                  try {
                    await Share.share('''
🎥 ${video.title}

👨‍🍳 Channel: ${video.channelName}

${video.description}

Watch Video:
${video.videoUrl}
''');
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Unable to share video',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),

              ListTile(
                leading: const Icon(Iconsax.message, color: Colors.black87),
                title: const Text('Report'),
                onTap: () {
                  Get.back();

                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Report Video',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _reportOption(
                            title: 'Spam or misleading',
                            reason: 'spam',
                            video: video,
                            controller: controller,
                          ),

                          _reportOption(
                            title: 'Violence content',
                            reason: 'violence',
                            video: video,
                            controller: controller,
                          ),

                          _reportOption(
                            title: 'Hateful content',
                            reason: 'hate',
                            video: video,
                            controller: controller,
                          ),

                          _reportOption(
                            title: 'Sexual content',
                            reason: 'sexual',
                            video: video,
                            controller: controller,
                          ),

                          _reportOption(
                            title: 'Other',
                            reason: 'other',
                            video: video,
                            controller: controller,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

// lib/App/Modules/All_Videos/widgets/video_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideosController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.black.withValues(alpha: 0.05),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(screenWidth),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildVideoInfo(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(double screenWidth) {
    return SizedBox(
      width: screenWidth, // Full screen width
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              video.thumbnailUrl,
              width: screenWidth,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE53935),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Iconsax.video, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
            // Duration badge
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  video.formattedDuration,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo(VideosController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Channel Avatar
        GestureDetector(
          onTap: () => controller.navigateToChannel(video.channelId),
          behavior: HitTestBehavior.opaque,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                video.channelAvatar.isNotEmpty
                    ? NetworkImage(video.channelAvatar)
                    : null,
            child:
                video.channelAvatar.isEmpty
                    ? const Icon(Iconsax.user, color: Colors.grey, size: 24)
                    : null,
          ),
        ),
        const SizedBox(width: 12),
        // Video details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video title
              GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Channel name with verified badge
              GestureDetector(
                onTap: () => controller.navigateToChannel(video.channelId),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        video.channelName,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (video.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Iconsax.verify5,
                        color: Color(0xFF1DA1F2),
                        size: 15,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Views and time
              Text(
                '${video.formattedViews} views • ${video.formattedTimeAgo}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              // Description preview (optional)
              if (video.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  video.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        // Menu button
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: IconButton(
            splashRadius: 22,
            onPressed: onMenuTap,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.black54,
              size: 22,
            ),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

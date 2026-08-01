// lib/App/Modules/CategoryVideos/widgets/category_video_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';

class CategoryVideoCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;
  final VoidCallback onChannelTap;

  const CategoryVideoCard({
    super.key,
    required this.video,
    required this.onTap,
    required this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
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
              child: _buildVideoInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(double screenWidth) {
    return SizedBox(
      width: screenWidth,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail - full width, no rounded corners
            Image.network(
              video.thumbnailUrl,
              width: screenWidth,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE53935),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Iconsax.video, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
            // Duration overlay
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  video.formattedDuration,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            // New badge
            if (video.isNew.value)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'NEW',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Channel Avatar
        GestureDetector(
          onTap: onChannelTap,
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
                onTap: onChannelTap,
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
              // Tags if available
              if (video.tags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children:
                      video.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#$tag',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ],
          ),
        ),
        // Like button
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Obx(() {
            return IconButton(
              onPressed: () {
                video.isLiked.toggle();
                // Call like API if needed
              },
              icon: Icon(
                video.isLiked.value ? Iconsax.heart5 : Iconsax.heart,
                color:
                    video.isLiked.value
                        ? const Color(0xFFE53935)
                        : Colors.grey.shade400,
                size: 20,
              ),
              splashRadius: 22,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            );
          }),
        ),
      ],
    );
  }
}

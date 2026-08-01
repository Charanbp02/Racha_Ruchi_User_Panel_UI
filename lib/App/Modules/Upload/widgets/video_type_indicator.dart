// lib/App/Modules/Upload/widgets/video_type_indicator.dart
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class VideoTypeIndicator extends StatelessWidget {
  final UploadController controller;

  const VideoTypeIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.videoDurationInSeconds.value == 0) {
        return const SizedBox.shrink();
      }

      final isShorts = controller.videoType.value == 'shorts';
      final durationDisplay = controller.videoDuration.value;
      final durationInSeconds = controller.videoDurationInSeconds.value;

      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isShorts
                    ? [const Color(0xFF1DA1F2), const Color(0xFF0C7ABF)]
                    : [const Color(0xFFD32F2F), const Color(0xFFE53935)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (isShorts
                      ? const Color(0xFF1DA1F2)
                      : const Color(0xFFE53935))
                  .withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(isShorts),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfo(isShorts, durationDisplay, durationInSeconds),
            ),
            _buildBadge(isShorts),
          ],
        ),
      );
    });
  }

  Widget _buildIcon(bool isShorts) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isShorts ? Iconsax.video_vertical : Iconsax.video,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildInfo(bool isShorts, String duration, int seconds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isShorts ? '📱 Shorts Video' : '🎬 Standard Video',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.timer_rounded,
              size: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 4),
            Text(
              'Duration: $duration',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 1,
              height: 12,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 12),
            Text(
              '${seconds}s',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(bool isShorts) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isShorts ? Icons.flash_on_rounded : Icons.check_circle_rounded,
            size: 14,
            color: isShorts ? const Color(0xFF1DA1F2) : const Color(0xFFE53935),
          ),
          const SizedBox(width: 4),
          Text(
            isShorts ? 'Shorts' : 'Ready',
            style: GoogleFonts.poppins(
              color:
                  isShorts ? const Color(0xFF1DA1F2) : const Color(0xFFE53935),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Video Type Indicator with Thumbnail
class VideoTypeIndicatorWithThumbnail extends StatelessWidget {
  final UploadController controller;

  const VideoTypeIndicatorWithThumbnail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.videoDurationInSeconds.value == 0) {
        return const SizedBox.shrink();
      }

      final isShorts = controller.videoType.value == 'shorts';
      final durationDisplay = controller.videoDuration.value;
      final durationInSeconds = controller.videoDurationInSeconds.value;

      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isShorts ? Colors.blue.shade100 : Colors.red.shade100,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _buildThumbnail(isShorts),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfo(isShorts, durationDisplay, durationInSeconds),
            ),
            _buildBadge(isShorts),
          ],
        ),
      );
    });
  }

  Widget _buildThumbnail(bool isShorts) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isShorts
                  ? [const Color(0xFF1DA1F2), const Color(0xFF0C7ABF)]
                  : [const Color(0xFFD32F2F), const Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          isShorts ? Iconsax.video_vertical : Iconsax.video,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildInfo(bool isShorts, String duration, int seconds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isShorts ? 'Shorts Video' : 'Standard Video',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Duration: $duration ($seconds seconds)',
          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBadge(bool isShorts) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            isShorts
                ? const Color(0xFF1DA1F2).withValues(alpha: 0.1)
                : const Color(0xFFE53935).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isShorts ? '#Shorts' : 'HD Ready',
        style: GoogleFonts.poppins(
          color: isShorts ? const Color(0xFF1DA1F2) : const Color(0xFFE53935),
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

// Alternative: Video Type Indicator with Stats (Fixed)
class VideoTypeIndicatorWithStats extends StatelessWidget {
  final UploadController controller;

  const VideoTypeIndicatorWithStats({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.videoDurationInSeconds.value == 0) {
        return const SizedBox.shrink();
      }

      final isShorts = controller.videoType.value == 'shorts';
      final durationDisplay = controller.videoDuration.value;
      final durationInSeconds = controller.videoDurationInSeconds.value;

      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(isShorts),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfo(isShorts, durationDisplay, durationInSeconds),
            ),
            _buildBadge(isShorts),
          ],
        ),
      );
    });
  }

  Widget _buildIcon(bool isShorts) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isShorts
                  ? [const Color(0xFF1DA1F2), const Color(0xFF0C7ABF)]
                  : [const Color(0xFFD32F2F), const Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (isShorts
                    ? const Color(0xFF1DA1F2)
                    : const Color(0xFFE53935))
                .withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isShorts ? Iconsax.video_vertical : Iconsax.video,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildInfo(bool isShorts, String duration, int seconds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isShorts ? 'Shorts' : 'Standard Video',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildStatItem(Icons.timer_rounded, duration),
            _buildStatItem(Icons.video_file_rounded, '${seconds}s'),
            // Removed videoResolution since it doesn't exist
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildBadge(bool isShorts) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isShorts
                  ? [const Color(0xFF1DA1F2), const Color(0xFF0C7ABF)]
                  : [const Color(0xFFD32F2F), const Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isShorts
                    ? const Color(0xFF1DA1F2)
                    : const Color(0xFFE53935))
                .withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        isShorts ? '#Shorts' : 'Upload',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

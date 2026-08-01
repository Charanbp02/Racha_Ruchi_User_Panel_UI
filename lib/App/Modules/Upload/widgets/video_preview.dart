// lib/App/Modules/Upload/widgets/video_preview.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';
import 'package:racharuchi/App/Modules/Upload/controller/upload_controller.dart';

class VideoPreview extends StatelessWidget {
  final UploadController controller;

  const VideoPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoPlayer(),
          _buildGradientOverlay(),
          _buildPlayButton(),
          _buildTopActions(),
          _buildBottomInfo(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return controller.videoPlayerController.value != null &&
            controller.videoPlayerController.value!.value.isInitialized
        ? VideoPlayer(controller.videoPlayerController.value!)
        : Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.4),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Center(
      child: GestureDetector(
        onTap: controller.toggleVideoPlay,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(
            () => Icon(
              controller.isVideoPlaying.value ? Iconsax.pause : Iconsax.play5,
              color: const Color(0xFFE53935),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopActions() {
    return Positioned(
      top: 12,
      right: 12,
      child: Row(
        children: [
          // Replace Video Button
          _buildActionButton(
            icon: Iconsax.refresh,
            onTap: controller.pickVideo,
            label: 'Replace',
          ),
          const SizedBox(width: 8),
          // Remove Video Button - using cancelUpload
          _buildActionButton(
            icon: Iconsax.trash,
            onTap: () {
              // Clear the video selection using existing controller methods
              controller.cancelUpload();
            },
            label: 'Remove',
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isDestructive
                  ? const Color(0xFFE53935).withValues(alpha: 0.9)
                  : Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isDestructive
                    ? const Color(0xFFE53935)
                    : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Row(
        children: [
          // Duration Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Obx(
                  () => Text(
                    controller.videoDuration.value,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

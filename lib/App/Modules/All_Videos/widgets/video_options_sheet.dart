// lib/App/Modules/All_Videos/widgets/video_options_sheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/All_Videos/controller/videos_controller.dart';
import 'package:racharuchi/App/Modules/All_Videos/widgets/report_options_sheet.dart';

class VideoOptionsSheet extends StatelessWidget {
  final VideoModel video;
  final VideosController controller;

  const VideoOptionsSheet({
    super.key,
    required this.video,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            // Drag Handle
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 18),

            _buildVideoHeader(),

            const SizedBox(height: 20),

            _optionTile(
              icon: Iconsax.like_1,
              title: "Like",
              onTap: () {
                Get.back();
                controller.likeVideo(video);
              },
            ),

            _optionTile(
              icon: Iconsax.share,
              title: "Share",
              onTap: () async {
                Get.back();

                try {
                  await Share.share('''
🎥 ${video.title}

👨‍🍳 ${video.channelName}

${video.description}

Watch:
${video.videoUrl}
''');
                } catch (_) {
                  Get.snackbar(
                    "Error",
                    "Unable to share video",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),

            _optionTile(
              icon: Iconsax.warning_2,
              title: "Report",
              iconColor: Colors.red,
              onTap: () {
                Get.back();

                Get.bottomSheet(
                  ReportOptionsSheet(video: video, controller: controller),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              video.thumbnailUrl,
              width: 110,
              height: 62,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 110,
                    height: 62,
                    color: Colors.grey.shade300,
                    child: const Icon(Iconsax.video),
                  ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  video.channelName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 23),

                const SizedBox(width: 18),

                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

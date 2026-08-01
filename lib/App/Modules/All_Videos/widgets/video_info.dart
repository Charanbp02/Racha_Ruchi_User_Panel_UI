// lib/App/Modules/All_Videos/widgets/video_info.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';

class VideoInfo extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onChannelTap;

  const VideoInfo({super.key, required this.video, required this.onChannelTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 6),

          // Channel
          GestureDetector(
            onTap: onChannelTap,
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
                  const Icon(Iconsax.verify5, size: 15, color: Colors.blue),
                ],
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Views & Time
          Text(
            '${video.formattedViews} views • ${video.formattedTimeAgo}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          if (video.description.isNotEmpty) ...[
            const SizedBox(height: 5),

            Text(
              video.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

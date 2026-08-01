import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/extensions/number_formatting_extension.dart';

class ChannelInfo extends StatelessWidget {
  final VideoModel video;
  final VideoPlayerControllerX controller;

  const ChannelInfo({super.key, required this.video, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildChannelAvatar(),

          const SizedBox(width: 14),

          Flexible(child: _buildChannelDetails()),

          if (!controller.isOwner) ...[
            const SizedBox(width: 12),
            _buildFollowButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildChannelAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade300,
        backgroundImage:
            video.channelAvatar.isNotEmpty
                ? NetworkImage(video.channelAvatar)
                : null,
        child:
            video.channelAvatar.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
      ),
    );
  }

  Widget _buildChannelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Channel Name
        Text(
          video.channelName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 6),

        /// Followers & Videos
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${controller.followerCount.value.formatNumber()} followers',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.video_library_rounded,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '12 videos',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton() {
    return Obx(
      () => ElevatedButton(
        onPressed:
            controller.isFollowingLoading.value
                ? null
                : controller.toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.isFollowing.value ? Colors.grey.shade200 : Colors.red,
          foregroundColor:
              controller.isFollowing.value ? Colors.black87 : Colors.white,
          elevation: controller.isFollowing.value ? 0 : 3,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child:
            controller.isFollowingLoading.value
                ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.isFollowing.value
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.isFollowing.value ? 'Following' : 'Follow',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

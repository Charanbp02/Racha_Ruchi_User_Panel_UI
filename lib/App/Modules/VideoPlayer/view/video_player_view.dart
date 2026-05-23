// lib/App/Modules/VideoPlayer/view/video_player_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final video = Get.arguments as VideoModel?;

    if (video == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Error', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.warning_2, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text('Video not found'),
            ],
          ),
        ),
      );
    }

    print('🎬 VideoPlayerView - Title: ${video.title}');
    print('📹 VideoPlayerView - URL: ${video.videoUrl}');

    final VideoPlayerControllerX controller = Get.put(
      VideoPlayerControllerX(
        videoUrl: video.videoUrl,
        videoTitle: video.title,
        channelName: video.channelName,
        channelImage: video.channelAvatar,
        videoId: video.id,
        description: video.description,
        ingredients: video.ingredients,
        userId: video.channelId,
      ),
      tag: video.id,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Video Player',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: () => _showVideoOptions(video, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.red),
                SizedBox(height: 20),
                Text('Loading video...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.warning_2, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.retry(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.isInitialized.value &&
            controller.videoController != null) {
          return CustomScrollView(
            slivers: [
              _buildVideoPlayerSection(controller),
              _buildVideoInfoSection(video, controller),
            ],
          );
        }

        return const SizedBox();
      }),
    );
  }

  Widget _buildVideoPlayerSection(VideoPlayerControllerX controller) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: controller.toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (controller.videoController != null &&
                controller.videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio: controller.videoController!.value.aspectRatio,
                child: VideoPlayer(controller.videoController!),
              )
            else
              Container(
                height: 300,
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            AnimatedOpacity(
              opacity: controller.showControls.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          controller.isPlaying.value
                              ? Iconsax.pause_circle
                              : Iconsax.play_circle,
                          size: 70,
                          color: Colors.white,
                        ),
                        onPressed: controller.playPause,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon: Iconsax.repeat,
                            label: '10',
                            onTap: controller.rewind10Seconds,
                            isRewind: true,
                          ),
                          const SizedBox(width: 40),
                          _buildControlButton(
                            icon: Iconsax.forward,
                            label: '10',
                            onTap: controller.forward10Seconds,
                            isRewind: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  value:
                      controller.duration.value.inSeconds > 0
                          ? controller.position.value.inSeconds /
                              controller.duration.value.inSeconds
                          : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${controller.formatDuration(controller.position.value)} / ${controller.formatDuration(controller.duration.value)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfoSection(
    VideoModel video,
    VideoPlayerControllerX controller,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Iconsax.timer_1, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${controller.duration.value.inMinutes} min',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(width: 12),
                const Icon(Iconsax.eye, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  video.formattedViews,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(width: 12),
                const Icon(Iconsax.calendar, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  video.formattedTimeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButtons(controller),
            const SizedBox(height: 16),
            _buildChannelInfo(video, controller),
            const SizedBox(height: 16),
            if (video.description.isNotEmpty)
              _buildDescription(video.description),
            if (video.ingredients.isNotEmpty)
              _buildIngredientsSection(video.ingredients),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isRewind,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Transform.scale(
              scaleX: isRewind ? -1 : 1,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(VideoPlayerControllerX controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(
            () => _buildActionButton(
              icon: Iconsax.like_1,
              label: controller.likeCount.value.formatNumber(),
              isActive: controller.isLiked.value,
              activeColor: Colors.blue,
              onTap: controller.toggleLike,
            ),
          ),
          _buildActionButton(
            icon: Iconsax.message,
            label: controller.commentCount.value.formatNumber(),
            onTap: controller.openComments,
          ),
          _buildActionButton(
            icon: Iconsax.export_1,
            label: 'Share',
            onTap: controller.shareVideo,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    Color activeColor = Colors.blue,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : Colors.grey[600],
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelInfo(
    VideoModel video,
    VideoPlayerControllerX controller,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(video.channelAvatar),
          onBackgroundImageError: (_, __) {},
          child: const Icon(Iconsax.user, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.channelName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  '${controller.followerCount.value.formatNumber()} followers',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => ElevatedButton.icon(
            onPressed: controller.toggleFollow,
            icon: Icon(
              controller.isFollowing.value
                  ? Iconsax.tick_circle
                  : Iconsax.add_circle,
              size: 16,
              color:
                  controller.isFollowing.value ? Colors.black87 : Colors.white,
            ),
            label: Text(
              controller.isFollowing.value ? 'FOLLOWING' : 'FOLLOW',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  controller.isFollowing.value ? Colors.grey[200] : Colors.red,
              foregroundColor:
                  controller.isFollowing.value ? Colors.black87 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.information, size: 16, color: Colors.red[300]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(List<dynamic> ingredients) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Iconsax.cake, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${ingredients.length} items needed',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              final name = ingredient['name'] ?? ingredient.toString();
              final quantity = ingredient['quantity'] ?? '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        quantity.isEmpty ? name : '$name: $quantity',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showVideoOptions(VideoModel video, VideoPlayerControllerX controller) {
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
                leading: const Icon(Iconsax.save_2, color: Colors.black87),
                title: const Text('Save to playlist'),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: const Icon(Iconsax.share, color: Colors.black87),
                title: const Text('Share'),
                onTap: () {
                  Get.back();
                  controller.shareVideo();
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.message, color: Colors.black87),
                title: const Text('Report'),
                onTap: () => Get.back(),
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

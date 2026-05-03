import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map?;
    final videoUrl = arguments?['videoUrl'] as String?;
    final videoTitle = arguments?['title'] as String? ?? 'Video Player';
    final channelName =
        arguments?['channelName'] as String? ?? 'Recipe Channel';
    final channelImage = arguments?['channelImage'] as String?;
    final videoId = arguments?['videoId'] as String?;
    final ingredients = arguments?['ingredients'] as List<String>?;

    final VideoPlayerControllerX controller =
        Get.isRegistered<VideoPlayerControllerX>()
            ? Get.find<VideoPlayerControllerX>()
            : Get.put(
              VideoPlayerControllerX(
                videoUrl: videoUrl,
                videoTitle: videoTitle,
                channelName: channelName,
                channelImage: channelImage,
                videoId: videoId,
              ),
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
        actions: [IconButton(icon: const Icon(Iconsax.more), onPressed: () {})],
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
                  onPressed: () => controller.initializePlayer(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.isInitialized.value) {
          return CustomScrollView(
            slivers: [
              // Video Player Section
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: controller.toggleControls,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio:
                            controller.videoController.value.aspectRatio,
                        child: VideoPlayer(controller.videoController),
                      ),

                      // Control Overlay
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

                      // Progress Bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          child: LinearProgressIndicator(
                            value:
                                controller.position.value.inSeconds /
                                controller.duration.value.inSeconds,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                      ),

                      // Time Display
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${controller.formatDuration(controller.position.value)} / ${controller.formatDuration(controller.duration.value)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Video Info Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Title
                      Text(
                        videoTitle,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Views and Duration
                      Row(
                        children: [
                          const Icon(
                            Iconsax.timer_1,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${controller.duration.value.inMinutes} min',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Iconsax.eye, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '1.2M views',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Iconsax.calendar,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '2 days ago',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action Buttons Row
                      Container(
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
                            _buildActionButton(
                              icon:
                                  controller.isLiked.value
                                      ? Iconsax.like_1
                                      : Iconsax.like_14,
                              label: controller.likeCount.value.formatNumber(),
                              isActive: controller.isLiked.value,
                              activeColor: Colors.blue,
                              onTap: controller.toggleLike,
                            ),
                            _buildActionButton(
                              icon:
                                  controller.isDisliked.value
                                      ? Iconsax.dislike
                                      : Iconsax.dislike1,
                              label:
                                  controller.dislikeCount.value.formatNumber(),
                              isActive: controller.isDisliked.value,
                              activeColor: Colors.red,
                              onTap: controller.toggleDislike,
                            ),
                            _buildActionButton(
                              icon: Iconsax.message,
                              label:
                                  controller.commentCount.value.formatNumber(),
                              onTap: controller.openComments,
                            ),
                            _buildActionButton(
                              icon: Iconsax.export_1,
                              label: 'Share',
                              onTap: controller.shareVideo,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Channel Info & Follow Button
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              channelImage ??
                                  'https://randomuser.me/api/portraits/men/1.jpg',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  channelName,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.user,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${controller.followerCount.value.formatNumber()} followers',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
                                    controller.isFollowing.value
                                        ? Colors.black87
                                        : Colors.white,
                              ),
                              label: Text(
                                controller.isFollowing.value
                                    ? 'FOLLOWING'
                                    : 'FOLLOW',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.isFollowing.value
                                        ? Colors.grey[200]
                                        : Colors.red,
                                foregroundColor:
                                    controller.isFollowing.value
                                        ? Colors.black87
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                                side:
                                    controller.isFollowing.value
                                        ? BorderSide(color: Colors.grey[300]!)
                                        : BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Short Description (Limited to few words)
                      _buildShortDescription(),
                      const SizedBox(height: 20),

                      // Ingredients Section (Compulsory)
                      _buildIngredientsSection(
                        ingredients ?? defaultIngredients,
                      ),
                      const SizedBox(height: 20),

                      // Comments Section Preview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Iconsax.message_text_1,
                                size: 18,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Comments',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: controller.openComments,
                            child: Text(
                              'View all ${controller.commentCount.value.formatNumber()}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildCommentPreview(controller),
                      const SizedBox(height: 16),

                      // Related Videos Section
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.video_play,
                            size: 18,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Related Videos',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildRelatedVideoTile(),
                      _buildRelatedVideoTile(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      }),
    );
  }

  Widget _buildShortDescription() {
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
          const Expanded(
            child: Text(
              'Delicious homemade recipe perfect for family dinner',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(List<String> ingredients) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.cake,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Add this
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

          // Ingredients Grid - Fixed overflow issue
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.2, // Changed from 3.5 to 3.2 for better fit
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
            ),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return _buildIngredientItem(ingredients[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(String ingredient) {
    // Split ingredient name and measurement if exists
    String name = ingredient;
    String measurement = '';

    if (ingredient.contains('(')) {
      final parts = ingredient.split('(');
      name = parts[0].trim();
      measurement = '(' + parts[1];
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ), // Reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (measurement.isNotEmpty)
                  Text(
                    measurement,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 9,
                    ), // Reduced font size
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const Icon(Iconsax.tick_circle, size: 14, color: Colors.green),
        ],
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

  Widget _buildCommentPreview(VideoPlayerControllerX controller) {
    return InkWell(
      onTap: controller.openComments,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/1.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add a comment...',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ),
                  Text(
                    '${controller.commentCount.value} comments',
                    style: TextStyle(color: Colors.blue[300], fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Iconsax.arrow_right_3,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideoTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delicious Paneer Butter Masala Recipe',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chef Sanjeev • 450K views',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.more, size: 16),
            color: Colors.grey[600],
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// Default ingredients list
const List<String> defaultIngredients = [
  'Dry Red Chilli (4-5 pcs)',
  'Eggs (2 large)',
  'Onion (1 medium, finely chopped)',
  'Garlic (4-5 cloves)',
  'Ginger (1 inch piece)',
  'Tomato (1 medium)',
  'Coriander leaves (fresh)',
  'Oil (2 tbsp)',
  'Salt (to taste)',
  'Turmeric powder (1/2 tsp)',
  'Red chilli powder (1 tsp)',
  'Garam masala (1/2 tsp)',
];

// Extension to format numbers
extension NumberFormatting on int {
  String formatNumber() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

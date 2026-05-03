import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControllerX extends GetxController {
  late VideoPlayerController videoController;
  final isInitialized = false.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final showControls = true.obs;

  // Video interaction states
  final isLiked = false.obs;
  final isDisliked = false.obs;
  final likeCount = 1243.obs;
  final dislikeCount = 42.obs;
  final commentCount = 89.obs;
  final isFollowing = false.obs;
  final followerCount = 12500.obs;

  // Video info
  final String? videoUrl;
  final String? videoTitle;
  final String? channelName;
  final String? channelImage;
  final String? videoId;
  final String? description;

  static const String defaultVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  VideoPlayerControllerX({
    this.videoUrl,
    this.videoTitle,
    this.channelName,
    this.channelImage,
    this.videoId,
    this.description,
  });

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = videoUrl ?? defaultVideoUrl;

      videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoController.initialize();

      duration.value = videoController.value.duration;
      isInitialized.value = true;
      isLoading.value = false;

      videoController.addListener(() {
        if (videoController.value.isInitialized) {
          position.value = videoController.value.position;
          isPlaying.value = videoController.value.isPlaying;
        }
        update();
      });

      await videoController.play();
      isPlaying.value = true;

      Future.delayed(const Duration(seconds: 3), () {
        if (!isPlaying.value) return;
        showControls.value = false;
      });

      update();
    } catch (e) {
      print('Video Player Error: $e');
      isLoading.value = false;
      errorMessage.value =
          'Failed to load video. Please check your internet connection.';
    }
  }

  void playPause() {
    if (videoController.value.isPlaying) {
      videoController.pause();
      isPlaying.value = false;
      showControls.value = true;
    } else {
      videoController.play();
      isPlaying.value = true;
      Future.delayed(const Duration(seconds: 3), () {
        if (isPlaying.value) {
          showControls.value = false;
        }
      });
    }
    update();
  }

  void seekTo(double value) {
    final newPosition = Duration(seconds: value.toInt());
    videoController.seekTo(newPosition);
    position.value = newPosition;
    update();
  }

  void forward10Seconds() {
    final newPosition = position.value + const Duration(seconds: 10);
    if (newPosition < duration.value) {
      videoController.seekTo(newPosition);
      position.value = newPosition;
    } else {
      videoController.seekTo(duration.value);
      position.value = duration.value;
    }
    _showControlOverlay();
    update();
  }

  void rewind10Seconds() {
    final newPosition = position.value - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      videoController.seekTo(newPosition);
      position.value = newPosition;
    } else {
      videoController.seekTo(Duration.zero);
      position.value = Duration.zero;
    }
    _showControlOverlay();
    update();
  }

  void _showControlOverlay() {
    showControls.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      if (isPlaying.value) {
        showControls.value = false;
      }
    });
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value && isPlaying.value) {
      Future.delayed(const Duration(seconds: 3), () {
        if (isPlaying.value) {
          showControls.value = false;
        }
      });
    }
    update();
  }

  void toggleLike() {
    if (isLiked.value) {
      isLiked.value = false;
      likeCount.value--;
    } else {
      isLiked.value = true;
      likeCount.value++;
      if (isDisliked.value) {
        isDisliked.value = false;
        dislikeCount.value--;
      }
    }
    update();
  }

  void toggleDislike() {
    if (isDisliked.value) {
      isDisliked.value = false;
      dislikeCount.value--;
    } else {
      isDisliked.value = true;
      dislikeCount.value++;
      if (isLiked.value) {
        isLiked.value = false;
        likeCount.value--;
      }
    }
    update();
  }

  void shareVideo() {
    Get.snackbar(
      'Share',
      'Sharing video...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: const Duration(seconds: 1),
    );
  }

  void openComments() {
    Get.to(
      () => CommentsPage(
        videoTitle: videoTitle ?? 'Video',
        commentCount: commentCount.value,
      ),
      transition: Transition.rightToLeft,
    );
  }

  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
    Get.snackbar(
      isFollowing.value ? 'Following' : 'Unfollowed',
      isFollowing.value
          ? 'You are now following $channelName'
          : 'You unfollowed $channelName',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: const Duration(seconds: 1),
    );
    update();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    videoController.removeListener(() {});
    videoController.dispose();
    super.onClose();
  }
}

// Comments Page
class CommentsPage extends StatelessWidget {
  final String videoTitle;
  final int commentCount;

  const CommentsPage({
    super.key,
    required this.videoTitle,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Comments ($commentCount)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Comment',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildCommentTile();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/2.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'User Name',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '2 days ago',
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Great video! Really enjoyed watching this recipe. Will definitely try it at home.',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.like_1, size: 16),
                      color: Colors.grey[600],
                      onPressed: () {},
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '245',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Iconsax.dislike, size: 16),
                      color: Colors.grey[600],
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

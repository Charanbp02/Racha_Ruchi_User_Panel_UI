// lib/App/Modules/VideoPlayer/controller/video_player_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoPlayerControllerX extends GetxController {
  VideoPlayerController? videoController;
  final isInitialized = false.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final showControls = true.obs;

  final isLiked = false.obs;
  final likeCount = 0.obs;
  final commentCount = 0.obs;
  final isFollowing = false.obs;
  final followerCount = 0.obs;

  final String videoUrl;
  final String videoTitle;
  final String channelName;
  final String channelImage;
  final String videoId;
  final String description;
  final List<dynamic> ingredients;
  final String userId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  VideoPlayerControllerX({
    required this.videoUrl,
    required this.videoTitle,
    required this.channelName,
    required this.channelImage,
    required this.videoId,
    required this.description,
    required this.ingredients,
    required this.userId,
  });

  @override
  void onInit() {
    super.onInit();
    print('🎬 VideoPlayerControllerX initialized');
    print(
      '📹 Received videoUrl: ${videoUrl.isNotEmpty ? videoUrl.substring(0, videoUrl.length > 80 ? 80 : videoUrl.length) : 'EMPTY'}',
    );
    _initializeAndPlay();
    _fetchData();
  }

  Future<void> _initializeAndPlay() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (videoUrl.isEmpty) {
        throw Exception(
          'Video URL is empty. Please check your Firestore data.',
        );
      }

      print('🎬 Initializing video player...');
      videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoController!.initialize();

      print('✅ Video initialized successfully');
      duration.value = videoController!.value.duration;
      isInitialized.value = true;
      isLoading.value = false;

      videoController!.addListener(() {
        if (videoController!.value.isInitialized) {
          position.value = videoController!.value.position;
          isPlaying.value = videoController!.value.isPlaying;
        }
        update();
      });

      await videoController!.play();
      isPlaying.value = true;

      Future.delayed(const Duration(seconds: 3), () {
        if (isPlaying.value) showControls.value = false;
      });

      await _incrementViewCount();
      update();
    } catch (e) {
      print('❌ Video Player Error: $e');
      isLoading.value = false;
      errorMessage.value = _getErrorMessage(e.toString());
    }
  }

  Future<void> _incrementViewCount() async {
    try {
      await _firestore.collection('recipe_videos').doc(videoId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('404')) return 'Video not found.';
    if (error.contains('403')) return 'Access denied. Please login.';
    if (error.contains('Network')) return 'Network error. Check connection.';
    return 'Failed to load video. Please try again.';
  }

  Future<void> _fetchData() async {
    await Future.wait([
      fetchVideoStats(),
      fetchUserStats(),
      checkIfLiked(),
      checkIfFollowing(),
    ]);
  }

  Future<void> fetchVideoStats() async {
    try {
      final doc =
          await _firestore.collection('recipe_videos').doc(videoId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        likeCount.value = data['likes'] ?? 0;
        commentCount.value = data['comments'] ?? 0;
      }
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }

  Future<void> fetchUserStats() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        followerCount.value = data['followerCount'] ?? 0;
      }
    } catch (e) {
      followerCount.value = 0;
    }
  }

  Future<void> checkIfLiked() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final likeDoc =
          await _firestore
              .collection('recipe_videos')
              .doc(videoId)
              .collection('likes')
              .doc(user.uid)
              .get();
      isLiked.value = likeDoc.exists;
    } catch (e) {
      print('Error checking like status: $e');
    }
  }

  Future<void> checkIfFollowing() async {
    final user = _auth.currentUser;
    if (user == null || userId == user.uid) return;
    try {
      final followDoc =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('followers')
              .doc(user.uid)
              .get();
      isFollowing.value = followDoc.exists;
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> toggleFollow() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar(
        'Login Required',
        'Please login to follow',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (userId == user.uid) {
      Get.snackbar(
        'Info',
        'You cannot follow yourself',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final userRef = _firestore.collection('users').doc(userId);
      final followRef = userRef.collection('followers').doc(user.uid);
      final followDoc = await followRef.get();

      if (followDoc.exists) {
        await followRef.delete();
        await userRef.update({'followerCount': FieldValue.increment(-1)});
        isFollowing.value = false;
        followerCount.value--;
        Get.snackbar(
          'Unfollowed',
          'You unfollowed $channelName',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
        );
      } else {
        await followRef.set({
          'followerId': user.uid,
          'followerName': user.displayName ?? 'User',
          'followerImage': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        await userRef.update({'followerCount': FieldValue.increment(1)});
        isFollowing.value = true;
        followerCount.value++;
        Get.snackbar(
          'Following',
          'You are now following $channelName',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  void playPause() {
    if (!isInitialized.value || videoController == null) return;
    if (videoController!.value.isPlaying) {
      videoController!.pause();
      isPlaying.value = false;
      showControls.value = true;
    } else {
      videoController!.play();
      isPlaying.value = true;
      Future.delayed(const Duration(seconds: 3), () {
        if (isPlaying.value) showControls.value = false;
      });
    }
    update();
  }

  void forward10Seconds() {
    if (!isInitialized.value || videoController == null) return;
    final newPosition = position.value + const Duration(seconds: 10);
    if (newPosition < duration.value) {
      videoController!.seekTo(newPosition);
      position.value = newPosition;
    } else {
      videoController!.seekTo(duration.value);
      position.value = duration.value;
    }
    _showControlOverlay();
  }

  void rewind10Seconds() {
    if (!isInitialized.value || videoController == null) return;
    final newPosition = position.value - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      videoController!.seekTo(newPosition);
      position.value = newPosition;
    } else {
      videoController!.seekTo(Duration.zero);
      position.value = Duration.zero;
    }
    _showControlOverlay();
  }

  void _showControlOverlay() {
    showControls.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      if (isPlaying.value) showControls.value = false;
    });
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value && isPlaying.value) {
      Future.delayed(const Duration(seconds: 3), () {
        if (isPlaying.value) showControls.value = false;
      });
    }
  }

  Future<void> toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar(
        'Login Required',
        'Please login to like videos',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final videoRef = _firestore.collection('recipe_videos').doc(videoId);
      final likeRef = videoRef.collection('likes').doc(user.uid);
      final likeDoc = await likeRef.get();

      if (likeDoc.exists) {
        await likeRef.delete();
        await videoRef.update({'likes': FieldValue.increment(-1)});
        isLiked.value = false;
        likeCount.value--;
        Get.snackbar(
          'Removed Like',
          'You unliked this video',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      } else {
        await likeRef.set({
          'userId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await videoRef.update({'likes': FieldValue.increment(1)});
        isLiked.value = true;
        likeCount.value++;
        Get.snackbar(
          'Liked!',
          'You liked this video',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  void shareVideo() {
    Get.snackbar(
      'Share',
      'Share feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void openComments() {
    Get.toNamed(
      '/comments',
      arguments: {
        'videoId': videoId,
        'videoTitle': videoTitle,
        'commentCount': commentCount.value,
      },
    );
  }

  void retry() {
    _initializeAndPlay();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    if (videoController != null) {
      videoController!.dispose();
    }
    super.onClose();
  }
}

extension NumberFormatting on int {
  String formatNumber() {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }
}

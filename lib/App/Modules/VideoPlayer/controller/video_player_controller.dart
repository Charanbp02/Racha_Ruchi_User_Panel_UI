// lib/App/Modules/VideoPlayer/controller/video_player_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/comments_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
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
  final viewsCount = 0.obs;
  final isFollowing = false.obs;
  final followerCount = 0.obs;
  final isFollowingLoading = false.obs;
  final hasViewed = false.obs;

  final String videoUrl;
  final String videoTitle;
  final String channelName;
  final String channelImage;
  final String videoId;
  final String description;
  final List<dynamic> ingredients;
  final String userId;

  final animateLike = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isDisposed = false;

  // ✅ ADD THIS PUBLIC GETTER
  String? get currentUserId => _auth.currentUser?.uid;

  // ✅ ADDED: Stream subscriptions for real-time updates
  StreamSubscription<DocumentSnapshot>? _followSubscription;
  StreamSubscription<QuerySnapshot>? _followerCountSubscription;

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
        if (!_isDisposed && videoController!.value.isInitialized) {
          position.value = videoController!.value.position;
          isPlaying.value = videoController!.value.isPlaying;
        }
        update();
      });

      await videoController!.play();
      isPlaying.value = true;

      _setupViewTracking();

      Future.delayed(const Duration(seconds: 3), () {
        if (!_isDisposed && isPlaying.value) showControls.value = false;
      });

      update();
    } catch (e) {
      print('❌ Video Player Error: $e');
      isLoading.value = false;
      errorMessage.value = _getErrorMessage(e.toString());
    }
  }

  void _setupViewTracking() {
    if (videoController == null) return;

    videoController!.addListener(() {
      if (!_isDisposed &&
          !hasViewed.value &&
          videoController!.value.isInitialized) {
        final videoDuration = duration.value;
        final currentPosition = position.value;

        if (currentPosition.inSeconds >= 30 ||
            (videoDuration.inSeconds > 0 &&
                currentPosition.inSeconds >= videoDuration.inSeconds ~/ 2)) {
          _incrementUniqueViewCount();
        }
      }
    });
  }

  Future<void> _incrementUniqueViewCount() async {
    if (hasViewed.value || _isDisposed) return;

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final viewRef = _firestore
          .collection('recipe_videos')
          .doc(videoId)
          .collection('views')
          .doc(user.uid);

      final viewDoc = await viewRef.get();

      if (!viewDoc.exists) {
        await viewRef.set({
          'userId': user.uid,
          'viewedAt': FieldValue.serverTimestamp(),
          'userEmail': user.email,
        });

        await _firestore.collection('recipe_videos').doc(videoId).update({
          'views': FieldValue.increment(1),
        });

        hasViewed.value = true;
        viewsCount.value++;
      }
    } catch (e) {
      print('Error incrementing unique view: $e');
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('404')) return 'Video not found.';
    if (error.contains('403')) return 'Access denied. Please login.';
    if (error.contains('Network')) return 'Network error. Check connection.';
    return 'Failed to load video. Please try again.';
  }

  // ✅ UPDATED: _fetchData with realtime listeners
  Future<void> _fetchData() async {
    await Future.wait([fetchVideoStats(), checkIfLiked()]);

    // Start realtime listeners
    checkIfFollowing();
    listenFollowerCount();
  }

  Future<void> fetchVideoStats() async {
    try {
      final doc =
          await _firestore.collection('recipe_videos').doc(videoId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        likeCount.value = data['likes'] ?? 0;
        commentCount.value = data['comments'] ?? 0;
        viewsCount.value = data['views'] ?? 0;
      }
    } catch (e) {
      print('Error fetching stats: $e');
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

  // ✅ REPLACED: Real-time follow status listener
  void checkIfFollowing() {
    final user = _auth.currentUser;

    if (user == null || user.uid == userId) {
      isFollowing.value = false;
      return;
    }

    // Cancel existing subscription
    _followSubscription?.cancel();

    // Start realtime listener
    _followSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('followers')
        .doc(user.uid)
        .snapshots()
        .listen(
          (doc) {
            if (!_isDisposed) {
              isFollowing.value = doc.exists;
              print('📡 Real-time follow status updated: ${doc.exists}');
            }
          },
          onError: (error) {
            print('❌ Follow status listener error: $error');
            isFollowing.value = false;
          },
        );
  }

  // ✅ ADDED: Real-time follower count listener
  void listenFollowerCount() {
    _followerCountSubscription?.cancel();

    _followerCountSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('followers')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          followerCount.value = snapshot.size;
          print('Followers count: ${snapshot.size}');
        });
  }

  // ✅ SIMPLIFIED: toggleFollow without manual UI updates
  Future<void> toggleFollow() async {
    if (isFollowingLoading.value) return;

    print("Target User UID: $userId");

    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar(
        'Login Required',
        'Please login first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    print("Current User UID: ${user.uid}");

    if (user.uid == userId) {
      Get.snackbar(
        'Info',
        'You cannot follow yourself',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isFollowingLoading.value = true;

      final targetUserRef = _firestore.collection('users').doc(userId);
      final followerRef = targetUserRef.collection('followers').doc(user.uid);
      final currentUserRef = _firestore.collection('users').doc(user.uid);
      final followingRef = currentUserRef.collection('following').doc(userId);

      final followerDoc = await followerRef.get();

      if (followerDoc.exists) {
        // UNFOLLOW
        await followerRef.delete();
        await followingRef.delete();

        // ❌ REMOVED manual UI updates - realtime listener will handle
        // isFollowing.value = false;
        // followerCount.value--;

        Get.snackbar(
          'Unfollowed',
          'You unfollowed $channelName',
          backgroundColor: Colors.grey,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      } else {
        // FOLLOW
        await followerRef.set({
          'followerId': user.uid,
          'userName': user.displayName ?? 'User',
          'userImage': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await followingRef.set({
          'followingId': userId,
          'followingName': channelName,
          'followingImage': channelImage,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await targetUserRef.update({'followerCount': FieldValue.increment(1)});

        // ❌ REMOVED manual UI updates - realtime listener will handle
        // isFollowing.value = true;
        // followerCount.value++;

        Get.snackbar(
          'Following',
          'You are now following $channelName',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      print('FOLLOW ERROR: $e');
      Get.snackbar(
        'Error',
        'Failed to follow/unfollow',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFollowingLoading.value = false;
    }
  }

  void playPause() {
    if (!isInitialized.value || videoController == null || _isDisposed) return;
    if (videoController!.value.isPlaying) {
      videoController!.pause();
      isPlaying.value = false;
      showControls.value = true;
    } else {
      videoController!.play();
      isPlaying.value = true;
      Future.delayed(const Duration(seconds: 3), () {
        if (!_isDisposed && isPlaying.value) showControls.value = false;
      });
    }
    update();
  }

  void forward10Seconds() {
    if (!isInitialized.value || videoController == null || _isDisposed) return;
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
    if (!isInitialized.value || videoController == null || _isDisposed) return;
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
    if (_isDisposed) return;
    showControls.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      if (!_isDisposed && isPlaying.value) showControls.value = false;
    });
  }

  void toggleControls() {
    if (_isDisposed) return;
    showControls.value = !showControls.value;
    if (showControls.value && isPlaying.value) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!_isDisposed && isPlaying.value) showControls.value = false;
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
        snackPosition: SnackPosition.BOTTOM,
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
      } else {
        await likeRef.set({
          'userId': user.uid,
          'userEmail': user.email,
          'userName': user.displayName,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await videoRef.update({'likes': FieldValue.increment(1)});
        isLiked.value = true;
        likeCount.value++;
      }
    } catch (e) {
      print('Error toggling like: $e');
      Get.snackbar(
        'Error',
        'Failed to like video',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> shareVideo() async {
    try {
      String durationText = '';
      if (duration.value.inHours > 0) {
        durationText =
            '${duration.value.inHours}h ${duration.value.inMinutes.remainder(60)}m';
      } else {
        durationText = '${duration.value.inMinutes} min';
      }

      final shareText = '''
🍲 Check out this recipe video!

📹 $videoTitle
👨‍🍳 By: $channelName
⏱️ Duration: $durationText
👀 Views: ${viewsCount.value.formatNumber()}
❤️ Likes: ${likeCount.value.formatNumber()}

Watch now in Racha Ruchi App!
''';

      await Share.share(shareText, subject: videoTitle);

      await _firestore.collection('recipe_videos').doc(videoId).update({
        'shares': FieldValue.increment(1),
      });

      Get.snackbar(
        'Success',
        'Shared successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error sharing: $e');
      Get.snackbar(
        'Error',
        'Could not share video',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> reportVideo({required String reason}) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        Get.snackbar(
          'Login Required',
          'Please login first',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      await _firestore.collection('reports').add({
        'videoId': videoId,
        'videoTitle': videoTitle,
        'reason': reason,
        'reportedBy': user.uid,
        'reportedByEmail': user.email,
        'reportedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      return true;
    } catch (e) {
      print('❌ Report Error: $e');
      Get.snackbar(
        'Error',
        'Failed to report video',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Widget _reportOption({required String title, required String reason}) {
    return ListTile(
      leading: const Icon(Iconsax.warning_2, color: Colors.red),
      title: Text(title),
      onTap: () async {
        Get.back();
        final success = await reportVideo(reason: reason);
        if (success) {
          Get.snackbar(
            'Reported',
            'Thanks for your feedback. We will review it.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      },
    );
  }

  void reportVideoBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Report Video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _reportOption(title: 'Spam or misleading', reason: 'spam'),
            _reportOption(title: 'Violent content', reason: 'violence'),
            _reportOption(title: 'Hateful content', reason: 'hate'),
            _reportOption(title: 'Sexual content', reason: 'sexual'),
            _reportOption(title: 'Copyright issue', reason: 'copyright'),
            _reportOption(title: 'Other', reason: 'other'),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void openComments() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: CommentsBottomSheet(
                    videoId: videoId,
                    videoTitle: videoTitle,
                    commentCount: commentCount.value,
                    scrollController: scrollController,
                    onCommentCountChanged: (newCount) {
                      commentCount.value = newCount;
                    },
                  ),
                ),
          ),
    );
  }

  void retry() {
    _initializeAndPlay();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  // ✅ UPDATED: Dispose all subscriptions
  @override
  void onClose() {
    _isDisposed = true;

    // Cancel stream subscriptions
    _followSubscription?.cancel();
    _followerCountSubscription?.cancel();

    // Dispose video controller
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

// lib/App/Modules/VideoPlayer/controller/video_player_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Extensions/number_extensions.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/config/video_player_constants.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/comments_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// ==================== CONTROLLER ====================
class VideoPlayerControllerX extends GetxController {
  // ==================== OBSERVABLES ====================
  VideoPlayerController? videoController;
  final isInitialized = false.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final showControls = true.obs;
  final bufferedPosition = Duration.zero.obs;
  final isBuffering = false.obs;
  final isMuted = false.obs;
  final volume = 1.0.obs;

  // Social stats
  final isLiked = false.obs;
  final likeCount = 0.obs;
  final commentCount = 0.obs;
  final viewsCount = 0.obs;
  final isFollowing = false.obs;
  final followerCount = 0.obs;
  final isFollowingLoading = false.obs;
  final hasViewed = false.obs;
  final animateLike = false.obs;

  // ==================== REQUIRED PARAMS ====================
  final String videoUrl;
  final String videoTitle;
  final String channelName;
  final String channelImage;
  final String videoId;
  final String description;
  final List<dynamic> ingredients;
  final String userId;

  // ==================== FIREBASE ====================
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Connectivity _connectivity = Connectivity();

  // ==================== INTERNAL STATE ====================
  bool _isDisposed = false;
  bool _isUpdatingView = false;
  int _retryCount = 0;
  Timer? _progressTimer;
  Timer? _hideControlsTimer;
  Timer? _bufferingTimer;
  Timer? _connectionCheckTimer;

  // Stream subscriptions
  StreamSubscription<DocumentSnapshot>? _followSubscription;
  StreamSubscription<QuerySnapshot>? _followerCountSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // ==================== GETTERS ====================
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isOwner => currentUserId == userId;

  // ==================== LIFECYCLE ====================
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
    print('🎬 Video URL: $videoUrl');
    _initializeAndPlay();
    _fetchData();
    _setupConnectivityListener();
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  // ==================== INITIALIZATION ====================
  Future<void> _initializeAndPlay() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _retryCount = 0;

      if (videoUrl.isEmpty) {
        throw Exception('Video URL is empty');
      }

      print('🎬 Initializing video player...');

      await _initializeVideoPlayer();
      await _setupVideoListeners();

      isInitialized.value = true;
      isLoading.value = false;

      await _startPlayback();
      _startProgressUpdates();
      _setupViewTracking();
      _startHideControlsTimer();

      update();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _initializeVideoPlayer() async {
    // Dispose existing controller
    if (videoController != null) {
      await videoController!.dispose();
    }

    print('🎬 Initializing video with URL: $videoUrl');

    // ✅ CLEAN: No custom headers, no URL manipulation
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ),
    );

    // ✅ Increased timeout to 90 seconds for HLS
    await videoController!.initialize().timeout(
      const Duration(seconds: 90),
      onTimeout: () => throw TimeoutException('Video initialization timed out'),
    );

    // Set initial state
    duration.value = videoController!.value.duration;
    videoController!.setVolume(isMuted.value ? 0 : volume.value);
    videoController!.setLooping(true);

    print('✅ Video initialized: ${duration.value}');
  }

  Future<void> _setupVideoListeners() async {
    if (videoController == null) return;

    // Add listener for state changes
    videoController!.addListener(() {
      if (!_isDisposed && videoController!.value.isInitialized) {
        _updatePlayState();
        _updateBufferingState();
      }
      update();
    });

    // Pre-buffer for smoother playback
    if (!videoController!.value.isInitialized) {
      await videoController!.initialize();
    }
  }

  void _updatePlayState() {
    if (videoController != null && videoController!.value.isInitialized) {
      isPlaying.value = videoController!.value.isPlaying;
    }
  }

  void _updateBufferingState() {
    if (videoController != null && videoController!.value.isInitialized) {
      final isBufferingNow = videoController!.value.isBuffering;
      if (isBufferingNow != isBuffering.value) {
        isBuffering.value = isBufferingNow;
        if (isBufferingNow) {
          _showBufferingIndicator();
        }
      }
    }
  }

  Future<void> _startPlayback() async {
    // Small delay for smoother start
    await Future.delayed(const Duration(milliseconds: 100));
    await videoController!.play();
    isPlaying.value = true;
  }

  // ==================== PROGRESS UPDATES ====================
  void _startProgressUpdates() {
    _progressTimer?.cancel();
    // ✅ Use 500ms interval (reduced CPU usage)
    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _updateProgress(),
    );
  }

  void _updateProgress() {
    if (_isDisposed ||
        videoController == null ||
        !videoController!.value.isInitialized) {
      return;
    }

    position.value = videoController!.value.position;
    duration.value = videoController!.value.duration;

    // Update buffered position
    final buffered = videoController!.value.buffered;
    if (buffered.isNotEmpty) {
      bufferedPosition.value = buffered.last.end;
    }
  }

  // ==================== BUFFERING HANDLING ====================
  void _showBufferingIndicator() {
    if (_isDisposed) return;

    // Show buffering indicator after short delay
    _bufferingTimer?.cancel();
    _bufferingTimer = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && isBuffering.value) {
        // Show buffering UI through UI state
      }
    });
  }

  // ==================== VIEW TRACKING ====================
  void _setupViewTracking() {
    if (videoController == null) return;

    videoController!.addListener(() {
      if (_shouldTrackView()) {
        _incrementUniqueViewCount();
      }
    });
  }

  bool _shouldTrackView() {
    return !_isDisposed &&
        !hasViewed.value &&
        !_isUpdatingView &&
        videoController != null &&
        videoController!.value.isInitialized &&
        _hasReachedViewThreshold();
  }

  bool _hasReachedViewThreshold() {
    final currentPosition = position.value.inSeconds;
    final videoDuration = duration.value.inSeconds;

    // Track at 30 seconds or halfway
    return currentPosition >= VideoPlayerConstants.viewThresholdSeconds ||
        (videoDuration > 0 &&
            currentPosition >=
                (videoDuration * VideoPlayerConstants.viewThresholdPercentage)
                    .floor());
  }

  Future<void> _incrementUniqueViewCount() async {
    if (_isDisposed || hasViewed.value || _isUpdatingView) return;

    final user = _auth.currentUser;
    if (user == null) {
      _isUpdatingView = false;
      return;
    }

    _isUpdatingView = true;

    try {
      final videoRef = _firestore.collection('recipe_videos').doc(videoId);

      // Check if already viewed
      final viewRef = videoRef.collection('views').doc(user.uid);
      final viewDoc = await viewRef.get();

      if (!viewDoc.exists) {
        await viewRef.set({
          'userId': user.uid,
          'userName': user.displayName ?? 'User',
          'userImage': user.photoURL ?? '',
          'viewedAt': FieldValue.serverTimestamp(),
          'watchDuration': position.value.inSeconds,
        });

        await videoRef.update({'views': FieldValue.increment(1)});

        hasViewed.value = true;
        viewsCount.value++;
        print('👁️ View tracked for video: $videoId');
      } else {
        hasViewed.value = true;
        // Update watch duration
        await viewRef.update({
          'watchDuration': FieldValue.increment(position.value.inSeconds),
          'lastViewedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('❌ View Error: $e');
    }

    _isUpdatingView = false;
  }

  // ==================== CONNECTIVITY ====================
  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );
      if (hasConnection && errorMessage.value.isNotEmpty) {
        _handleReconnection();
      }
    });
  }

  void _handleReconnection() {
    print('🌐 Reconnected, attempting to resume...');
    if (videoController != null && !videoController!.value.isInitialized) {
      _retryCount = 0;
      _initializeAndPlay();
    }
  }

  // ==================== DATA FETCHING ====================
  Future<void> _fetchData() async {
    try {
      await Future.wait([fetchVideoStats(), checkIfLiked(), _fetchUserData()]);
      checkIfFollowing();
      listenFollowerCount();
    } catch (e) {
      print('❌ Error fetching data: $e');
    }
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
      print('❌ Error fetching stats: $e');
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
      print('❌ Error checking like: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Fetch user data for caching
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        // Cache user data if needed
      }
    } catch (e) {
      print('❌ Error fetching user data: $e');
    }
  }

  // ==================== FOLLOW SYSTEM ====================
  void checkIfFollowing() {
    final user = _auth.currentUser;

    if (user == null || user.uid == userId) {
      isFollowing.value = false;
      return;
    }

    _followSubscription?.cancel();

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
            }
          },
          onError: (error) {
            print('❌ Follow listener error: $error');
            isFollowing.value = false;
          },
        );
  }

  void listenFollowerCount() {
    _followerCountSubscription?.cancel();

    _followerCountSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('followers')
        .snapshots()
        .listen(
          (snapshot) {
            if (!_isDisposed) {
              followerCount.value = snapshot.size;
            }
          },
          onError: (error) {
            print('❌ Follower count error: $error');
            followerCount.value = 0;
          },
        );
  }

  Future<void> toggleFollow() async {
    if (isFollowingLoading.value) return;

    final user = _auth.currentUser;

    if (user == null) {
      _showSnackbar('Login Required', 'Please login first', Colors.orange);
      return;
    }

    if (user.uid == userId) {
      _showSnackbar('Info', 'You cannot follow yourself', Colors.blue);
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
        // Unfollow
        await followerRef.delete();
        await followingRef.delete();

        _showSnackbar(
          'Unfollowed',
          'You unfollowed $channelName',
          Colors.grey,
          duration: 1,
        );
      } else {
        // Follow
        final userData = {
          'followerId': user.uid,
          'userName': user.displayName ?? 'User',
          'userImage': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        };

        await followerRef.set(userData);
        await followingRef.set({
          'followingId': userId,
          'followingName': channelName,
          'followingImage': channelImage,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Send notification
        await _sendFollowNotification(user);

        _showSnackbar(
          'Following',
          'You are now following $channelName',
          Colors.green,
          duration: 1,
        );
      }
    } catch (e) {
      print('❌ Follow error: $e');
      _showSnackbar('Error', 'Failed to follow/unfollow', Colors.red);
    } finally {
      isFollowingLoading.value = false;
    }
  }

  Future<void> _sendFollowNotification(User user) async {
    try {
      await _firestore.collection('notifications').add({
        'type': 'follow',
        'userId': userId,
        'actorId': user.uid,
        'actorName': user.displayName ?? 'User',
        'actorImage': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('❌ Notification error: $e');
    }
  }

  // ==================== VIDEO CONTROLS ====================
  void playPause() {
    if (!isInitialized.value || videoController == null || _isDisposed) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
      isPlaying.value = false;
      showControls.value = true;
      _hideControlsTimer?.cancel();
    } else {
      videoController!.play();
      isPlaying.value = true;
      _startHideControlsTimer();
    }
    update();
  }

  void forward10Seconds() {
    if (!isInitialized.value || videoController == null || _isDisposed) return;

    final newPosition = position.value + const Duration(seconds: 10);
    if (newPosition < duration.value) {
      _seekTo(newPosition);
    } else {
      _seekTo(duration.value);
    }
    _showControlOverlay();
  }

  void rewind10Seconds() {
    if (!isInitialized.value || videoController == null || _isDisposed) return;

    final newPosition = position.value - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _seekTo(newPosition);
    } else {
      _seekTo(Duration.zero);
    }
    _showControlOverlay();
  }

  void _seekTo(Duration position) {
    if (videoController == null || _isDisposed) return;
    videoController!.seekTo(position);
    this.position.value = position;
  }

  void toggleMute() {
    if (videoController == null || _isDisposed) return;

    isMuted.value = !isMuted.value;
    videoController!.setVolume(isMuted.value ? 0 : volume.value);
  }

  void setVolume(double value) {
    if (videoController == null || _isDisposed) return;

    volume.value = value.clamp(0.0, 1.0);
    if (!isMuted.value) {
      videoController!.setVolume(volume.value);
    }
  }

  void _showControlOverlay() {
    if (_isDisposed) return;

    showControls.value = true;
    _hideControlsTimer?.cancel();

    if (isPlaying.value) {
      _startHideControlsTimer();
    }
  }

  void toggleControls() {
    if (_isDisposed) return;

    showControls.value = !showControls.value;

    if (showControls.value) {
      _hideControlsTimer?.cancel();
      if (isPlaying.value) {
        _startHideControlsTimer();
      }
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(
      Duration(seconds: VideoPlayerConstants.controlsHideDelaySeconds),
      () {
        if (!_isDisposed && isPlaying.value) {
          showControls.value = false;
        }
      },
    );
  }

  // ==================== LIKE SYSTEM ====================
  Future<void> toggleLike() async {
    final user = _auth.currentUser;

    if (user == null) {
      _showSnackbar(
        'Login Required',
        'Please login to like videos',
        Colors.orange,
      );
      return;
    }

    try {
      final videoRef = _firestore.collection('recipe_videos').doc(videoId);
      final likeRef = videoRef.collection('likes').doc(user.uid);
      final likeDoc = await likeRef.get();

      if (likeDoc.exists) {
        // Unlike
        await likeRef.delete();
        await videoRef.update({'likes': FieldValue.increment(-1)});

        isLiked.value = false;
        likeCount.value--;
      } else {
        // Like
        await likeRef.set({
          'userId': user.uid,
          'userEmail': user.email,
          'userName': user.displayName,
          'userImage': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await videoRef.update({'likes': FieldValue.increment(1)});

        isLiked.value = true;
        likeCount.value++;

        // Send like notification
        if (!isOwner) {
          await _sendLikeNotification(user);
        }
      }
    } catch (e) {
      print('❌ Like error: $e');
      _showSnackbar('Error', 'Failed to like video', Colors.red);
    }
  }

  Future<void> _sendLikeNotification(User user) async {
    try {
      await _firestore.collection('notifications').add({
        'type': 'like',
        'videoId': videoId,
        'videoTitle': videoTitle,
        'userId': userId,
        'actorId': user.uid,
        'actorName': user.displayName ?? 'User',
        'actorImage': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('❌ Like notification error: $e');
    }
  }

  // ==================== SHARE SYSTEM ====================
  Future<void> shareVideo() async {
    try {
      final shareText = _buildShareText();
      await Share.share(shareText, subject: videoTitle);

      // Increment share count
      await _firestore.collection('recipe_videos').doc(videoId).update({
        'shares': FieldValue.increment(1),
      });

      _showSnackbar(
        'Success',
        'Shared successfully!',
        Colors.green,
        duration: 1,
      );
    } catch (e) {
      print('❌ Share error: $e');
      _showSnackbar('Error', 'Could not share video', Colors.red);
    }
  }

  String _buildShareText() {
    final durationText = _formatDurationForShare();
    return '''
🍲 Check out this recipe video!

📹 $videoTitle
👨‍🍳 By: $channelName
⏱️ Duration: $durationText
👀 Views: ${viewsCount.value.formatNumber()}
❤️ Likes: ${likeCount.value.formatNumber()}

Watch now in Racha Ruchi App!
''';
  }

  String _formatDurationForShare() {
    if (duration.value.inHours > 0) {
      return '${duration.value.inHours}h ${duration.value.inMinutes.remainder(60)}m';
    }
    return '${duration.value.inMinutes} min';
  }

  // ==================== REPORT SYSTEM ====================
  Future<bool> reportVideo({required String reason}) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        _showSnackbar('Login Required', 'Please login first', Colors.orange);
        return false;
      }

      await _firestore.collection('reports').add({
        'videoId': videoId,
        'videoTitle': videoTitle,
        'videoOwnerId': userId,
        'reason': reason,
        'reportedBy': user.uid,
        'reportedByEmail': user.email,
        'reportedByName': user.displayName,
        'reportedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'reviewed': false,
      });

      _showSnackbar(
        'Reported',
        'Thanks for your feedback. We will review it.',
        Colors.green,
      );
      return true;
    } catch (e) {
      print('❌ Report error: $e');
      _showSnackbar('Error', 'Failed to report video', Colors.red);
      return false;
    }
  }

  // ==================== COMMENTS ====================
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

  // ==================== REPORT BOTTOM SHEET ====================
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
            ..._buildReportOptions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  List<Widget> _buildReportOptions() {
    final reports = [
      ('Spam or misleading', 'spam'),
      ('Violent content', 'violence'),
      ('Hateful content', 'hate'),
      ('Sexual content', 'sexual'),
      ('Copyright issue', 'copyright'),
      ('Other', 'other'),
    ];

    return reports.map((report) {
      return ListTile(
        leading: const Icon(Iconsax.warning_2, color: Colors.red),
        title: Text(report.$1),
        onTap: () async {
          Get.back();
          await reportVideo(reason: report.$2);
        },
      );
    }).toList();
  }

  // ==================== ERROR HANDLING ====================
  void _handleInitializationError(dynamic error) {
    print('❌ Video Player Error: $error');

    if (_retryCount < VideoPlayerConstants.maxRetryAttempts) {
      _retryCount++;
      print(
        '🔄 Retry attempt $_retryCount/${VideoPlayerConstants.maxRetryAttempts}',
      );

      Future.delayed(VideoPlayerConstants.retryDelay, () {
        if (!_isDisposed) {
          _initializeAndPlay();
        }
      });
      return;
    }

    isLoading.value = false;
    errorMessage.value = _getErrorMessage(error.toString());
  }

  String _getErrorMessage(String error) {
    if (error.contains('404')) return 'Video not found or has been removed.';
    if (error.contains('403')) return 'Access denied. Please try again.';
    if (error.contains('Network') || error.contains('Connection')) {
      return 'Network error. Please check your connection.';
    }
    if (error.contains('HLS')) return 'This video format is not supported.';
    if (error.contains('Timeout')) {
      return 'Loading timed out. Please try again.';
    }
    if (error.contains('Source error')) {
      return 'Video format not supported or video is still processing. Please wait and try again.';
    }
    return 'Failed to load video. Please try again.';
  }

  void retry() {
    _retryCount = 0;
    _initializeAndPlay();
  }

  // ==================== UTILITIES ====================
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showSnackbar(
    String title,
    String message,
    Color color, {
    int duration = 2,
  }) {
    if (_isDisposed) return;

    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // ==================== DISPOSAL ====================
  void _disposeResources() {
    if (_isDisposed) return;

    _isDisposed = true;

    // Cancel all timers
    _progressTimer?.cancel();
    _hideControlsTimer?.cancel();
    _bufferingTimer?.cancel();
    _connectionCheckTimer?.cancel();

    // Cancel subscriptions
    _followSubscription?.cancel();
    _followerCountSubscription?.cancel();
    _connectivitySubscription?.cancel();

    // Dispose video controller
    if (videoController != null) {
      videoController!.removeListener(() {});
      videoController!.dispose();
      videoController = null;
    }

    print('🗑️ VideoPlayerController disposed');
  }
}

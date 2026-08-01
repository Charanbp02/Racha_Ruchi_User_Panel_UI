// lib/App/Modules/All_Videos/controller/videos_controller.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/Categories/controller/category_controller.dart';

class VideosController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var allVideos = <VideoModel>[].obs;
  var filteredVideos = <VideoModel>[].obs;
  var isLoading = true.obs;
  var isConnected = true.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var newVideosCount = 0.obs;
  ScrollController? videoScrollController;

  late StreamSubscription<QuerySnapshot> _videosSubscription;
  late StreamSubscription<QuerySnapshot> _usersSubscription;
  final Set<String> _processedVideoIds = {};

  // Cache for user profile images
  final Map<String, UserProfileCache> _userProfileCache = {};
  Timer? _cacheCleanupTimer;

  final List<String> categories = [
    'All',
    'Cooking',
    'Biryani',
    'Dessert',
    'Street Food',
    'Healthy',
  ];

  void scrollToNewVideos() {
    videoScrollController?.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    newVideosCount.value = 0;
  }

  @override
  void onInit() {
    super.onInit();
    _initRealtimeUpdates();
    _listenToUserProfileChanges();
    _startCacheCleanupTimer();
  }

  @override
  void onClose() {
    _videosSubscription.cancel();
    _usersSubscription.cancel();
    _cacheCleanupTimer?.cancel();
    super.onClose();
  }

  /// Start cache cleanup timer to remove old cache entries
  void _startCacheCleanupTimer() {
    _cacheCleanupTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _cleanupCache();
    });
  }

  /// Remove cache entries older than 30 minutes
  void _cleanupCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    _userProfileCache.forEach((key, value) {
      if (now.difference(value.lastUpdated).inMinutes > 30) {
        keysToRemove.add(key);
      }
    });

    for (var key in keysToRemove) {
      _userProfileCache.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      print('🧹 Cleaned up ${keysToRemove.length} expired cache entries');
    }
  }

  /// Listen to all user profile changes to update avatars in real-time
  void _listenToUserProfileChanges() {
    _usersSubscription = _firestore
        .collection('users')
        .snapshots()
        .listen(
          (snapshot) {
            final now = DateTime.now();

            for (var doc in snapshot.docs) {
              final data = doc.data();
              final userId = doc.id;
              final newImageUrl = data['imageUrl'] ?? '';
              final userName = data['name'] ?? '';

              // Check if cache exists and is still valid (less than 5 minutes old)
              final cached = _userProfileCache[userId];
              final bool shouldUpdate =
                  cached == null ||
                  now.difference(cached.lastUpdated).inMinutes > 5 ||
                  cached.imageUrl != newImageUrl ||
                  cached.name != userName;

              if (shouldUpdate) {
                // Update cache
                _userProfileCache[userId] = UserProfileCache(
                  imageUrl: newImageUrl,
                  name: userName,
                  lastUpdated: now,
                );

                // Update videos for this user in real-time
                _updateUserProfileInVideos(userId, newImageUrl, userName);

                print(
                  '🔄 Real-time update for user: $userId at ${now.toString()}',
                );
              } else {
                print('⏳ Cache valid for user: $userId, skipping update');
              }
            }
          },
          onError: (error) {
            print('❌ Error listening to user profiles: $error');
            isConnected.value = false;
          },
        );
  }

  /// Update user profile info in all videos
  void _updateUserProfileInVideos(
    String userId,
    String newImageUrl,
    String newUserName,
  ) {
    bool updated = false;
    final now = DateTime.now();

    // Update in allVideos
    for (int i = 0; i < allVideos.length; i++) {
      final video = allVideos[i];
      if (video.channelId == userId) {
        final updatedVideo = video.copyWith(
          channelAvatar:
              newImageUrl.isNotEmpty ? newImageUrl : video.channelAvatar,
          channelName: newUserName.isNotEmpty ? newUserName : video.channelName,
        );
        allVideos[i] = updatedVideo;
        updated = true;
      }
    }

    // Update in filteredVideos
    for (int i = 0; i < filteredVideos.length; i++) {
      final video = filteredVideos[i];
      if (video.channelId == userId) {
        final updatedVideo = video.copyWith(
          channelAvatar:
              newImageUrl.isNotEmpty ? newImageUrl : video.channelAvatar,
          channelName: newUserName.isNotEmpty ? newUserName : video.channelName,
        );
        filteredVideos[i] = updatedVideo;
        updated = true;
      }
    }

    if (updated) {
      print('✅ Updated profile for user: $userId at ${now.toString()}');
    }
  }

  void _initRealtimeUpdates() {
    isLoading.value = true;

    try {
      _videosSubscription = _firestore
          .collection('recipe_videos')
          .where('visibility', isEqualTo: 'visible')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              print(
                '🔄 Real-time update received: ${snapshot.docs.length} videos',
              );
              isConnected.value = true;

              final List<VideoModel> fetchedVideos = [];
              final now = DateTime.now();

              for (var doc in snapshot.docs) {
                final video = VideoModel.fromFirestore(doc);

                // Check if we have a cached profile for this user
                if (_userProfileCache.containsKey(video.channelId)) {
                  final cached = _userProfileCache[video.channelId]!;
                  // Use cache if it's still valid (less than 5 minutes old)
                  if (cached.imageUrl.isNotEmpty &&
                      now.difference(cached.lastUpdated).inMinutes < 5) {
                    final updatedVideo = video.copyWith(
                      channelAvatar: cached.imageUrl,
                      channelName:
                          cached.name.isNotEmpty
                              ? cached.name
                              : video.channelName,
                    );
                    fetchedVideos.add(updatedVideo);
                    continue;
                  }
                }
                fetchedVideos.add(video);
              }

              _checkForNewVideos(fetchedVideos);
              allVideos.value = fetchedVideos;
              filterVideos();
              isLoading.value = false;
            },
            onError: (error) {
              print('❌ Real-time stream error: $error');
              isConnected.value = false;
              isLoading.value = false;
            },
          );
    } catch (e) {
      print('❌ Failed to initialize stream: $e');
      isLoading.value = false;
      isConnected.value = false;
    }
  }

  void _checkForNewVideos(List<VideoModel> newVideos) {
    final currentIds = allVideos.map((v) => v.id).toSet();
    final newIds = newVideos.map((v) => v.id).toSet();
    final addedIds = newIds.difference(currentIds);

    if (addedIds.isNotEmpty) {
      newVideosCount.value = addedIds.length;
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    filterVideos();
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    filterVideos();
  }

  void filterVideos() {
    var filtered = List<VideoModel>.from(allVideos);

    if (selectedCategory.value != 'All') {
      filtered =
          filtered.where((video) {
            return video.category.toLowerCase() ==
                    selectedCategory.value.toLowerCase() ||
                video.tags.any(
                  (tag) => tag.toLowerCase().contains(
                    selectedCategory.value.toLowerCase(),
                  ),
                );
          }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered =
          filtered.where((video) {
            return video.title.toLowerCase().contains(query) ||
                video.channelName.toLowerCase().contains(query) ||
                video.description.toLowerCase().contains(query) ||
                video.tags.any((tag) => tag.toLowerCase().contains(query));
          }).toList();
    }

    filteredVideos.value = filtered;

    print(
      '📊 Filtered: ${filtered.length} videos (Category: ${selectedCategory.value})',
    );
  }

  void resetToAll() {
    selectedCategory.value = 'All';
    searchQuery.value = '';
    filterVideos();

    if (Get.isRegistered<CategoryController>()) {
      final categoryController = Get.find<CategoryController>();
      categoryController.selectedIndex.value = 0;
    }
  }

  void playVideo(VideoModel video) {
    print('🎬 Playing video: ${video.title}');
    Get.toNamed('/video-player', arguments: video);
  }

  void navigateToChannel(String channelId) {
    Get.toNamed('/channel/$channelId');
  }

  Future<void> likeVideo(VideoModel video) async {
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
      final videoRef = _firestore.collection('recipe_videos').doc(video.id);
      final likeRef = videoRef.collection('likes').doc(user.uid);
      final likeDoc = await likeRef.get();

      if (likeDoc.exists) {
        await likeRef.delete();
        await videoRef.update({'likes': FieldValue.increment(-1)});
      } else {
        await likeRef.set({
          'userId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await videoRef.update({'likes': FieldValue.increment(1)});
      }
    } catch (e) {
      print('Error liking video: $e');
    }
  }

  Future<bool> isVideoLiked(String videoId) async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      final likeDoc =
          await _firestore
              .collection('recipe_videos')
              .doc(videoId)
              .collection('likes')
              .doc(user.uid)
              .get();
      return likeDoc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> reportVideo({
    required VideoModel video,
    required String reason,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return false;

      await _firestore.collection('reports').add({
        'videoId': video.id,
        'videoTitle': video.title,
        'reason': reason,
        'reportedBy': user.uid,
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
      );
      return false;
    }
  }

  void refreshVideos() {
    Get.snackbar(
      'Refreshing',
      'Checking for new videos...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
    // Force refresh by re-fetching
    _initRealtimeUpdates();
  }

  /// Manual refresh for specific user profile
  Future<void> refreshUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final imageUrl = data['imageUrl'] ?? '';
        final userName = data['name'] ?? '';

        // Force update cache
        _userProfileCache[userId] = UserProfileCache(
          imageUrl: imageUrl,
          name: userName,
          lastUpdated: DateTime.now(),
        );

        _updateUserProfileInVideos(userId, imageUrl, userName);
        print('🔄 Manually refreshed profile for user: $userId');
      }
    } catch (e) {
      print('❌ Error refreshing user profile: $e');
    }
  }

  /// Clear all cached profiles
  void clearCache() {
    _userProfileCache.clear();
    print('🧹 Cleared all profile cache');
  }

  /// Get cache stats
  Map<String, dynamic> getCacheStats() {
    final now = DateTime.now();
    int validCount = 0;
    int expiredCount = 0;

    for (var entry in _userProfileCache.values) {
      if (now.difference(entry.lastUpdated).inMinutes < 30) {
        validCount++;
      } else {
        expiredCount++;
      }
    }

    return {
      'total': _userProfileCache.length,
      'valid': validCount,
      'expired': expiredCount,
    };
  }
}

/// Cache model for user profile
class UserProfileCache {
  final String imageUrl;
  final String name;
  final DateTime lastUpdated;

  UserProfileCache({
    required this.imageUrl,
    required this.name,
    required this.lastUpdated,
  });

  @override
  String toString() {
    return 'UserProfileCache(imageUrl: $imageUrl, name: $name, lastUpdated: $lastUpdated)';
  }
}

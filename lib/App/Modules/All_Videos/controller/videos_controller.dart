// lib/App/Modules/All_Videos/controller/videos_controller.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';

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
  final Set<String> _processedVideoIds = {};

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
  }

  @override
  void onClose() {
    _videosSubscription.cancel();
    super.onClose();
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

              for (var doc in snapshot.docs) {
                final video = VideoModel.fromFirestore(doc);
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
                video.description.toLowerCase().contains(query);
          }).toList();
    }

    filteredVideos.value = filtered;
  }

  void playVideo(VideoModel video) {
    print('🎬 Playing video: ${video.title}');
    print('📹 Video URL: ${video.videoUrl}');

    void playVideo(VideoModel video) {
      print('🎬 Playing video: ${video.title}');
      print('📹 Video URL: ${video.videoUrl}');

      Get.toNamed('/video-player', arguments: video);
    }

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
  }
}

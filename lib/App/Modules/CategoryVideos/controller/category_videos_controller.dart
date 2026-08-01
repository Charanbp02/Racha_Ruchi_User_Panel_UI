// lib/App/Modules/CategoryVideos/controller/category_videos_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';

class CategoryVideosController extends GetxController {
  var videos = <VideoModel>[].obs;
  var isLoading = true.obs;
  var categoryId = ''.obs;
  var categoryName = ''.obs;
  var categoryIcon = ''.obs;
  var searchQuery = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _videosSubscription;

  // ✅ Get filtered videos based on search
  List<VideoModel> get filteredVideos {
    if (searchQuery.value.isEmpty) {
      return videos;
    }
    final query = searchQuery.value.toLowerCase();
    return videos.where((video) {
      return video.title.toLowerCase().contains(query) ||
          video.description.toLowerCase().contains(query) ||
          video.channelName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Get category data from arguments
    if (Get.arguments != null) {
      categoryId.value = Get.arguments['categoryId'] ?? '';
      categoryName.value = Get.arguments['categoryName'] ?? 'Category';
      categoryIcon.value = Get.arguments['categoryIcon'] ?? '📁';
    }
    fetchCategoryVideos();
  }

  @override
  void onClose() {
    _videosSubscription?.cancel();
    super.onClose();
  }

  // ✅ Fetch videos by category in real-time
  void fetchCategoryVideos() {
    if (categoryId.value.isEmpty) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    _videosSubscription?.cancel();

    _videosSubscription = _firestore
        .collection('recipe_videos')
        .where('categoryId', isEqualTo: categoryId.value)
        .where('visibility', isEqualTo: 'visible')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            print('🔄 Category videos update: ${snapshot.docs.length} videos');

            videos.value =
                snapshot.docs.map((doc) {
                  return VideoModel.fromFirestore(doc);
                }).toList();

            isLoading.value = false;
          },
          onError: (error) {
            print('❌ Category videos stream error: $error');
            isLoading.value = false;
          },
        );
  }

  // ✅ Play video
  void playVideo(VideoModel video) {
    Get.toNamed('/video-player', arguments: video);
  }

  // ✅ Navigate to channel
  void navigateToChannel(String channelId) {
    Get.toNamed('/channel/$channelId');
  }

  // ✅ Refresh videos
  Future<void> refreshVideos() async {
    fetchCategoryVideos();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }
}

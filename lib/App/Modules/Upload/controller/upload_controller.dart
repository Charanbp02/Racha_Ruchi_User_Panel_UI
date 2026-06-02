import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadController extends GetxController {
  var selectedVideoPath = ''.obs;
  var selectedThumbnailUrl = ''.obs;
  var videoTitle = ''.obs;
  var videoDescription = ''.obs;
  var selectedCategory = ''.obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  var videoPlayerController = Rx<VideoPlayerController?>(null);
  var isVideoPlaying = false.obs;
  var selectedTags = <String>[].obs;
  var videoDuration = ''.obs;
  var videoDurationInSeconds = 0.obs;
  var videoType = ''.obs;
  var selectedCategoryName = ''.obs;
  var thumbnailFile = Rx<File?>(null);
  var uploadType = ''.obs;
  var isUploadMinimized = false.obs; // New: track minimized state

  var ingredients = <Ingredient>[].obs;
  var ingredientTextController = TextEditingController();
  var ingredientQuantityController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // For proper upload cancellation
  UploadTask? _currentUploadTask;
  // For memory leak prevention
  StreamSubscription<TaskSnapshot>? _uploadSubscription;

  // Callbacks for minimize/restore
  Function? onUploadMinimized;
  Function? onUploadRestored;

  var categories =
      <VideoCategory>[
        VideoCategory(id: '1', name: 'Cooking', icon: '🍳'),
        VideoCategory(id: '2', name: 'Recipe', icon: '📝'),
        VideoCategory(id: '3', name: 'Biryani', icon: '🍚'),
        VideoCategory(id: '4', name: 'Dessert', icon: '🍰'),
        VideoCategory(id: '5', name: 'Street Food', icon: '🌮'),
        VideoCategory(id: '6', name: 'Healthy', icon: '🥗'),
      ].obs;

  var suggestedTags =
      [
        'Easy Recipe',
        'Quick Cooking',
        'Indian Food',
        'Home Cooking',
        'Tasty Food',
        'Veg Recipe',
        'Non Veg Recipe',
      ].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['uploadType'] != null) {
      uploadType.value = Get.arguments['uploadType'];
      print('📹 Upload type selected: ${uploadType.value}');
    }
  }

  @override
  void onClose() {
    // Dispose video player
    videoPlayerController.value?.dispose();

    // Dispose text controllers
    ingredientTextController.dispose();
    ingredientQuantityController.dispose();

    // Dispose VideoCompress to prevent memory leak
    VideoCompress.dispose();

    // Cancel upload subscription if exists
    _uploadSubscription?.cancel();

    // Clear cache
    _clearCache();

    super.onClose();
  }

  // ==================== CACHE MANAGEMENT ====================

  Future<void> _clearCache() async {
    try {
      await VideoCompress.deleteAllCache();
      print('🗑️ Video compress cache cleared');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  // ==================== AUTHENTICATION CHECK ====================

  Future<bool> ensureAuthenticated() async {
    final user = _auth.currentUser;

    if (user == null) {
      await Get.dialog(
        AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to upload videos'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
      return false;
    }

    try {
      await user.getIdToken(true);
      print('✅ User authenticated: ${user.email}');
      print('🆔 User UID: ${user.uid}');
      return true;
    } catch (e) {
      print('❌ Token refresh failed: $e');
      Get.snackbar(
        'Session Expired',
        'Please login again',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // ==================== TEST STORAGE ACCESS ====================

  Future<void> testStorageAccess() async {
    final isAuth = await ensureAuthenticated();
    if (!isAuth) return;

    try {
      print('🔧 Testing storage access...');
      final testRef = _storage.ref().child('test/connection_test.txt');
      await testRef.putString('Test connection at ${DateTime.now()}');
      print('✅ Storage write successful');

      final url = await testRef.getDownloadURL();
      print('✅ Storage read successful: $url');

      await testRef.delete();
      print('✅ Storage delete successful');

      Get.snackbar('Success', 'Storage is working!');
    } catch (e) {
      print('❌ Storage test failed: $e');
      Get.snackbar('Error', 'Storage test failed: ${e.toString()}');
    }
  }

  // ==================== INGREDIENT METHODS ====================

  void addIngredient() {
    String name = ingredientTextController.text.trim();
    String quantity = ingredientQuantityController.text.trim();

    if (name.isNotEmpty) {
      ingredients.add(
        Ingredient(
          name: name,
          quantity: quantity.isEmpty ? 'To taste' : quantity,
        ),
      );
      ingredientTextController.clear();
      ingredientQuantityController.clear();
    }
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
  }

  void updateIngredient(int index, String name, String quantity) {
    if (name.isNotEmpty) {
      ingredients[index] = Ingredient(name: name, quantity: quantity);
      ingredients.refresh();
    }
  }

  Future<void> pickVideo() async {
    try {
      final status = await Permission.photos.request();
      final videoStatus = await Permission.videos.request();

      if (!status.isGranted && !videoStatus.isGranted) {
        Get.snackbar(
          'Permission Needed',
          'Please allow gallery access to pick video',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final ImagePicker picker = ImagePicker();

      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 25),
      );

      if (video == null) {
        print("User cancelled video pick");
        return;
      }

      videoPlayerController.value?.dispose();
      videoPlayerController.value = VideoPlayerController.file(
        File(video.path),
      );

      await videoPlayerController.value!.initialize();

      final duration = videoPlayerController.value!.value.duration;
      final seconds = duration.inSeconds;

      // Minimum 25 seconds
      if (seconds < 25) {
        Get.snackbar(
          'Video Too Short',
          'Video must be at least 25 seconds',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        videoPlayerController.value?.dispose();
        videoPlayerController.value = null;
        return;
      }

      // Maximum 25 minutes
      if (seconds > 1500) {
        Get.snackbar(
          'Video Too Long',
          'Maximum video length is 25 minutes',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        videoPlayerController.value?.dispose();
        videoPlayerController.value = null;
        return;
      }

      // Save video only after validation passes
      selectedVideoPath.value = video.path;

      videoDurationInSeconds.value = seconds;
      videoDuration.value = _formatDuration(duration);

      await _generateThumbnail(video.path);
    } catch (e) {
      print("❌ Pick video error: $e");
    }
  }

  Future<void> _generateThumbnail(String videoPath) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 720,
        quality: 80,
        timeMs: 0,
      );

      if (uint8list != null) {
        final tempDir = await getTemporaryDirectory();
        final thumbnailFile_ = File(
          '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await thumbnailFile_.writeAsBytes(uint8list);
        thumbnailFile.value = thumbnailFile_;
        selectedThumbnailUrl.value = thumbnailFile_.path;
      }
    } catch (e) {
      print('Error generating thumbnail: $e');
      selectedThumbnailUrl.value = videoPath;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void toggleVideoPlay() {
    if (videoPlayerController.value == null) return;
    if (isVideoPlaying.value) {
      videoPlayerController.value!.pause();
      isVideoPlaying.value = false;
    } else {
      videoPlayerController.value!.play();
      isVideoPlaying.value = true;
    }
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void selectCategory(String categoryId) {
    selectedCategory.value = categoryId;
    final category = categories.firstWhere((cat) => cat.id == categoryId);
    selectedCategoryName.value = category.name;

    for (var i = 0; i < categories.length; i++) {
      categories[i].isSelected = categories[i].id == categoryId;
    }
    categories.refresh();
  }

  // ==================== MINIMIZE / RESTORE METHODS ====================

  void minimizeUpload() {
    if (isUploading.value) {
      isUploadMinimized.value = true;
      onUploadMinimized?.call();

      Get.snackbar(
        'Upload in Progress',
        'Your video is being uploaded in the background',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF0095F6),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void restoreUpload() {
    if (isUploading.value) {
      isUploadMinimized.value = false;
      onUploadRestored?.call();
    }
  }

  // ==================== VIDEO COMPRESSION ====================

  Future<File?> compressVideo(String videoPath) async {
    try {
      print("🎬 Starting video compression...");

      // Get original file size
      final originalFile = File(videoPath);
      final originalSize = await originalFile.length();
      print(
        "📊 Original size: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB",
      );

      // Use medium quality for better balance
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (mediaInfo?.file != null) {
        final compressedSize = await mediaInfo!.file!.length();
        print("✅ Compression successful");
        print(
          "📊 Compressed size: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB",
        );
        print(
          "📊 Compression ratio: ${((compressedSize / originalSize) * 100).toStringAsFixed(1)}%",
        );
        return mediaInfo.file;
      }

      return null;
    } catch (e) {
      print("❌ Compression Error: $e");
      return null;
    }
  }

  // ==================== UPLOAD VIDEO ====================

  Future<void> uploadVideo() async {
    // Check authentication
    final isAuthenticated = await ensureAuthenticated();
    if (!isAuthenticated) return;

    if (selectedVideoPath.isEmpty) {
      Get.snackbar('Error', 'Please select a video');
      return;
    }

    if (videoTitle.value.isEmpty) {
      Get.snackbar('Error', 'Please enter video title');
      return;
    }

    if (ingredients.isEmpty) {
      Get.snackbar('Error', 'Please add at least one ingredient');
      return;
    }

    isUploading.value = true;
    isUploadMinimized.value = false;
    uploadProgress.value = 0.0;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uid = _auth.currentUser!.uid;
      final File originalVideo = File(selectedVideoPath.value);

      if (!await originalVideo.exists()) {
        throw Exception('Video file does not exist');
      }

      // Step 1: Compression (0% - 10%)
      // Step 1: Check file size
      uploadProgress.value = 0.02;

      final originalSizeMB = await originalVideo.length() / (1024 * 1024);

      print("📊 Original size: ${originalSizeMB.toStringAsFixed(2)} MB");

      File videoFile;

      if (originalSizeMB > 80) {
        print("🎬 Large video detected, compressing...");

        File? compressedVideo = await compressVideo(selectedVideoPath.value);

        videoFile = compressedVideo ?? originalVideo;

        print("✅ Compression complete");
      } else {
        print("⚡ Small video detected, skipping compression");
        videoFile = originalVideo;
      }

      uploadProgress.value = 0.10;

      // Step 2: Upload video (10% - 60%)
      final videoRef = _storage.ref().child(
        'recipe_videos/$uid/$timestamp/video.mp4',
      );

      _currentUploadTask = videoRef.putFile(
        videoFile,
        SettableMetadata(contentType: 'video/mp4'),
      );

      // Track upload progress properly
      _uploadSubscription = _currentUploadTask!.snapshotEvents.listen((
        TaskSnapshot snapshot,
      ) {
        if (snapshot.totalBytes > 0) {
          // Map upload progress from 10% to 60%
          final uploadPercent = snapshot.bytesTransferred / snapshot.totalBytes;
          final mappedProgress = 0.10 + (uploadPercent * 0.50);
          uploadProgress.value = mappedProgress.clamp(0.10, 0.60);
          print("📤 Upload: ${(uploadPercent * 100).toStringAsFixed(1)}%");
        }
      });

      // Wait for upload to complete
      final taskSnapshot = await _currentUploadTask!.snapshotEvents.last;
      final videoUrl = await taskSnapshot.ref.getDownloadURL();

      uploadProgress.value = 0.60;
      print("✅ Video uploaded: $videoUrl");

      // Step 3: Upload thumbnail (60% - 80%)
      String thumbnailUrl = videoUrl;

      if (thumbnailFile.value != null && await thumbnailFile.value!.exists()) {
        uploadProgress.value = 0.65;
        final thumbnailRef = _storage.ref().child(
          'thumbnails/$uid/$timestamp/thumbnail.jpg',
        );

        final thumbnailUpload = await thumbnailRef.putFile(
          thumbnailFile.value!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        thumbnailUrl = await thumbnailUpload.ref.getDownloadURL();
        uploadProgress.value = 0.80;
        print("✅ Thumbnail uploaded");
      } else {
        uploadProgress.value = 0.80;
      }

      // Step 4: Save to Firestore (80% - 95%)
      uploadProgress.value = 0.85;

      final videoDocId = _firestore.collection('recipe_videos').doc().id;
      final ingredientsList =
          ingredients
              .map((ing) => {'name': ing.name, 'quantity': ing.quantity})
              .toList();
      final title = videoTitle.value.trim();
      final description = videoDescription.value.trim();

      final keywords = generateSearchKeywords(
        '$title $description ${selectedTags.join(" ")}',
      );

      final videoData = {
        'id': videoDocId,
        'title': videoTitle.value.trim(),
        'description': videoDescription.value.trim(),

        'ingredients': ingredientsList,

        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,

        'category': selectedCategoryName.value,
        'categoryId': selectedCategory.value,

        'tags': selectedTags.toList(),

        'searchKeywords': keywords,

        'duration': videoDuration.value,
        'durationInSeconds': videoDurationInSeconds.value,

        'videoType': 'long',
        'selectedUploadType': uploadType.value,

        'userId': uid,
        'createdBy': uid,

        'userName': _auth.currentUser!.displayName ?? 'User',
        'userEmail': _auth.currentUser!.email ?? '',
        'userImage': _auth.currentUser!.photoURL ?? '',

        'likes': 0,
        'views': 0,
        'comments': 0,
        'shares': 0,
        'rating': 0.0,

        'isActive': true,
        'isPopular': false,

        'visibility': 'visible',

        'adminNote': '',

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection('recipe_videos')
          .doc(videoDocId)
          .set(videoData);

      uploadProgress.value = 0.95;
      print("✅ Firestore saved");

      // Step 5: Complete (95% - 100%)
      await Future.delayed(const Duration(milliseconds: 500));
      uploadProgress.value = 1.0;

      Get.snackbar(
        'Success! 🎉',
        'Video uploaded successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      resetForm();
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    } on FirebaseException catch (e) {
      String errorMsg = 'Upload failed: ';

      if (e.code == 'canceled') {
        errorMsg = 'Upload cancelled';
        print('🛑 Upload was cancelled');
      } else if (e.code == 'permission-denied') {
        errorMsg += 'Permission denied. Make sure you are logged in.';
      } else if (e.code == 'unauthenticated') {
        errorMsg += 'Please login again.';
      } else {
        errorMsg += e.message ?? 'Unknown error';
      }

      Get.snackbar(
        'Upload Failed',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      uploadProgress.value = 0.0;
    } catch (e) {
      print('❌ Upload error: $e');
      Get.snackbar(
        'Upload Failed',
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      uploadProgress.value = 0.0;
    } finally {
      isUploading.value = false;
      isUploadMinimized.value = false;
      _currentUploadTask = null;
      await _uploadSubscription?.cancel();
      _uploadSubscription = null;

      // Clear cache after upload
      await VideoCompress.deleteAllCache();
      print('🗑️ Upload complete - Cache cleared');
    }
  }

  List<String> generateSearchKeywords(String text) {
    final words = text.toLowerCase().split(' ');

    Set<String> keywords = {};

    for (String word in words) {
      String temp = '';

      for (int i = 0; i < word.length; i++) {
        temp += word[i];
        keywords.add(temp);
      }

      keywords.add(word);
    }

    return keywords.toList();
  }

  List<String> generateKeywords(String text) {
    List<String> keywords = [];

    List<String> words = text.toLowerCase().split(' ');

    for (var word in words) {
      String temp = '';

      for (int i = 0; i < word.length; i++) {
        temp += word[i];
        keywords.add(temp);
      }
    }

    return keywords.toSet().toList();
  }

  // ==================== CANCEL UPLOAD ====================

  Future<void> cancelUpload() async {
    if (isUploading.value) {
      final shouldCancel = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Upload'),
          content: const Text('Are you sure you want to cancel the upload?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Yes'),
            ),
          ],
        ),
      );

      if (shouldCancel == true) {
        // Cancel the upload task
        if (_currentUploadTask != null) {
          try {
            _currentUploadTask!.cancel();
            print('🛑 Upload task cancelled');
          } catch (e) {
            print('Error cancelling upload: $e');
          }
        }

        // Cancel subscription
        await _uploadSubscription?.cancel();
        _uploadSubscription = null;

        isUploading.value = false;
        isUploadMinimized.value = false;
        uploadProgress.value = 0.0;
        _currentUploadTask = null;

        // Clear cache
        await VideoCompress.deleteAllCache();

        Get.back(); // Close upload screen

        Get.snackbar(
          'Upload Cancelled',
          'Video upload has been cancelled',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } else {
      Get.back();
    }
  }

  // ==================== RESET FORM ====================

  void resetForm() {
    selectedVideoPath.value = '';
    selectedThumbnailUrl.value = '';
    videoTitle.value = '';
    videoDescription.value = '';
    selectedCategory.value = '';
    selectedCategoryName.value = '';
    selectedTags.clear();
    videoDuration.value = '';
    videoDurationInSeconds.value = 0;
    videoType.value = '';
    thumbnailFile.value = null;
    ingredients.clear();
    ingredientTextController.clear();
    ingredientQuantityController.clear();
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    isVideoPlaying.value = false;
    uploadProgress.value = 0.0;
    isUploadMinimized.value = false;
    _currentUploadTask = null;
    _uploadSubscription?.cancel();
    _uploadSubscription = null;
  }
}

class Ingredient {
  String name;
  String quantity;

  Ingredient({required this.name, required this.quantity});
}

class VideoCategory {
  final String id;
  final String name;
  final String icon;
  bool isSelected;

  VideoCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });
}

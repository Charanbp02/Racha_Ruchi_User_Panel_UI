// lib/App/Modules/Upload/upload_controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:racharuchi/App/Modules/Upload/config/upload_constants.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

// ==================== MODELS ====================
class Ingredient {
  String name;
  String quantity;

  Ingredient({required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  @override
  String toString() => '$name: $quantity';
}

// Main Category Model
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

// SubCategory Model
class VideoSubCategory {
  final String id;
  final String name;
  final bool isActive;

  VideoSubCategory({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'isActive': isActive};
  }

  factory VideoSubCategory.fromMap(Map<String, dynamic> map) {
    return VideoSubCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}

// ==================== CONTROLLER ====================
class UploadController extends GetxController {
  // ==================== OBSERVABLES ====================
  final selectedVideoPath = ''.obs;
  final selectedThumbnailUrl = ''.obs;
  final videoTitle = ''.obs;
  final videoDescription = ''.obs;
  final selectedCategory = ''.obs;
  final selectedCategoryName = ''.obs;
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;
  final videoPlayerController = Rx<VideoPlayerController?>(null);
  final isVideoPlaying = false.obs;
  final selectedTags = <String>[].obs;
  final videoDuration = ''.obs;
  final videoDurationInSeconds = 0.obs;
  final videoType = ''.obs;
  final thumbnailFile = Rx<File?>(null);
  final uploadType = ''.obs;
  final isUploadMinimized = false.obs;
  final uploadSpeed = ''.obs;
  final estimatedTimeRemaining = ''.obs;
  final isCompressing = false.obs;
  final compressionProgress = 0.0.obs;
  final retryCount = 0.obs;
  final isRetrying = false.obs;
  final uploadStatus = ''.obs;

  // ✅ Categories with real-time updates
  final categories = <VideoCategory>[].obs;
  var isLoading = false.obs;

  // ✅ Subcategories
  final subCategories = <VideoSubCategory>[].obs;
  final filteredCategories = <VideoCategory>[].obs;

  // ✅ Selected IDs and Names
  final selectedCategoryId = ''.obs;
  final selectedSubCategoryId = ''.obs;
  final selectedSubCategoryName = ''.obs;

  final categorySearchController = TextEditingController();
  final categorySearchQuery = ''.obs;

  // ✅ Upload button enabled state
  final isUploadEnabled = false.obs;

  // ✅ Real-time subscription
  StreamSubscription<QuerySnapshot>? _categorySubscription;
  StreamSubscription<DocumentSnapshot>? _subCategorySubscription;

  // ==================== CATEGORY METHODS ====================

  // ✅ Search categories
  void searchCategory(String query) {
    categorySearchQuery.value = query;
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value =
          categories.where((category) {
            return category.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
  }

  // ==================== INGREDIENTS ====================
  final ingredients = <Ingredient>[].obs;
  final ingredientTextController = TextEditingController();
  final ingredientQuantityController = TextEditingController();

  // ==================== SUGGESTED TAGS ====================
  final suggestedTags =
      <String>[
        'Easy Recipe',
        'Quick Cooking',
        'Indian Food',
        'Home Cooking',
        'Tasty Food',
        'Veg Recipe',
        'Non Veg Recipe',
      ].obs;

  // ==================== FIREBASE ====================
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== UPLOAD CONTROL ====================
  String? _currentBunnyVideoId;
  DateTime? _lastUploadTime;
  Timer? _progressTimer;
  int _lastBytesTransferred = 0;
  DateTime? _lastProgressUpdate;
  String? _bunnyVideoId;

  // ==================== CALLBACKS ====================
  Function? onUploadMinimized;
  Function? onUploadRestored;

  // ==================== LIFECYCLE ====================
  @override
  void onInit() {
    super.onInit();
    _initializeUploadType();
    _setupDebugLogging();
    _listenCategoriesRealtime();
  }

  @override
  void onClose() {
    _disposeResources();
    _categorySubscription?.cancel();
    _subCategorySubscription?.cancel();
    categorySearchController.dispose();
    super.onClose();
  }

  // ✅ Update video title listener to check upload enabled
  void updateVideoTitle(String value) {
    videoTitle.value = value;
    checkUploadEnabled();
  }

  void _initializeUploadType() {
    if (Get.arguments != null && Get.arguments['uploadType'] != null) {
      uploadType.value = Get.arguments['uploadType'];
      print('📹 Upload type selected: ${uploadType.value}');
    }
  }

  void _setupDebugLogging() {
    if (kDebugMode) {
      ever(selectedVideoPath, (path) => print('📹 Video path: $path'));
      ever(
        uploadProgress,
        (progress) =>
            print('📊 Progress: ${(progress * 100).toStringAsFixed(1)}%'),
      );
    }
  }

  void _disposeResources() {
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    ingredientTextController.dispose();
    ingredientQuantityController.dispose();
    VideoCompress.dispose();
    _progressTimer?.cancel();
    _progressTimer = null;
    _clearCache();
  }

  // ✅ Real-time listener for categories
  void _listenCategoriesRealtime() {
    isLoading.value = true;
    _categorySubscription?.cancel();

    _categorySubscription = _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            final List<VideoCategory> loadedCategories = [];

            for (var doc in snapshot.docs) {
              final data = doc.data();
              if (data['isActive'] == true) {
                loadedCategories.add(
                  VideoCategory(
                    id: doc.id,
                    name: data['name'] ?? '',
                    icon: data['icon'] ?? '🍽️',
                    isSelected: false,
                  ),
                );
              }
            }

            categories.value = loadedCategories;
            filteredCategories.value = loadedCategories;
            isLoading.value = false;
            print('🔄 Real-time updated: ${categories.length} categories');
          },
          onError: (error) {
            print('❌ Category stream error: $error');
            isLoading.value = false;
          },
        );
  }

  // ✅ Load subcategories for selected category - FIXED for camelCase field name
  Future<void> loadSubCategories(String categoryId) async {
    try {
      print('📂 Loading subcategories for category: $categoryId');

      // First clear existing subcategories
      subCategories.clear();
      selectedSubCategoryId.value = '';
      selectedSubCategoryName.value = '';

      // Get the category document
      final doc =
          await _firestore.collection('categories').doc(categoryId).get();

      if (!doc.exists) {
        print('❌ Category document does not exist');
        Get.snackbar(
          'Error',
          'Category not found',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final data = doc.data();
      if (data == null) {
        print('❌ Category data is null');
        return;
      }

      print('📄 Category data keys: ${data.keys.join(', ')}');

      // ✅ Check for 'subCategories' (camelCase - matches your Firestore structure)
      if (data['subCategories'] != null) {
        final subList = data['subCategories'];

        if (subList is List && subList.isNotEmpty) {
          print('📋 Found ${subList.length} subcategories in array');

          subCategories.value =
              subList.map((item) {
                if (item is Map) {
                  return VideoSubCategory(
                    id:
                        item['id'] ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    name: item['name'] ?? 'Unknown',
                    isActive: item['isActive'] ?? true,
                  );
                } else if (item is String) {
                  return VideoSubCategory(id: item, name: item);
                } else {
                  return VideoSubCategory(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: item.toString(),
                  );
                }
              }).toList();

          print('✅ Loaded ${subCategories.length} subcategories');
          print(
            '📋 Subcategory names: ${subCategories.map((s) => s.name).join(', ')}',
          );

          // Auto-select first subcategory if available
          if (subCategories.isNotEmpty) {
            selectSubCategory(subCategories.first.id);
            print('✅ Auto-selected: ${subCategories.first.name}');
          }

          checkUploadEnabled();
          return;
        } else {
          print('⚠️ subCategories field exists but is empty');
        }
      } else {
        // Fallback: Check for lowercase 'subcategories' (just in case)
        if (data['subcategories'] != null) {
          final subList = data['subcategories'];

          if (subList is List && subList.isNotEmpty) {
            print(
              '📋 Found ${subList.length} subcategories in array (lowercase)',
            );

            subCategories.value =
                subList.map((item) {
                  if (item is Map) {
                    return VideoSubCategory(
                      id:
                          item['id'] ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: item['name'] ?? 'Unknown',
                      isActive: item['isActive'] ?? true,
                    );
                  } else if (item is String) {
                    return VideoSubCategory(id: item, name: item);
                  } else {
                    return VideoSubCategory(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: item.toString(),
                    );
                  }
                }).toList();

            if (subCategories.isNotEmpty) {
              selectSubCategory(subCategories.first.id);
            }
            checkUploadEnabled();
            return;
          }
        }

        print('⚠️ No subcategories field found in document');
      }

      // No subcategories found - show message
      print(
        '⚠️ No subcategories found for category: ${data['name'] ?? 'Unknown'}',
      );
      Get.snackbar(
        'No Subcategories',
        'This category has no subcategories. Please contact admin.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      checkUploadEnabled();
    } catch (e) {
      print('❌ Error loading subcategories: $e');
      subCategories.clear();
      Get.snackbar(
        'Error',
        'Failed to load subcategories: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      checkUploadEnabled();
    }
  }

  // Add this method to UploadController
  void safeSelectCategory(String categoryId) {
    // Check if category exists
    final categoryExists = categories.any((cat) => cat.id == categoryId);

    if (!categoryExists) {
      print('⚠️ Category $categoryId not found, clearing selection');
      clearCategorySelection();
      return;
    }

    selectCategory(categoryId);
  }

  // ✅ Select category - automatically loads subcategories
  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;

    // Find and set category name
    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => VideoCategory(id: '', name: '', icon: ''),
    );
    selectedCategoryName.value = category.name;

    // ✅ Reset subcategory selection
    selectedSubCategoryId.value = '';
    selectedSubCategoryName.value = '';
    subCategories.clear();

    // ✅ Load subcategories
    loadSubCategories(categoryId);

    // ✅ Check if upload can be enabled
    checkUploadEnabled();
  }

  // ✅ Select subcategory
  void selectSubCategory(String subCategoryId) {
    selectedSubCategoryId.value = subCategoryId;

    final subCategory = subCategories.firstWhere(
      (sub) => sub.id == subCategoryId,
      orElse: () => VideoSubCategory(id: '', name: ''),
    );
    selectedSubCategoryName.value = subCategory.name;

    print('✅ Subcategory selected: ${selectedSubCategoryName.value}');
    checkUploadEnabled();
  }

  // ✅ Clear category selection
  void clearCategorySelection() {
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    selectedSubCategoryId.value = '';
    selectedSubCategoryName.value = '';
    subCategories.clear();
    categorySearchQuery.value = '';
    categorySearchController.clear();
    filteredCategories.value = categories;
    checkUploadEnabled();
  }

  // ✅ Manual refresh
  Future<void> refreshCategories() async {
    _listenCategoriesRealtime();
  }

  // ✅ Check if upload button should be enabled - FIXED
  void checkUploadEnabled() {
    isUploadEnabled.value =
        selectedCategoryId.value.isNotEmpty &&
        selectedSubCategoryId.value.isNotEmpty &&
        videoTitle.value.isNotEmpty &&
        ingredients.isNotEmpty;

    print('🔍 Upload enabled: ${isUploadEnabled.value}');
    print('   Category: ${selectedCategoryId.value}');
    print('   SubCategory: ${selectedSubCategoryId.value}');
    print('   Title: ${videoTitle.value.isNotEmpty}');
    print('   Ingredients: ${ingredients.isNotEmpty}');
  }

  // ==================== CACHE MANAGEMENT ====================
  Future<void> _clearCache() async {
    try {
      await VideoCompress.deleteAllCache();
      print('🗑️ Video compress cache cleared');
    } catch (e) {
      print('⚠️ Error clearing cache: $e');
    }
  }

  // ==================== AUTHENTICATION ====================
  Future<bool> ensureAuthenticated() async {
    final user = _auth.currentUser;

    if (user == null) {
      await _showLoginDialog();
      return false;
    }

    try {
      await user.getIdToken(true);
      print('✅ User authenticated: ${user.email}');
      print('🆔 User UID: ${user.uid}');
      return true;
    } catch (e) {
      print('❌ Token refresh failed: $e');
      _showSessionExpiredDialog();
      return false;
    }
  }

  Future<void> _showLoginDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to upload videos'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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
  }

  void _showSessionExpiredDialog() {
    Get.snackbar(
      'Session Expired',
      'Please login again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // ==================== RATE LIMITING ====================
  Future<bool> canUpload() async {
    final now = DateTime.now();
    if (_lastUploadTime != null &&
        now.difference(_lastUploadTime!) < UploadConstants.minUploadInterval) {
      Get.snackbar(
        'Too Many Uploads',
        'Please wait before uploading again',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
    _lastUploadTime = now;
    return true;
  }

  // ==================== VALIDATION ====================
  bool isValidVideoType(String path) {
    final extensions = ['.mp4', '.mov', '.avi', '.mkv'];
    return extensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'[<>]'), '');
  }

  bool validateUpload() {
    if (selectedVideoPath.isEmpty) {
      _showError('Please select a video');
      return false;
    }

    if (!isValidVideoType(selectedVideoPath.value)) {
      _showError('Invalid video format. Please use MP4, MOV, AVI, or MKV');
      return false;
    }

    // ✅ Check file size before proceeding
    final file = File(selectedVideoPath.value);
    if (file.existsSync()) {
      final sizeInMB = file.lengthSync() / (1024 * 1024);
      if (sizeInMB > UploadConstants.maxVideoSizeMB) {
        _showError(
          'Video is too large (${sizeInMB.toStringAsFixed(1)} MB). Maximum allowed: ${UploadConstants.maxVideoSizeMB} MB',
        );
        return false;
      }
      print("📊 Selected file size: ${sizeInMB.toStringAsFixed(2)} MB");
    }

    if (videoTitle.value.isEmpty) {
      _showError('Please enter video title');
      return false;
    }

    if (videoTitle.value.length > UploadConstants.maxTitleLength) {
      _showError(
        'Title too long (max ${UploadConstants.maxTitleLength} characters)',
      );
      return false;
    }

    if (ingredients.isEmpty) {
      _showError('Please add at least one ingredient');
      return false;
    }

    if (selectedCategoryId.value.isEmpty) {
      _showError('Please select a category');
      return false;
    }

    if (selectedSubCategoryId.value.isEmpty) {
      _showError('Please select a subcategory');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
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
      checkUploadEnabled();
    } else {
      Get.snackbar(
        'Error',
        'Please enter ingredient name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
    checkUploadEnabled();
  }

  void updateIngredient(int index, String name, String quantity) {
    if (name.isNotEmpty) {
      ingredients[index] = Ingredient(name: name, quantity: quantity);
      ingredients.refresh();
    }
  }

  // ==================== VIDEO PICKING ====================
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
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 25),
      );

      if (video == null) {
        print('User cancelled video pick');
        return;
      }

      await _processSelectedVideo(video);
    } catch (e) {
      print('❌ Pick video error: $e');
      _showError('Failed to pick video: ${e.toString()}');
    }
  }

  Future<void> _processSelectedVideo(XFile video) async {
    videoPlayerController.value?.dispose();
    videoPlayerController.value = VideoPlayerController.file(File(video.path));

    await videoPlayerController.value!.initialize();

    final duration = videoPlayerController.value!.value.duration;
    final seconds = duration.inSeconds;

    if (seconds < UploadConstants.minVideoDuration) {
      _showError(
        'Video must be at least ${UploadConstants.minVideoDuration} seconds',
      );
      videoPlayerController.value?.dispose();
      videoPlayerController.value = null;
      return;
    }

    if (seconds > UploadConstants.maxVideoDuration) {
      _showError(
        'Maximum video length is ${UploadConstants.maxVideoDuration ~/ 60} minutes',
      );
      videoPlayerController.value?.dispose();
      videoPlayerController.value = null;
      return;
    }

    selectedVideoPath.value = video.path;
    videoDurationInSeconds.value = seconds;
    videoDuration.value = _formatDuration(duration);
    videoType.value = seconds < 60 ? 'shorts' : 'long';
    print('📹 Video type: ${videoType.value} (${seconds}s)');

    await _generateThumbnail(video.path);
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
        print('✅ Thumbnail generated');
      }
    } catch (e) {
      print('⚠️ Error generating thumbnail: $e');
      selectedThumbnailUrl.value = videoPath;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // ==================== VIDEO PLAYER CONTROLS ====================
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

  // ==================== TAG AND CATEGORY METHODS ====================
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // ==================== MINIMIZE / RESTORE ====================
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

  /// ==================== VIDEO COMPRESSION ====================
  /// ==================== VIDEO COMPRESSION ====================
  Future<File?> compressVideo(String videoPath) async {
    try {
      isCompressing.value = true;
      compressionProgress.value = 0.0;
      uploadStatus.value = 'Compressing video...';

      print("🎬 Starting video compression...");
      print("📹 Video path: $videoPath");

      final originalFile = File(videoPath);

      // Check if file exists
      if (!await originalFile.exists()) {
        print("❌ Video file does not exist at path: $videoPath");
        isCompressing.value = false;
        uploadStatus.value = 'Video file not found';
        return null;
      }

      final originalSize = await originalFile.length();
      final sizeInMB = originalSize / (1024 * 1024);
      print("📊 Original size: ${sizeInMB.toStringAsFixed(2)} MB");

      // ✅ If video is under 80 MB, skip compression (good quality)
      if (sizeInMB <= UploadConstants.compressionThresholdMB) {
        print("✅ Video size is acceptable, skipping compression");
        isCompressing.value = false;
        uploadStatus.value = 'Video ready for upload';
        return originalFile;
      }

      // ✅ For videos between 80-300 MB, compress with adaptive quality
      print("🎬 Compressing video (${sizeInMB.toStringAsFixed(2)} MB)...");

      // Determine compression quality based on file size
      VideoQuality quality;
      if (sizeInMB > 200) {
        quality = VideoQuality.LowQuality; // Very large files
        print("📊 Using Low Quality compression for large file");
      } else if (sizeInMB > 120) {
        quality = VideoQuality.MediumQuality; // Large files
        print("📊 Using Medium Quality compression");
      } else {
        quality = VideoQuality.HighestQuality; // Moderate large files
        print("📊 Using High Quality compression");
      }

      // Compress with timeout
      final result = await VideoCompress.compressVideo(
        videoPath,
        quality: quality,
        deleteOrigin: false,
        includeAudio: true,
      ).timeout(
        UploadConstants.compressionTimeout,
        onTimeout: () {
          print("⚠️ Compression timed out, using original file");
          return null;
        },
      );

      if (result != null && result.file != null) {
        final compressedSize = await result.file!.length();
        final compressedSizeInMB = compressedSize / (1024 * 1024);
        print("✅ Compression successful");
        print(
          "📊 Compressed size: ${compressedSizeInMB.toStringAsFixed(2)} MB",
        );
        print(
          "📊 Compression ratio: ${((compressedSize / originalSize) * 100).toStringAsFixed(1)}%",
        );

        // ✅ If compressed file is still over 300 MB, use original
        if (compressedSizeInMB > UploadConstants.maxVideoSizeMB) {
          print(
            "⚠️ Compressed file still too large (${compressedSizeInMB.toStringAsFixed(2)} MB), using original",
          );
          compressionProgress.value = 1.0;
          isCompressing.value = false;
          uploadStatus.value = 'Using original (compression limited)';
          return originalFile;
        }

        compressionProgress.value = 1.0;
        isCompressing.value = false;
        uploadStatus.value = 'Compression complete';
        return result.file;
      }

      print("⚠️ Compression failed, using original file");
      isCompressing.value = false;
      uploadStatus.value = 'Using original video';
      return originalFile;
    } catch (e) {
      print("❌ Compression Error: $e");
      print("📊 Stack trace: ${StackTrace.current}");
      isCompressing.value = false;
      uploadStatus.value = 'Using original video (compression failed)';
      return File(videoPath);
    }
  }

  // Create video entry in Bunny Stream - MAKE IT PUBLIC
  Future<String> _createBunnyVideoEntry() async {
    uploadStatus.value = 'Creating video entry...';
    print('🎬 Creating video entry in Bunny Stream...');

    final url = Uri.parse(UploadConstants.bunnyApiBase);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'AccessKey': UploadConstants.bunnyApiKey,
      },
      body: jsonEncode({
        'title':
            videoTitle.value.isNotEmpty ? videoTitle.value : 'Recipe Video',
        'collectionId': UploadConstants.bunnyCollectionId,
        'isPublic': true, // ✅ IMPORTANT: Make video public
      }),
    );

    print('📤 Response status: ${response.statusCode}');
    print('📤 Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to create video entry: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final videoId = data['guid'].toString();
    _bunnyVideoId = videoId;
    print('✅ Bunny Stream video entry created: $videoId');
    print('✅ Video is set to PUBLIC');
    uploadStatus.value = 'Video entry created';
    return videoId;
  }

  // Get upload URL for Bunny Stream
  Future<String> _getBunnyUploadUrl(String videoId) async {
    uploadStatus.value = 'Getting upload URL...';
    final url = Uri.parse('${UploadConstants.bunnyApiBase}/$videoId');

    final response = await http.get(
      url,
      headers: {'AccessKey': UploadConstants.bunnyApiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get upload URL: ${response.body}');
    }

    final data = jsonDecode(response.body);
    // The upload URL is simply the video endpoint with the video ID
    final uploadUrl = '${UploadConstants.bunnyApiBase}/$videoId';
    print('📤 Upload URL: $uploadUrl');
    uploadStatus.value = 'Upload URL ready';
    return uploadUrl;
  }

  // Upload video to Bunny Stream - SIMPLE VERSION
  Future<void> _uploadVideoToBunny(File videoFile, String videoId) async {
    uploadStatus.value = 'Uploading video to Bunny Stream...';

    // Read video bytes
    final videoBytes = await videoFile.readAsBytes();
    final contentLength = videoBytes.length;

    // The URL for upload
    final url = Uri.parse('${UploadConstants.bunnyApiBase}/$videoId');

    print('📤 Uploading to: $url');
    print(
      '📤 File size: ${(contentLength / 1024 / 1024).toStringAsFixed(2)} MB',
    );

    // Create request with PUT method
    final request =
        http.Request('PUT', url)
          ..headers.addAll({
            'Content-Type': 'video/mp4',
            'AccessKey': UploadConstants.bunnyApiKey,
          })
          ..bodyBytes = videoBytes;

    // Send request
    final streamedResponse = await request.send();

    // Get the response without trying to listen to the stream separately
    final response = await http.Response.fromStream(streamedResponse);

    print('📤 Upload response status: ${response.statusCode}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('📤 Upload response body: ${response.body}');
      throw Exception('Failed to upload video: ${response.body}');
    }

    // Update progress to 60% after successful upload
    uploadProgress.value = 0.60;
    print('✅ Video uploaded to Bunny Stream successfully');
    uploadStatus.value = 'Video uploaded successfully';
  }

  // Update upload speed tracking
  void _updateUploadSpeed(int bytesSent, int totalBytes) {
    final now = DateTime.now();
    if (_lastProgressUpdate == null) {
      _lastProgressUpdate = now;
      _lastBytesTransferred = bytesSent;
      return;
    }

    final timeDiff = now.difference(_lastProgressUpdate!).inSeconds;
    final bytesDiff = bytesSent - _lastBytesTransferred;

    if (timeDiff > 0 && bytesDiff > 0) {
      final speedMBps = (bytesDiff / (1024 * 1024)) / timeDiff;
      uploadSpeed.value = '${speedMBps.toStringAsFixed(1)} MB/s';

      final remainingBytes = totalBytes - bytesSent;
      final estimatedSeconds = remainingBytes / (speedMBps * 1024 * 1024);
      if (estimatedSeconds > 0) {
        estimatedTimeRemaining.value = _formatEstimatedTime(estimatedSeconds);
      }
    }

    _lastBytesTransferred = bytesSent;
    _lastProgressUpdate = now;
  }

  // Get video URL from Bunny Stream
  // Replace the _getBunnyVideoUrl method in upload_controller.dart
  // Get video URL from Bunny Stream - Returns HLS playlist
  Future<String> _getBunnyVideoUrl(String videoId) async {
    uploadStatus.value = 'Getting video URL...';

    final url = Uri.parse('${UploadConstants.bunnyApiBase}/$videoId');

    final response = await http.get(
      url,
      headers: {'AccessKey': UploadConstants.bunnyApiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get video URL: ${response.body}');
    }

    final data = jsonDecode(response.body);

    // ✅ Use HLS playlist format for better streaming
    final videoUrl =
        'https://${UploadConstants.bunnyPullZone}/${data['guid']}/playlist.m3u8';
    print('🎥 Generated HLS Video URL: $videoUrl');

    uploadStatus.value = 'Video URL ready';

    return videoUrl;
  }

  Future<bool> waitForVideoProcessing(String videoId) async {
    uploadStatus.value = "Processing video...";

    for (int attempt = 1; attempt <= 30; attempt++) {
      try {
        final response = await http.get(
          Uri.parse("${UploadConstants.bunnyApiBase}/$videoId"),
          headers: {"AccessKey": UploadConstants.bunnyApiKey},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          final status = data["status"] ?? 0;

          print("🎬 Bunny Status: $status");

          // 4 = Finished
          if (status == 4) {
            print("✅ Video processing completed");
            return true;
          }
        }

        print("⏳ Waiting for processing... ($attempt/30)");
        await Future.delayed(const Duration(seconds: 10));
      } catch (e) {
        print("❌ Processing check error: $e");
      }
    }

    return false;
  }

  // Update video metadata in Bunny Stream - FIXED
  Future<void> _updateBunnyVideoMetadata(String videoId) async {
    try {
      uploadStatus.value = 'Updating metadata...';
      final url = Uri.parse('${UploadConstants.bunnyApiBase}/$videoId');

      final metadata = {
        'title':
            videoTitle.value.isNotEmpty ? videoTitle.value : 'Recipe Video',
        'description':
            videoDescription.value.isNotEmpty ? videoDescription.value : '',
        'tags': selectedTags.isNotEmpty ? selectedTags.join(',') : '',
        'category':
            selectedCategoryName.value.isNotEmpty
                ? selectedCategoryName.value
                : '',
        'collectionId':
            UploadConstants
                .bunnyCollectionId, // ✅ FIXED: Use Collection ID, not Library ID
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'AccessKey': UploadConstants.bunnyApiKey,
        },
        body: jsonEncode(metadata),
      );

      if (response.statusCode == 200) {
        print('✅ Bunny Stream metadata updated successfully');
        uploadStatus.value = 'Metadata updated';
      } else {
        print('⚠️ Failed to update metadata: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Metadata update error: $e');
    }
  }

  Future<void> uploadVideo() async {
    if (!await ensureAuthenticated()) return;
    if (!validateUpload()) return;
    if (!await canUpload()) return;

    isUploading.value = true;
    isUploadMinimized.value = false;
    uploadProgress.value = 0.0;
    retryCount.value = 0;
    _lastBytesTransferred = 0;
    _lastProgressUpdate = DateTime.now();

    try {
      await _performUploadWithRetry();
    } catch (e) {
      _handleUploadError(e);
    } finally {
      _cleanupUpload();
    }
  }

  // Perform upload with retry logic
  // Perform upload with retry logic
  Future<void> _performUploadWithRetry() async {
    int attempts = 0;
    while (attempts < UploadConstants.maxRetryAttempts) {
      try {
        attempts++;
        retryCount.value = attempts;

        if (attempts > 1) {
          isRetrying.value = true;
          uploadStatus.value =
              'Retrying upload (Attempt $attempts/${UploadConstants.maxRetryAttempts})...';
          print(
            '🔄 Retry attempt $attempts/${UploadConstants.maxRetryAttempts}',
          );

          // Exponential backoff
          final delay = Duration(
            seconds: min(
              UploadConstants.initialRetryDelay.inSeconds * (attempts - 1),
              UploadConstants.maxRetryDelay.inSeconds,
            ),
          );
          await Future.delayed(delay);
        }

        await _performUpload();
        isRetrying.value = false;
        return; // Success - exit retry loop
      } catch (e) {
        print('❌ Upload attempt $attempts failed: $e');
        if (attempts >= UploadConstants.maxRetryAttempts) {
          isRetrying.value = false;
          throw Exception(
            'Upload failed after ${UploadConstants.maxRetryAttempts} attempts: $e',
          );
        }
      }
    }
  }

  Future<void> _performUpload() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uid = _auth.currentUser!.uid;
    final originalVideoPath = selectedVideoPath.value;

    // Check if video exists
    final originalVideo = File(originalVideoPath);
    if (!await originalVideo.exists()) {
      throw Exception('Video file does not exist at path: $originalVideoPath');
    }

    uploadProgress.value = 0.02;
    uploadStatus.value = 'Starting upload...';

    // Step 1: Compress video
    final videoFile = await compressVideo(originalVideoPath);
    if (videoFile == null) {
      throw Exception('Failed to compress video');
    }
    uploadProgress.value = 0.10;

    // Step 2: Create Bunny Stream entry
    final videoId = await _createBunnyVideoEntry();
    uploadProgress.value = 0.15;

    // Step 3: Upload video to Bunny Stream (ONLY ONCE)
    await _uploadVideoToBunny(videoFile, videoId);
    uploadProgress.value = 0.60;

    // Step 4: Wait for Bunny encoding (status == 4)
    final ready = await waitForVideoProcessing(videoId);
    if (!ready) {
      throw Exception("Video processing timeout");
    }

    // Step 5: Get video URL (HLS playlist)
    final videoUrl = await _getBunnyVideoUrl(videoId);
    uploadProgress.value = 0.65;

    // Step 6: Update metadata in Bunny Stream
    await _updateBunnyVideoMetadata(videoId);
    uploadProgress.value = 0.70;

    // Step 7: Upload thumbnail
    final thumbnailUrl = await _uploadThumbnail(uid, timestamp);
    uploadProgress.value = 0.80;

    // Step 8: Save to Firestore
    await _saveToFirestore(videoUrl, thumbnailUrl, uid, timestamp);
    uploadProgress.value = 0.95;

    // Step 9: Finalize
    await Future.delayed(const Duration(milliseconds: 500));
    uploadProgress.value = 1.0;
    uploadStatus.value = 'Upload complete!';

    _showSuccessMessage();
    resetForm();
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
  }

  // ==================== THUMBNAIL UPLOAD ====================
  Future<String> _uploadThumbnail(String uid, int timestamp) async {
    uploadStatus.value = 'Uploading thumbnail...';

    if (thumbnailFile.value != null && await thumbnailFile.value!.exists()) {
      uploadProgress.value = 0.75;

      // Upload thumbnail to Firebase Storage (or you can use Bunny Stream thumbnail)
      final thumbnailRef = FirebaseStorage.instance.ref().child(
        '${UploadConstants.thumbnailPath}/$uid/$timestamp/thumbnail.jpg',
      );

      final thumbnailUpload = await thumbnailRef.putFile(
        thumbnailFile.value!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final thumbnailUrl = await thumbnailUpload.ref.getDownloadURL();
      uploadProgress.value = 0.80;
      print("✅ Thumbnail uploaded to Firebase Storage");
      uploadStatus.value = 'Thumbnail uploaded';
      return thumbnailUrl;
    }

    print("⚠️ No thumbnail found, using placeholder");
    uploadStatus.value = 'No thumbnail available';
    return 'https://via.placeholder.com/720x1280/FF6B6B/FFFFFF?text=Recipe+Video';
  }

  // ==================== FIRESTORE SAVE ====================
  Future<void> _saveToFirestore(
    String videoUrl,
    String thumbnailUrl,
    String uid,
    int timestamp,
  ) async {
    uploadStatus.value = 'Saving to database...';
    uploadProgress.value = 0.85;

    final videoDocId =
        _firestore.collection(UploadConstants.collectionName).doc().id;
    final ingredientsList = ingredients.map((ing) => ing.toJson()).toList();

    final title = sanitizeInput(videoTitle.value);
    final description = sanitizeInput(videoDescription.value);

    final keywords = generateSearchKeywords(
      '$title $description ${selectedTags.join(" ")} ${selectedCategoryName.value} ${selectedSubCategoryName.value}',
    );

    final videoData = {
      'id': videoDocId,
      'title': title,
      'description': description,
      'ingredients': ingredientsList,
      'videoUrl': videoUrl,
      'thumbnailUrl':
          thumbnailUrl.isNotEmpty
              ? thumbnailUrl
              : 'https://via.placeholder.com/720x1280/FF6B6B/FFFFFF?text=Recipe+Video',
      // ✅ Category fields
      'categoryId': selectedCategoryId.value,
      'categoryName': selectedCategoryName.value,
      // ✅ SubCategory fields
      'subCategoryId': selectedSubCategoryId.value,
      'subCategoryName': selectedSubCategoryName.value,
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
      // ✅ Bunny Stream specific fields
      'videoPlatform': 'bunny_stream',
      'bunnyVideoId': _bunnyVideoId,
      'bunnyLibraryId': UploadConstants.bunnyLibraryId,
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
        .collection(UploadConstants.collectionName)
        .doc(videoDocId)
        .set(videoData);
    uploadProgress.value = 0.95;
    uploadStatus.value = 'Database updated';
    print(
      "✅ Firestore saved with Category: ${selectedCategoryName.value}, SubCategory: ${selectedSubCategoryName.value}",
    );
    print("🎥 Bunny Stream Video ID: $_bunnyVideoId");
  }

  // ==================== KEYWORD GENERATION ====================
  List<String> generateSearchKeywords(String text) {
    if (text.isEmpty) return [];

    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final keywords = <String>{};

    for (String word in words) {
      if (word.isEmpty) continue;
      for (int i = 1; i <= word.length; i++) {
        keywords.add(word.substring(0, i));
      }
      keywords.add(word);
    }

    return keywords.toList();
  }

  // ==================== ERROR HANDLING ====================
  void _handleUploadError(dynamic error) {
    print('❌ Upload error: $error');

    String errorMsg = 'Upload failed: ';

    if (error is TimeoutException) {
      errorMsg = 'Upload timed out. Please try again.';
    } else if (error is SocketException) {
      errorMsg = 'Network error. Please check your internet connection.';
    } else if (error is http.ClientException) {
      errorMsg = 'Network error. Please check your internet connection.';
    } else {
      errorMsg += error.toString();
    }

    uploadStatus.value = 'Upload failed: $errorMsg';

    Get.snackbar(
      'Upload Failed',
      errorMsg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );

    uploadProgress.value = 0.0;
  }

  void _cleanupUpload() {
    isUploading.value = false;
    isUploadMinimized.value = false;
    isCompressing.value = false;
    isRetrying.value = false;
    _bunnyVideoId = null;
    _progressTimer?.cancel();
    _progressTimer = null;
    uploadSpeed.value = '';
    estimatedTimeRemaining.value = '';
    uploadStatus.value = '';
    _clearCache();
    print('🗑️ Upload complete - Cache cleared');
  }

  void _showSuccessMessage() {
    Get.snackbar(
      'Success! 🎉',
      'Video uploaded successfully to Bunny Stream!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

  // ==================== CANCEL UPLOAD ====================
  Future<void> cancelUpload() async {
    if (!isUploading.value) {
      Get.back();
      return;
    }

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
      _cancelCurrentUpload();
    }
  }

  void _cancelCurrentUpload() async {
    // Cancel Bunny Stream upload if possible
    if (_bunnyVideoId != null) {
      try {
        final url = Uri.parse('${UploadConstants.bunnyApiBase}/$_bunnyVideoId');
        final response = await http.delete(
          url,
          headers: {'AccessKey': UploadConstants.bunnyApiKey},
        );
        if (response.statusCode == 200) {
          print('🗑️ Bunny Stream video entry deleted');
        }
      } catch (e) {
        print('⚠️ Error deleting Bunny Stream video: $e');
      }
    }

    _progressTimer?.cancel();
    _progressTimer = null;

    isUploading.value = false;
    isUploadMinimized.value = false;
    uploadProgress.value = 0.0;
    uploadSpeed.value = '';
    estimatedTimeRemaining.value = '';
    uploadStatus.value = 'Cancelled';
    _bunnyVideoId = null;
    await _clearCache();
    Get.back();

    Get.snackbar(
      'Upload Cancelled',
      'Video upload has been cancelled',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  // ==================== HELPERS ====================
  String _formatEstimatedTime(double seconds) {
    if (seconds < 60) return '${seconds.toStringAsFixed(0)}s';
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).round();
    if (minutes < 60) {
      return '${minutes}m ${remainingSeconds}s';
    }
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  int min(int a, int b) => a < b ? a : b;

  // ==================== RESET FORM ====================
  void resetForm() {
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    selectedSubCategoryId.value = '';
    selectedSubCategoryName.value = '';
    subCategories.clear();
    categorySearchQuery.value = '';
    categorySearchController.clear();
    filteredCategories.value = categories;
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
    uploadSpeed.value = '';
    estimatedTimeRemaining.value = '';
    uploadStatus.value = '';
    isUploadEnabled.value = false;
    isCompressing.value = false;
    isRetrying.value = false;
    retryCount.value = 0;
    _bunnyVideoId = null;
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  // ==================== TEST STORAGE ACCESS ====================
  Future<void> testBunnyStreamConnection() async {
    try {
      print('🔧 Testing Bunny Stream connection...');

      final url = Uri.parse(UploadConstants.bunnyApiBase);
      final response = await http.get(
        url,
        headers: {'AccessKey': UploadConstants.bunnyApiKey},
      );

      if (response.statusCode == 200) {
        print('✅ Bunny Stream connection successful');
        Get.snackbar(
          'Success',
          'Bunny Stream is connected!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        print('❌ Bunny Stream connection failed: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Bunny Stream connection failed: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('❌ Bunny Stream test failed: $e');
      Get.snackbar(
        'Error',
        'Bunny Stream test failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:racharuchi/App/Models/Upload_Model/upload_model.dart';
import 'package:video_player/video_player.dart';

class UploadController extends GetxController {
  var selectedVideoPath = ''.obs;
  var selectedThumbnailPath = ''.obs;
  var videoTitle = ''.obs;
  var videoDescription = ''.obs;
  var selectedCategory = ''.obs;
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  var videoPlayerController = Rx<VideoPlayerController?>(null);
  var isVideoPlaying = false.obs;
  var selectedTags = <String>[].obs;

  // Categories list
  var categories =
      <VideoCategory>[
        VideoCategory(id: '1', name: 'Cooking', icon: '🍳'),
        VideoCategory(id: '2', name: 'Recipe', icon: '📝'),
        VideoCategory(id: '3', name: 'Biryani', icon: '🍚'),
        VideoCategory(id: '4', name: 'Dessert', icon: '🍰'),
        VideoCategory(id: '5', name: 'Street Food', icon: '🌮'),
        VideoCategory(id: '6', name: 'Healthy', icon: '🥗'),
      ].obs;

  // Suggested tags
  var suggestedTags =
      [
        'Easy Recipe',
        'Quick Cooking',
        'Indian Food',
        'Home Cooking',
        'Tasty Food',
        'Veg Recipe',
        'Non Veg Recipe',
        'Food Lover',
      ].obs;

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }

  // Pick video from gallery
  Future<void> pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        selectedVideoPath.value = video.path;

        // Initialize video player
        videoPlayerController.value?.dispose();
        videoPlayerController.value = VideoPlayerController.file(
          File(video.path),
        );
        await videoPlayerController.value!.initialize();
        videoPlayerController.value!.setLooping(true);

        // Auto-generate thumbnail from first frame
        await generateThumbnail(video.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video: $e');
    }
  }

  // Generate thumbnail from video
  Future<void> generateThumbnail(String videoPath) async {
    try {
      // You can use video_thumbnail package for better thumbnails
      // For now, we'll use a placeholder
      selectedThumbnailPath.value = videoPath;
    } catch (e) {
      print('Error generating thumbnail: $e');
    }
  }

  // Pick thumbnail from gallery
  Future<void> pickThumbnail() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedThumbnailPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick thumbnail: $e');
    }
  }

  // Toggle video play/pause
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

  // Add/remove tag
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // Select category
  void selectCategory(String categoryId) {
    selectedCategory.value = categoryId;
    for (var i = 0; i < categories.length; i++) {
      categories[i].isSelected = categories[i].id == categoryId;
    }
    categories.refresh();
  }

  // Upload video
  Future<void> uploadVideo() async {
    // Validate fields
    if (selectedVideoPath.isEmpty) {
      Get.snackbar('Error', 'Please select a video');
      return;
    }

    if (videoTitle.value.isEmpty) {
      Get.snackbar('Error', 'Please enter video title');
      return;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }

    isUploading.value = true;
    uploadProgress.value = 0.0;

    try {
      // Simulate upload progress
      for (var i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        uploadProgress.value = i / 100;
      }

      // Here you would upload to your server
      // await apiService.uploadVideo(
      //   videoPath: selectedVideoPath.value,
      //   title: videoTitle.value,
      //   description: videoDescription.value,
      //   category: selectedCategory.value,
      //   tags: selectedTags,
      // );

      // Success
      Get.snackbar(
        'Success!',
        'Video uploaded successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Reset form after successful upload
      resetForm();

      // Navigate back after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload video: $e');
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  // Reset form
  void resetForm() {
    selectedVideoPath.value = '';
    selectedThumbnailPath.value = '';
    videoTitle.value = '';
    videoDescription.value = '';
    selectedCategory.value = '';
    selectedTags.clear();
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    isVideoPlaying.value = false;
  }

  // Cancel upload
  void cancelUpload() {
    if (isUploading.value) {
      Get.defaultDialog(
        title: 'Cancel Upload',
        middleText: 'Are you sure you want to cancel?',
        textConfirm: 'Yes',
        textCancel: 'No',
        confirmTextColor: Colors.white,
        onConfirm: () {
          isUploading.value = false;
          uploadProgress.value = 0.0;
          Get.back();
          Get.back();
        },
      );
    } else {
      Get.back();
    }
  }
}

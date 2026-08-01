// lib/App/Modules/Upload/config/upload_constants.dart
import 'dart:core';

class UploadConstants {
  // ==================== VIDEO VALIDATION ====================
  static const int minVideoDuration = 25; // seconds
  static const int maxVideoDuration = 1500; // seconds (25 minutes)
  static const int maxVideoSizeMB = 300; // ✅ 300 MB limit
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  // ==================== TIMEOUTS ====================
  static const Duration uploadTimeout = Duration(
    minutes: 30,
  ); // ✅ 30 min for large files
  static const Duration compressionTimeout = Duration(seconds: 90);
  static const Duration minUploadInterval = Duration(minutes: 2);

  // ==================== RETRY CONFIGURATION ====================
  static const int maxRetryAttempts = 3;
  static const Duration initialRetryDelay = Duration(seconds: 2);
  static const Duration maxRetryDelay = Duration(seconds: 30);

  // ==================== FIRESTORE ====================
  static const String collectionName = 'recipe_videos';
  static const String thumbnailPath = 'thumbnails';

  // ==================== COMPRESSION SETTINGS ====================
  static const int compressionThresholdMB = 80; // Compress files over 80 MB
  static const int chunkSizeMB = 10; // 10 MB chunks for upload

  // Bunny Stream Configuration
  static const String bunnyApiKey =
      '3c903b4d-2df1-4b5f-84955961ecb3-0a05-4214'; // Replace with your API key
  static const String bunnyLibraryId = '707897'; // Replace with your library ID
  static const String bunnyPullZone =
      'vz-21bb3159-1fb.b-cdn.net'; // Replace with your pull zone

  // ✅ YOUR COLLECTION ID (for "Recipes Video" collection)
  static const String bunnyCollectionId =
      '4156a2c8-20fb-40b8-aa7b-0cbc2927702e';

  static const String bunnyApiBase =
      'https://video.bunnycdn.com/library/707897/videos';
}

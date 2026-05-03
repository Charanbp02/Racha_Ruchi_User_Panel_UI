class UploadModel {
  final String? videoPath;
  final String? thumbnailPath;
  final String title;
  final String description;
  final List<String> tags;
  final DateTime createdAt;
  bool isUploading;
  double uploadProgress;
  bool isUploaded;

  UploadModel({
    this.videoPath,
    this.thumbnailPath,
    required this.title,
    required this.description,
    required this.tags,
    required this.createdAt,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.isUploaded = false,
  });
}

class VideoCategory {
  final String id;
  final String name;
  final String icon;
  bool isSelected; // Only declare once

  VideoCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false, // Default value
  });
}

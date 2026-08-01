// lib/App/Models/Upload/upload_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientModel {
  String name;
  String quantity;

  IngredientModel({required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {'name': name, 'quantity': quantity};

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  @override
  String toString() => '$name: $quantity';

  bool get isValid => name.isNotEmpty;
}

// ✅ Video Category Model
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

// ✅ Video SubCategory Model
class VideoSubCategory {
  final String id;
  final String name;
  final bool isActive;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  VideoSubCategory({
    required this.id,
    required this.name,
    this.isActive = true,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  factory VideoSubCategory.fromMap(Map<String, dynamic> map) {
    return VideoSubCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown',
      isActive: map['isActive'] ?? true,
      description: map['description'],
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt']?.toDate(),
    );
  }
}

class UploadModel {
  String? videoPath;
  String? thumbnailPath;
  String title;
  String description;
  List<IngredientModel> ingredients;
  List<String> tags;
  DateTime createdAt;
  bool isUploading;
  double uploadProgress;
  bool isUploaded;
  String? categoryId;
  String? categoryName;
  String? subCategoryId;
  String? subCategoryName;
  String? videoUrl;
  String? thumbnailUrl;
  String? duration;
  int? durationInSeconds;
  String? videoType;
  String? userId;
  String? userName;
  String? userEmail;
  String? userImage;
  int? likes;
  int? views;
  int? comments;
  int? shares;
  double? rating;
  bool? isActive;
  bool? isPopular;

  // Bunny Stream specific fields
  String? videoPlatform;
  String? bunnyVideoId;
  String? bunnyLibraryId;

  UploadModel({
    this.videoPath,
    this.thumbnailPath,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.tags,
    required this.createdAt,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.isUploaded = false,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.videoUrl,
    this.thumbnailUrl,
    this.duration,
    this.durationInSeconds,
    this.videoType,
    this.userId,
    this.userName,
    this.userEmail,
    this.userImage,
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.shares = 0,
    this.rating = 0.0,
    this.isActive = true,
    this.isPopular = false,
    this.videoPlatform,
    this.bunnyVideoId,
    this.bunnyLibraryId,
  });

  bool get isValid {
    if (title.isEmpty) return false;
    if (description.isEmpty) return false;
    if (ingredients.isEmpty) return false;
    if (tags.isEmpty) return false;
    if (videoUrl?.isEmpty ?? true) return false;
    return true;
  }

  bool get isComplete {
    return title.isNotEmpty &&
        description.isNotEmpty &&
        ingredients.isNotEmpty &&
        tags.isNotEmpty &&
        (videoUrl?.isNotEmpty ?? false) &&
        (thumbnailUrl?.isNotEmpty ?? false);
  }

  UploadModel copyWith({
    String? videoPath,
    String? thumbnailPath,
    String? title,
    String? description,
    List<IngredientModel>? ingredients,
    List<String>? tags,
    DateTime? createdAt,
    bool? isUploading,
    double? uploadProgress,
    bool? isUploaded,
    String? categoryId,
    String? categoryName,
    String? subCategoryId,
    String? subCategoryName,
    String? videoUrl,
    String? thumbnailUrl,
    String? duration,
    int? durationInSeconds,
    String? videoType,
    String? userId,
    String? userName,
    String? userEmail,
    String? userImage,
    int? likes,
    int? views,
    int? comments,
    int? shares,
    double? rating,
    bool? isActive,
    bool? isPopular,
    String? videoPlatform,
    String? bunnyVideoId,
    String? bunnyLibraryId,
  }) {
    return UploadModel(
      videoPath: videoPath ?? this.videoPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploaded: isUploaded ?? this.isUploaded,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      videoType: videoType ?? this.videoType,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      isPopular: isPopular ?? this.isPopular,
      videoPlatform: videoPlatform ?? this.videoPlatform,
      bunnyVideoId: bunnyVideoId ?? this.bunnyVideoId,
      bunnyLibraryId: bunnyLibraryId ?? this.bunnyLibraryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'tags': tags,
      'createdAt': createdAt,
      'videoPath': videoPath,
      'thumbnailPath': thumbnailPath,
      'isUploading': isUploading,
      'uploadProgress': uploadProgress,
      'isUploaded': isUploaded,
      if (categoryId != null) 'categoryId': categoryId,
      if (categoryName != null) 'categoryName': categoryName,
      if (subCategoryId != null) 'subCategoryId': subCategoryId,
      if (subCategoryName != null) 'subCategoryName': subCategoryName,
      if (videoUrl != null) 'videoUrl': videoUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (duration != null) 'duration': duration,
      if (durationInSeconds != null) 'durationInSeconds': durationInSeconds,
      if (videoType != null) 'videoType': videoType,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (userEmail != null) 'userEmail': userEmail,
      if (userImage != null) 'userImage': userImage,
      'likes': likes ?? 0,
      'views': views ?? 0,
      'comments': comments ?? 0,
      'shares': shares ?? 0,
      'rating': rating ?? 0.0,
      'isActive': isActive ?? true,
      'isPopular': isPopular ?? false,
      'videoPlatform': videoPlatform,
      'bunnyVideoId': bunnyVideoId,
      'bunnyLibraryId': bunnyLibraryId,
    };
  }

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    return UploadModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ingredients:
          (json['ingredients'] as List?)
              ?.map((e) => IngredientModel.fromJson(e))
              .toList() ??
          [],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      videoPath: json['videoPath'],
      thumbnailPath: json['thumbnailPath'],
      isUploading: json['isUploading'] ?? false,
      uploadProgress: (json['uploadProgress'] ?? 0.0).toDouble(),
      isUploaded: json['isUploaded'] ?? false,
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      subCategoryId: json['subCategoryId'],
      subCategoryName: json['subCategoryName'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'],
      durationInSeconds: json['durationInSeconds'],
      videoType: json['videoType'],
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      userImage: json['userImage'],
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? true,
      isPopular: json['isPopular'] ?? false,
      videoPlatform: json['videoPlatform'],
      bunnyVideoId: json['bunnyVideoId'],
      bunnyLibraryId: json['bunnyLibraryId'],
    );
  }

  String getIngredientsAsString() {
    return ingredients.map((e) => '• ${e.name}: ${e.quantity}').join('\n');
  }

  String getTagsAsString() {
    return tags.map((t) => '#$t').join(' ');
  }

  int getTotalInteractions() {
    return (likes ?? 0) + (views ?? 0) + (comments ?? 0) + (shares ?? 0);
  }

  bool isShorts() {
    return videoType == 'shorts' || (durationInSeconds ?? 0) < 60;
  }

  factory UploadModel.createEmpty() {
    return UploadModel(
      title: '',
      description: '',
      ingredients: [],
      tags: [],
      createdAt: DateTime.now(),
    );
  }

  factory UploadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UploadModel.fromJson(data);
  }
}

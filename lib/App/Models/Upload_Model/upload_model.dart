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
  String? category;
  String? categoryId;
  String? videoUrl;
  String? thumbnailUrl;
  String? duration;
  int? durationInSeconds;
  String? videoType; // 'shorts' or 'long'
  String? userId;
  String? userName;
  String? userEmail;
  String? userImage;

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
    this.category,
    this.categoryId,
    this.videoUrl,
    this.thumbnailUrl,
    this.duration,
    this.durationInSeconds,
    this.videoType,
    this.userId,
    this.userName,
    this.userEmail,
    this.userImage,
  });

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
    String? category,
    String? categoryId,
    String? videoUrl,
    String? thumbnailUrl,
    String? duration,
    int? durationInSeconds,
    String? videoType,
    String? userId,
    String? userName,
    String? userEmail,
    String? userImage,
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
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      videoType: videoType ?? this.videoType,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
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
      if (category != null) 'category': category,
      if (categoryId != null) 'categoryId': categoryId,
      if (videoUrl != null) 'videoUrl': videoUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (duration != null) 'duration': duration,
      if (durationInSeconds != null) 'durationInSeconds': durationInSeconds,
      if (videoType != null) 'videoType': videoType,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (userEmail != null) 'userEmail': userEmail,
      if (userImage != null) 'userImage': userImage,
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
      category: json['category'],
      categoryId: json['categoryId'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'],
      durationInSeconds: json['durationInSeconds'],
      videoType: json['videoType'],
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      userImage: json['userImage'],
    );
  }

  String getIngredientsAsString() {
    return ingredients.map((e) => '• ${e.name}: ${e.quantity}').join('\n');
  }

  bool get isComplete {
    return title.isNotEmpty &&
        description.isNotEmpty &&
        ingredients.isNotEmpty &&
        tags.isNotEmpty &&
        (videoUrl?.isNotEmpty ?? false);
  }
}

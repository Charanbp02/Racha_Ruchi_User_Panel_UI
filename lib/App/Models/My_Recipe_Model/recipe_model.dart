// lib/App/Models/My_Recipe_Model/recipe_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String cookingTime;
  final String servings;
  final String difficulty;
  final String likes;
  final String comments;
  final String status;
  final String createdAt;
  final String cuisine;
  final String category;
  bool isFavorite;

  // Additional fields for backend
  final String userId;
  final String videoUrl;
  final List<String> tags;
  final List<Map<String, String>> ingredients;
  int likesCount;
  int commentsCount;
  int viewsCount;
  DateTime updatedAt;
  bool isActive;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTime,
    required this.servings,
    required this.difficulty,
    required this.likes,
    required this.comments,
    required this.status,
    required this.createdAt,
    required this.cuisine,
    required this.category,
    this.isFavorite = false,
    this.userId = '',
    this.videoUrl = '',
    this.tags = const [],
    this.ingredients = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    required this.updatedAt,
    this.isActive = true,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map, String docId) {
    return RecipeModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['thumbnailUrl'] ?? map['imageUrl'] ?? '',
      cookingTime: map['duration'] ?? '30 min',
      servings: '4-6',
      difficulty: 'Medium',
      likes: (map['likes'] ?? 0).toString(),
      comments: (map['comments'] ?? 0).toString(),
      status:
          map['status'] ?? (map['isActive'] == true ? 'Published' : 'Draft'),
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as dynamic).toDate().toString().split(' ')[0]
              : DateTime.now().toString().split(' ')[0],
      cuisine: map['category'] ?? 'Indian',
      category: map['category'] ?? 'Veg',
      userId: map['userId'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      ingredients: List<Map<String, String>>.from(map['ingredients'] ?? []),
      likesCount: map['likes'] ?? 0,
      commentsCount: map['comments'] ?? 0,
      viewsCount: map['views'] ?? 0,
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] as dynamic).toDate()
              : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnailUrl': imageUrl,
      'duration': cookingTime,
      'status': status,
      'category': category,
      'tags': tags,
      'ingredients': ingredients,
      'videoUrl': videoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': isActive,
    };
  }

  // Helper method to copy with updated values
  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? cookingTime,
    String? servings,
    String? difficulty,
    String? likes,
    String? comments,
    String? status,
    String? createdAt,
    String? cuisine,
    String? category,
    bool? isFavorite,
    String? userId,
    String? videoUrl,
    List<String>? tags,
    List<Map<String, String>>? ingredients,
    int? likesCount,
    int? commentsCount,
    int? viewsCount,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      cuisine: cuisine ?? this.cuisine,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
      videoUrl: videoUrl ?? this.videoUrl,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

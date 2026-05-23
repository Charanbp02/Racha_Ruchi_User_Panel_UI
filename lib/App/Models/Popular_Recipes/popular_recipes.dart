import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeVideoModel {
  final String id;
  final String title;
  final String duration;
  final String rating;
  final String thumbnailUrl; // Changed from imageUrl to thumbnailUrl
  final String calories;
  final String category;
  final String? videoUrl; // Main video URL
  final String? userId;
  final String? userName;
  final String? userImage;
  int likes;
  final int views;
  final int comments; // Added comments count
  final List<String>? tags;
  final DateTime? createdAt;

  RecipeVideoModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.rating,
    required this.thumbnailUrl,
    required this.calories,
    required this.category,
    this.videoUrl,
    this.userId,
    this.userName,
    this.userImage,
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.tags,
    this.createdAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'rating': double.parse(rating),
      'thumbnailUrl': thumbnailUrl,
      'calories': int.parse(calories),
      'category': category,
      'videoUrl': videoUrl,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'likes': likes,
      'views': views,
      'comments': comments,
      'tags': tags,
      'isPopular': true,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory RecipeVideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeVideoModel(
      id: doc.id,
      title: data['title'] ?? '',
      duration: data['duration'] ?? '30 min',
      rating: (data['rating'] ?? 4.5).toString(),
      thumbnailUrl: data['thumbnailUrl'] ?? data['imageUrl'] ?? '',
      calories: (data['calories'] ?? 350).toString(),
      category: data['category'] ?? 'Veg',
      videoUrl: data['videoUrl'],
      userId: data['userId'],
      userName: data['userName'],
      userImage: data['userImage'],
      likes: data['likes'] ?? 0,
      views: data['views'] ?? 0,
      comments: data['comments'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

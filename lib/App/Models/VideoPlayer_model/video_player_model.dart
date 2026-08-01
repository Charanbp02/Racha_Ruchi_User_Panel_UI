// lib/App/Models/CommentModel/comment_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CommentModel {
  final String id;
  final String userName;
  final String userImage;
  final String comment;
  final String timeAgo;
  final String likes;
  final String replies;
  var isLiked = false.obs;
  final String? userId;
  final DateTime? createdAt;
  final List<CommentModel>? repliesList;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.timeAgo,
    required this.likes,
    required this.replies,
    this.userId,
    this.createdAt,
    this.repliesList,
  });

  // Factory method to create from Firestore
  factory CommentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return CommentModel(
      id: docId,
      userName: data['userName'] ?? 'User',
      userImage: data['userImage'] ?? '',
      comment: data['comment'] ?? '',
      timeAgo: _formatTimeAgo(data['createdAt'] as Timestamp?),
      likes: data['likes']?.toString() ?? '0',
      replies: data['replies']?.toString() ?? '0',
      userId: data['userId'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  static String _formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now';

    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()}y';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()}mo';
    if (difference.inDays > 7) return '${(difference.inDays / 7).floor()}w';
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Just now';
  }

  // To JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userImage': userImage,
      'comment': comment,
      'timeAgo': timeAgo,
      'likes': likes,
      'replies': replies,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'Comment: $userName - $comment';
}

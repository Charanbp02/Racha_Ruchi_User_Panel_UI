// lib/App/Models/Video_Model/video_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String channelId;
  final String channelName;
  final String channelAvatar;
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final int duration;
  final DateTime publishedAt;
  final bool isVerified;
  final bool isPopular;
  final List<String> tags;
  final List<Map<String, dynamic>> ingredients;
  final String category;
  final double rating;
  final VideoStatus status;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.channelId,
    required this.channelName,
    required this.channelAvatar,
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    required this.duration,
    required this.publishedAt,
    this.isVerified = false,
    this.isPopular = false,
    this.tags = const [],
    this.ingredients = const [],
    this.category = '',
    this.rating = 0.0,
    this.status = VideoStatus.published,
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    print('📄 Creating VideoModel from: ${doc.id}');
    print('   Fields: ${data.keys.join(', ')}');

    final String videoUrl = data['videoUrl'] as String? ?? '';
    print(
      '   videoUrl: ${videoUrl.isNotEmpty ? videoUrl.substring(0, videoUrl.length > 60 ? 60 : videoUrl.length) : 'EMPTY'}...',
    );

    return VideoModel(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Video',
      description: data['description'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      videoUrl: videoUrl,
      channelId: data['userId'] as String? ?? '',
      channelName: data['userName'] as String? ?? 'Anonymous Chef',
      channelAvatar: data['userImage'] as String? ?? '',
      views: data['views'] as int? ?? 0,
      likes: data['likes'] as int? ?? 0,
      comments: data['comments'] as int? ?? 0,
      shares: data['shares'] as int? ?? 0,
      duration: data['durationInSeconds'] as int? ?? 30,
      publishedAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: false,
      isPopular: data['isPopular'] as bool? ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      ingredients: List<Map<String, dynamic>>.from(data['ingredients'] ?? []),
      category: data['category'] as String? ?? 'Cooking',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      status: VideoStatus.published,
    );
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours:${remainingMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedViews {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return '$views';
  }

  String get formattedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }

  VideoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? videoUrl,
    String? channelId,
    String? channelName,
    String? channelAvatar,
    int? views,
    int? likes,
    int? comments,
    int? shares,
    int? duration,
    DateTime? publishedAt,
    bool? isVerified,
    bool? isPopular,
    List<String>? tags,
    List<Map<String, dynamic>>? ingredients,
    String? category,
    double? rating,
    VideoStatus? status,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      channelAvatar: channelAvatar ?? this.channelAvatar,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      duration: duration ?? this.duration,
      publishedAt: publishedAt ?? this.publishedAt,
      isVerified: isVerified ?? this.isVerified,
      isPopular: isPopular ?? this.isPopular,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      status: status ?? this.status,
    );
  }
}

enum VideoStatus {
  published,
  draft,
  private,
  unlisted;

  String get displayName {
    switch (this) {
      case VideoStatus.published:
        return 'Published';
      case VideoStatus.draft:
        return 'Draft';
      case VideoStatus.private:
        return 'Private';
      case VideoStatus.unlisted:
        return 'Unlisted';
    }
  }

  Color get color {
    switch (this) {
      case VideoStatus.published:
        return Colors.green;
      case VideoStatus.draft:
        return Colors.orange;
      case VideoStatus.private:
        return Colors.red;
      case VideoStatus.unlisted:
        return Colors.blue;
    }
  }
}

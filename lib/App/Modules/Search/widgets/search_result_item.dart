// App/Modules/Search/view/widgets/search_result_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/Search/widgets/video_options_bottom_sheet.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/video_player_view.dart';

class SearchResultItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const SearchResultItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final durationText = _formatDuration(item);
    final parsedIngredients = _parseIngredients(item);

    return InkWell(
      onTap: () => _navigateToVideoPlayer(context, parsedIngredients),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnailWithDuration(durationText),
            const SizedBox(height: 12),
            _buildVideoInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailWithDuration(String durationText) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildThumbnail(),
        ),
        if (durationText.isNotEmpty)
          Positioned(
            bottom: 8,
            right: 8,
            child: _buildDurationBadge(durationText),
          ),
      ],
    );
  }

  Widget _buildThumbnail() {
    final thumbnailUrl = item['thumbnailUrl']?.toString() ?? '';
    if (thumbnailUrl.isNotEmpty) {
      return Image.network(
        thumbnailUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFE53935)),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderThumbnail();
        },
      );
    }
    return _buildPlaceholderThumbnail();
  }

  Widget _buildPlaceholderThumbnail() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Iconsax.video, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildDurationBadge(String durationText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.timer, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            durationText,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChannelAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildVideoDetails()),
          _buildMoreButton(context),
        ],
      ),
    );
  }

  Widget _buildChannelAvatar() {
    final userImage = item['userImage']?.toString() ?? '';
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey[200],
      backgroundImage: userImage.isNotEmpty ? NetworkImage(userImage) : null,
      child:
          userImage.isEmpty
              ? Icon(Iconsax.user, size: 20, color: Colors.grey[600])
              : null,
    );
  }

  Widget _buildVideoDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['title']?.toString() ?? '',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          item['userName'] ?? 'Unknown Channel',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        _buildVideoMetadata(),
      ],
    );
  }

  Widget _buildVideoMetadata() {
    return Row(
      children: [
        _buildMetadataIcon(Iconsax.eye, _formatViews(item['views'] ?? 0)),
        const SizedBox(width: 8),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.grey[500],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        _buildMetadataIcon(Iconsax.tag, item['category'] ?? 'Cooking'),
      ],
    );
  }

  Widget _buildMetadataIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return IconButton(
      onPressed: () => _showVideoOptions(context),
      icon: const Icon(Iconsax.more, size: 20),
      color: Colors.grey[600],
    );
  }

  String _formatDuration(Map<String, dynamic> item) {
    int seconds = 0;
    if (item['durationInSeconds'] != null && item['durationInSeconds'] is int) {
      seconds = item['durationInSeconds'] as int;
    } else if (item['duration'] != null) {
      seconds = _parseDurationToSeconds(item['duration'].toString());
    } else if (item['durationInMinutes'] != null) {
      seconds = (item['durationInMinutes'] as int) * 60;
    }
    return _formatDurationForDisplay(seconds);
  }

  String _formatDurationForDisplay(int seconds) {
    if (seconds <= 0) return '';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  int _parseDurationToSeconds(String duration) {
    final parts = duration.split(':');
    if (parts.length == 2) {
      return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
    } else if (parts.length == 3) {
      return (int.parse(parts[0]) * 3600) +
          (int.parse(parts[1]) * 60) +
          int.parse(parts[2]);
    }
    return 0;
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    }
    return '$views views';
  }

  List<Map<String, dynamic>> _parseIngredients(Map<String, dynamic> item) {
    List<Map<String, dynamic>> parsed = [];
    if (item['ingredients'] != null && item['ingredients'] is List) {
      for (var ingredient in item['ingredients'] as List) {
        if (ingredient is Map) {
          parsed.add(Map<String, dynamic>.from(ingredient));
        } else if (ingredient is String) {
          parsed.add({'name': ingredient, 'quantity': ''});
        }
      }
    }
    return parsed;
  }

  void _navigateToVideoPlayer(
    BuildContext context,
    List<Map<String, dynamic>> ingredients,
  ) {
    final videoModel = VideoModel(
      id: item['id']?.toString() ?? '',
      title: item['title']?.toString() ?? '',
      description: item['description']?.toString() ?? '',
      thumbnailUrl: item['thumbnailUrl']?.toString() ?? '',
      videoUrl: item['videoUrl']?.toString() ?? '',
      channelId: item['userId']?.toString() ?? '',
      channelName: item['userName']?.toString() ?? 'Unknown Channel',
      channelAvatar: item['userImage']?.toString() ?? '',
      views: (item['views'] as int?) ?? 0,
      likes: (item['likes'] as int?) ?? 0,
      comments: (item['comments'] as int?) ?? 0,
      shares: (item['shares'] as int?) ?? 0,
      duration: _parseDurationValue(item),
      publishedAt:
          (item['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: false,
      isPopular: item['isPopular'] as bool? ?? false,
      tags: List<String>.from(item['tags'] ?? []),
      ingredients: ingredients,
      category: item['category']?.toString() ?? 'Cooking',
      rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
      status: VideoStatus.published,
    );

    Get.to(() => const VideoPlayerView(), arguments: videoModel);
  }

  int _parseDurationValue(Map<String, dynamic> item) {
    if (item['durationInSeconds'] != null && item['durationInSeconds'] is int) {
      return item['durationInSeconds'] as int;
    }
    if (item['duration'] != null) {
      return _parseDurationToSeconds(item['duration'].toString());
    }
    if (item['durationInMinutes'] != null) {
      return (item['durationInMinutes'] as int) * 60;
    }
    return 0;
  }

  void _showVideoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return VideoOptionsBottomSheet(item: item);
      },
    );
  }
}

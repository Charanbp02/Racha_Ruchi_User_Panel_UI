// search_results_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/view/video_player_view.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String query = arguments?['query'] ?? '';
    final List<Map<String, dynamic>> results =
        (arguments?['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search results',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              '${results.length} results for "$query"',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body:
          results.isEmpty
              ? _buildEmptyState(context, query)
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  print("🔥 Item Ingredients: ${item['ingredients']}");
                  print("🔥 Item Keys: ${item.keys}");
                  return _buildYouTubeStyleCard(context, item);
                },
              ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.search_normal, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No results found for "$query"',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or check your spelling',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try another search'),
          ),
        ],
      ),
    );
  }

  Widget _buildYouTubeStyleCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    // Calculate duration properly from multiple possible sources
    int durationInSeconds = 0;

    if (item['durationInSeconds'] != null && item['durationInSeconds'] is int) {
      durationInSeconds = item['durationInSeconds'] as int;
    } else if (item['duration'] != null) {
      durationInSeconds = _parseDurationToSeconds(item['duration'].toString());
    } else if (item['durationInMinutes'] != null) {
      durationInSeconds = (item['durationInMinutes'] as int) * 60;
    }

    // Format duration for display
    String durationText = _formatDurationForDisplay(durationInSeconds);

    // Parse ingredients properly
    List<Map<String, dynamic>> parsedIngredients = [];
    if (item['ingredients'] != null && item['ingredients'] is List) {
      for (var ingredient in item['ingredients'] as List) {
        if (ingredient is Map) {
          parsedIngredients.add(Map<String, dynamic>.from(ingredient));
        } else if (ingredient is String) {
          parsedIngredients.add({'name': ingredient, 'quantity': ''});
        }
      }
    }

    print('📊 Video Data:');
    print('   Duration seconds: $durationInSeconds');
    print('   Duration text: $durationText');
    print('   Ingredients count: ${parsedIngredients.length}');

    return InkWell(
      onTap: () {
        final videoId = item['id']?.toString() ?? '';
        final channelId =
            item['userId']?.toString() ??
            item['channelId']?.toString() ??
            item['userName']?.toString() ??
            '';

        print('🎬 Navigating to video: $videoId');
        print('📦 Ingredients being passed: ${parsedIngredients.length}');
        print('📦 Parsed Ingredients: $parsedIngredients');

        final videoModel = VideoModel(
          id: videoId,
          title: item['title']?.toString() ?? '',
          description: item['description']?.toString() ?? '',
          thumbnailUrl: item['thumbnailUrl']?.toString() ?? '',
          videoUrl: item['videoUrl']?.toString() ?? '',
          channelId: channelId,
          channelName: item['userName']?.toString() ?? 'Unknown Channel',
          channelAvatar: item['userImage']?.toString() ?? '',
          views: (item['views'] as int?) ?? 0,
          likes: (item['likes'] as int?) ?? 0,
          comments: (item['comments'] as int?) ?? 0,
          shares: (item['shares'] as int?) ?? 0,
          duration: durationInSeconds,
          publishedAt:
              (item['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          isVerified: false,
          isPopular: item['isPopular'] as bool? ?? false,
          tags: List<String>.from(item['tags'] ?? []),
          ingredients: parsedIngredients, // Use parsed ingredients
          category: item['category']?.toString() ?? 'Cooking',
          rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
          status: VideoStatus.published,
        );

        print("TYPE = ${videoModel.runtimeType}");
        print("DATA = $videoModel");

        Get.to(() => const VideoPlayerView(), arguments: videoModel);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with duration overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      item['thumbnailUrl'] != null &&
                              item['thumbnailUrl'].toString().isNotEmpty
                          ? Image.network(
                            item['thumbnailUrl'],
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
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE53935),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Iconsax.video,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          )
                          : Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Iconsax.video,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                ),
                // Duration badge - FIXED: Now shows properly
                if (durationInSeconds > 0)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.timer,
                            size: 12,
                            color: Colors.white,
                          ),
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
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Video info row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        item['userImage'] != null &&
                                item['userImage'].toString().isNotEmpty
                            ? NetworkImage(item['userImage'])
                            : null,
                    child:
                        item['userImage'] == null ||
                                item['userImage'].toString().isEmpty
                            ? Icon(
                              Iconsax.user,
                              size: 20,
                              color: Colors.grey[600],
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
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
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.eye,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatViews(item['views'] ?? 0),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
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
                            Icon(
                              Iconsax.tag,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['category'] ?? 'Cooking',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => _showVideoOptions(context, item),
                    icon: const Icon(Iconsax.more, size: 20),
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this helper method for better duration formatting
  String _formatDurationForDisplay(int seconds) {
    if (seconds <= 0) return '0:00';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingSeconds > 0) {
        return '$hours:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
      }
      return '$hours:${remainingMinutes.toString().padLeft(2, '0')}';
    }

    if (remainingSeconds > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${minutes}min';
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    }
    return '$views views';
  }

  String _formatDurationFromSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  int _parseDurationToSeconds(String? duration) {
    if (duration == null || duration.isEmpty) return 0;

    // Handle format like "5:30"
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

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption(context, Iconsax.clock, 'Latest', () {
                Navigator.pop(context);
                // Implement sorting
              }),
              _buildFilterOption(context, Iconsax.eye, 'Most viewed', () {
                Navigator.pop(context);
                // Implement sorting
              }),
              _buildFilterOption(context, Iconsax.like, 'Most liked', () {
                Navigator.pop(context);
                // Implement sorting
              }),
              _buildFilterOption(context, Iconsax.video_play, 'Shortest', () {
                Navigator.pop(context);
                // Implement sorting
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      onTap: onTap,
    );
  }

  void _showVideoOptions(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Iconsax.save_2, color: Colors.black87),
                  title: const Text('Save to playlist'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement save to playlist
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.share, color: Colors.black87),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement share
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.message, color: Colors.black87),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement report
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

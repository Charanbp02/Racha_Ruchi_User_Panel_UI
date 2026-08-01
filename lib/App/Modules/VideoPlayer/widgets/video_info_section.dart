import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/action_buttons_row.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/channel_info.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/description_section.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_ingredients_section.dart';

class VideoInfoSection extends StatelessWidget {
  final VideoModel video;
  final VideoPlayerControllerX controller;

  const VideoInfoSection({
    super.key,
    required this.video,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with improved styling
            _buildTitle(),
            const SizedBox(height: 8),

            // Meta info with better design
            _buildMetaInfo(),
            const SizedBox(height: 16),

            // Action buttons with improved UI
            ActionButtonsRow(controller: controller),
            const SizedBox(height: 16),

            // Channel info with card design
            ChannelInfo(video: video, controller: controller),
            const SizedBox(height: 16),

            // Description section
            if (video.description.isNotEmpty)
              DescriptionSection(description: video.description),

            // Ingredients with improved display
            if (video.ingredients.isNotEmpty)
              IngredientsSection(ingredients: video.ingredients),

            // Tags section
            _buildTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            video.title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
        // Save button
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.bookmark, size: 20, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMetaInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildMetaChip(Iconsax.eye, video.formattedViews),
          const SizedBox(width: 8),
          _buildMetaChip(Iconsax.calendar, video.formattedTimeAgo),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTags() {
    final tags = ['#Cooking', '#Recipe', '#Food', '#Tutorial'];
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

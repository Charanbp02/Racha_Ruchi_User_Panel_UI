// lib/App/Modules/VideoPlayer/widgets/action_buttons_row.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/action_button.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/like_button.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/extensions/number_formatting_extension.dart';

class ActionButtonsRow extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const ActionButtonsRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LikeButton(controller: controller),
          ActionButton(
            icon: Iconsax.message,
            label: controller.commentCount.value.formatNumber(),
            onTap: controller.openComments,
          ),
          ActionButton(
            icon: Iconsax.export_1,
            label: 'Share',
            onTap: controller.shareVideo,
          ),
          ActionButton(
            icon: Iconsax.flag,
            label: 'Report',
            activeColor: Colors.red,
            onTap: controller.reportVideoBottomSheet,
          ),
        ],
      ),
    );
  }
}

// lib/App/Modules/VideoPlayer/widgets/video_status_indicator.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class VideoStatusIndicator extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const VideoStatusIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isBuffering.value) return const SizedBox.shrink();

      return Positioned(
        top: 12,
        left: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }
}

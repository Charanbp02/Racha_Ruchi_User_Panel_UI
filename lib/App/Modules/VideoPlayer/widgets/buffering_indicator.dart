// lib/App/Modules/VideoPlayer/widgets/buffering_indicator.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class BufferingIndicator extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const BufferingIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isBuffering.value) return const SizedBox.shrink();

      return Positioned(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}

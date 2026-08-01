import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class ProgressBars extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const ProgressBars({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Main progress bar with rounded corners
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey[800],
            ),
            child: Row(
              children: [
                // Buffered progress
                _buildBufferedProgress(),
                // Played progress
                _buildPlayedProgress(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBufferedProgress() {
    return Obx(() {
      if (controller.videoController == null ||
          !controller.videoController!.value.isInitialized) {
        return const SizedBox.shrink();
      }

      final bufferedValue =
          controller.duration.value.inSeconds > 0
              ? controller.bufferedPosition.value.inSeconds /
                  controller.duration.value.inSeconds
              : 0;

      return Expanded(
        flex: (bufferedValue * 100).toInt(),
        child: Container(color: Colors.grey[600]),
      );
    });
  }

  Widget _buildPlayedProgress() {
    return Obx(() {
      final playedValue =
          controller.duration.value.inSeconds > 0
              ? controller.position.value.inSeconds /
                  controller.duration.value.inSeconds
              : 0;

      return Expanded(
        flex: (playedValue * 100).toInt(),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    });
  }
}

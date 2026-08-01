// lib/App/Modules/VideoPlayer/widgets/video_player_section.dart

import 'package:flutter/material.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_player_widget.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/buffering_indicator.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/controls_overlay.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/progress_bars.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/time_display.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_status_indicator.dart';

class VideoPlayerSection extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const VideoPlayerSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: controller.toggleControls,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayerWidget(controller: controller),
            BufferingIndicator(controller: controller),
            ControlsOverlay(controller: controller),
            ProgressBars(controller: controller),
            TimeDisplay(controller: controller),
            VideoStatusIndicator(controller: controller),
          ],
        ),
      ),
    );
  }
}

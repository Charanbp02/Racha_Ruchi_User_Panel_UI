// lib/App/Modules/VideoPlayer/view/video_player_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Video_Model/video_model.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_player_app_bar.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_player_loading_view.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_player_error_view.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_player_not_found_view.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_player_section.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/widgets/video_info_section.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final video = Get.arguments as VideoModel?;

    if (video == null) {
      return const VideoPlayerNotFoundView();
    }

    print('🎬 VideoPlayerView - Title: ${video.title}');

    final controller =
        Get.isRegistered<VideoPlayerControllerX>(tag: video.id)
            ? Get.find<VideoPlayerControllerX>(tag: video.id)
            : Get.put(
              VideoPlayerControllerX(
                videoUrl: video.videoUrl,
                videoTitle: video.title,
                channelName: video.channelName,
                channelImage: video.channelAvatar,
                videoId: video.id,
                description: video.description,
                ingredients: video.ingredients,
                userId: video.channelId,
              ),
              tag: video.id,
            );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const VideoPlayerAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const VideoPlayerLoadingView();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return VideoPlayerErrorView(controller: controller);
        }

        if (controller.isInitialized.value &&
            controller.videoController != null) {
          return CustomScrollView(
            slivers: [
              VideoPlayerSection(controller: controller),
              VideoInfoSection(video: video, controller: controller),
            ],
          );
        }

        return const SizedBox();
      }),
    );
  }
}

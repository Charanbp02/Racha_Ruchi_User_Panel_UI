// lib/App/Modules/VideoPlayer/widgets/video_player_not_found_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VideoPlayerNotFoundView extends StatelessWidget {
  const VideoPlayerNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 60, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Video not found',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'The video you are looking for is not available',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Error', style: TextStyle(color: Colors.black87)),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left),
        onPressed: () => Get.back(),
      ),
    );
  }
}

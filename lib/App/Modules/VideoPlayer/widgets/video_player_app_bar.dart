// lib/App/Modules/VideoPlayer/widgets/video_player_app_bar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VideoPlayerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VideoPlayerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Video Player',
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left),
        onPressed: () => Get.back(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

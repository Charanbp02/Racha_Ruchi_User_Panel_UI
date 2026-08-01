import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class GestureControls extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const GestureControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showControls.value) return const SizedBox.shrink();

      return Positioned(
        left: 0,
        right: 0,
        top: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Volume control indicator
              _buildVolumeControl(),

              // Settings button
              _buildSettingsButton(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVolumeControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              controller.isMuted.value
                  ? Iconsax.volume_mute
                  : Iconsax.volume_high,
              color: Colors.white,
              size: 20,
            ),
            onPressed: controller.toggleMute,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Slider(
              value: controller.volume.value,
              onChanged: controller.setVolume,
              activeColor: Colors.white,
              inactiveColor: Colors.white30,
              min: 0,
              max: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Iconsax.setting_2, color: Colors.white),
        onPressed: () {
          // Show quality/settings options
        },
      ),
    );
  }
}

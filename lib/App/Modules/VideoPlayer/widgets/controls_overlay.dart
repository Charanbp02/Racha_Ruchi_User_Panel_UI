import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';

class ControlsOverlay extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const ControlsOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: !controller.showControls.value,
        child: AnimatedOpacity(
          opacity: controller.showControls.value ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSkipButton(
                    icon: Iconsax.backward_10_seconds,
                    onTap: controller.rewind10Seconds,
                  ),

                  const SizedBox(width: 32),

                  _buildPlayPauseButton(),

                  const SizedBox(width: 32),

                  _buildSkipButton(
                    icon: Iconsax.forward_10_seconds,
                    onTap: controller.forward10Seconds,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: controller.playPause,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: .45),
          border: Border.all(
            color: Colors.white.withValues(alpha: .18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .45),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder:
              (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
          child: Icon(
            controller.isPlaying.value ? Iconsax.pause5 : Iconsax.play5,
            key: ValueKey(controller.isPlaying.value),
            color: Colors.white,
            size: 42,
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: .32),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 18,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/controller/video_player_controller.dart';
import 'package:racharuchi/App/Modules/VideoPlayer/extensions/number_formatting_extension.dart';

class LikeButton extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const LikeButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          controller.animateLike.value = true;
          await controller.toggleLike();
          Future.delayed(const Duration(milliseconds: 300), () {
            controller.animateLike.value = false;
          });
        },
        child: AnimatedScale(
          scale: controller.animateLike.value ? 1.4 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.elasticOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          controller.isLiked.value
                              ? Colors.blue.withValues(alpha: 0.1)
                              : Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isLiked.value
                          ? Iconsax.like_15
                          : Iconsax.like_1,
                      color:
                          controller.isLiked.value
                              ? Colors.blue
                              : Colors.grey[600],
                      size: 28,
                    ),
                  ),
                  // Animation particles
                  if (controller.animateLike.value) _buildLikeParticles(),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                controller.likeCount.value.formatNumber(),
                style: TextStyle(
                  color:
                      controller.isLiked.value ? Colors.blue : Colors.grey[600],
                  fontSize: 12,
                  fontWeight:
                      controller.isLiked.value
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeParticles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: LikeParticlesPainter(),
        size: const Size(60, 60),
      ),
    );
  }
}

class LikeParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
    final paint =
        Paint()
          ..color = Colors.blue.withValues(alpha: 0.6)
          ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * 3.14159 + random;
      final distance = 20 + (i % 3) * 8;
      final x = size.width / 2 + distance * cos(angle);
      final y = size.height / 2 + distance * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        2 + (i % 3),
        paint..color = Colors.blue.withValues(alpha: 0.3 + (i % 4) * 0.1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

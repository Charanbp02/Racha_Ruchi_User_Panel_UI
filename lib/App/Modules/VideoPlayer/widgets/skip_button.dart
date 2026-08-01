// lib/App/Modules/VideoPlayer/widgets/skip_button.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SkipButton extends StatelessWidget {
  final bool isRewind;
  final VoidCallback onTap;

  const SkipButton({super.key, required this.isRewind, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Transform.scale(
              scaleX: isRewind ? -1 : 1,
              child: const Icon(Iconsax.repeat, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 4),
            const Text(
              '10',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

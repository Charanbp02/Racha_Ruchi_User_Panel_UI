import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AuthLink extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;
  final bool showArrow;

  const AuthLink({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.w700,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 4),
              const Icon(
                Iconsax.arrow_right_2,
                size: 16,
                color: Color(0xFFE53935),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

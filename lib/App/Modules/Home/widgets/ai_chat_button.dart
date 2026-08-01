// lib/App/Modules/Home/widgets/ai_chat_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/AIChat/view/ai_chat_view.dart';
import 'package:racharuchi/App/Modules/AIChat/binding/ai_chat_binding.dart';

class AIChatButton extends StatelessWidget {
  const AIChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToAIChat,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(0xFFE53935).withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Iconsax.magicpen, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAIChat() {
    HapticFeedback.mediumImpact();
    Get.to(
      () => const AIChatView(),
      binding: AIChatBinding(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 400),
    );
  }
}

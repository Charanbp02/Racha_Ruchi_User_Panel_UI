import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/AIFloatingButton/controller/ai_floating_controller.dart';

class AIFloatingView extends GetView<AIFloatingController> {
  const AIFloatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Main FAB Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(controller.buttonScale.value),
            child: FloatingActionButton(
              onPressed: controller.onPressed,
              backgroundColor:
                  controller.isExpanded.value
                      ? Colors.grey[800]
                      : const Color(0xFFE53935),
              elevation: controller.isExpanded.value ? 0 : 4,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    controller.isExpanded.value
                        ? const Icon(
                          Iconsax.close_circle,
                          key: ValueKey('close'),
                          color: Colors.white,
                          size: 28,
                        )
                        : controller.isProcessing.value
                        ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : controller.isListening.value
                        ? const Icon(
                          Iconsax.microphone,
                          key: ValueKey('mic'),
                          color: Colors.white,
                          size: 28,
                        )
                        : const Icon(
                          Iconsax.magicpen,
                          key: ValueKey('ai'),
                          color: Colors.white,
                          size: 28,
                        ),
              ),
            ),
          ),

          // Expanded Menu Items
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: controller.isExpanded.value ? 80 : 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: controller.isExpanded.value ? 1.0 : 0.0,
              child:
                  controller.isExpanded.value
                      ? _buildExpandedMenu()
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedMenu() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            controller.aiMenuItems.map((item) {
              return _buildMenuItem(item);
            }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(AIMenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => controller.onMenuItemTap(item),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(item.color),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(item.icon, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

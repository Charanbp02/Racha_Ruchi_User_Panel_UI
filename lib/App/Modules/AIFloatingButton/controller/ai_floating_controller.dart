import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AIFloatingController extends GetxController {
  // Animation states
  final isHovering = false.obs;
  final isExpanded = false.obs;
  final buttonScale = 1.0.obs;

  // AI Feature states
  final isProcessing = false.obs;
  final isListening = false.obs;
  final responseMessage = ''.obs;

  // Menu items
  final List<AIMenuItem> aiMenuItems = [
    AIMenuItem(
      icon: Iconsax.microphone,
      label: 'Voice Command',
      color: 0xFF4CAF50,
    ),
    AIMenuItem(
      icon: Iconsax.document_text,
      label: 'Recipe Suggestions',
      color: 0xFF2196F3,
    ),
    AIMenuItem(
      icon: Iconsax.camera,
      label: 'Scan Ingredients',
      color: 0xFFFF9800,
    ),
    AIMenuItem(icon: Iconsax.chart, label: 'Nutrition Info', color: 0xFF9C27B0),
  ];


  void onPressed() {
    if (isExpanded.value) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  void openMenu() {
    isExpanded.value = true;
    // Animate button scale
    buttonScale.value = 0.9;
    Future.delayed(const Duration(milliseconds: 150), () {
      buttonScale.value = 1.0;
    });
  }

  void closeMenu() {
    isExpanded.value = false;
  }

  void onMenuItemTap(AIMenuItem item) {
    closeMenu();

    switch (item.label) {
      case 'Voice Command':
        startVoiceCommand();
        break;
      case 'Recipe Suggestions':
        getRecipeSuggestions();
        break;
      case 'Scan Ingredients':
        scanIngredients();
        break;
      case 'Nutrition Info':
        getNutritionInfo();
        break;
      default:
        showAIFeatureComingSoon(item.label);
    }
  }

  void startVoiceCommand() {
    isListening.value = true;
    Get.snackbar(
      'AI Assistant',
      'Listening for voice commands...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(Iconsax.microphone, color: Colors.white),
      duration: const Duration(seconds: 2),
    );

    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 2), () {
      isListening.value = false;
      Get.snackbar(
        'AI Assistant',
        'Voice command received! Feature coming soon.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        icon: const Icon(Iconsax.cpu, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    });
  }

  void getRecipeSuggestions() {
    isProcessing.value = true;
    Get.snackbar(
      'AI Assistant',
      'Finding recipe suggestions...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(Iconsax.document_text, color: Colors.white),
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(seconds: 2), () {
      isProcessing.value = false;
      Get.defaultDialog(
        title: 'AI Recipe Suggestions',
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        middleText: 'Based on your preferences, here are some recipes:',
        content: Column(
          children: const [
            ListTile(
              leading: Icon(Iconsax.reserve, color: Color(0xFFE53935)),
              title: Text('Spicy Chicken Curry'),
              subtitle: Text('4.8 ★ | 30 min'),
            ),
            ListTile(
              leading: Icon(Iconsax.reserve, color: Color(0xFFE53935)),
              title: Text('Vegetable Biryani'),
              subtitle: Text('4.7 ★ | 45 min'),
            ),
            ListTile(
              leading: Icon(Iconsax.reserve, color: Color(0xFFE53935)),
              title: Text('Garlic Naan'),
              subtitle: Text('4.9 ★ | 15 min'),
            ),
          ],
        ),
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Close',
            style: TextStyle(color: Color(0xFFE53935)),
          ),
        ),
      );
    });
  }

  void scanIngredients() {
    Get.snackbar(
      'AI Assistant',
      'Camera feature coming soon! Scan ingredients to find recipes.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(Iconsax.camera, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void getNutritionInfo() {
    Get.snackbar(
      'AI Assistant',
      'Nutrition information feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(Iconsax.chart, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void showAIFeatureComingSoon(String feature) {
    Get.snackbar(
      'AI Assistant',
      '$feature feature is coming soon! 🚀',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(Iconsax.magicpen, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void onHover(bool hovering) {
    isHovering.value = hovering;
    buttonScale.value = hovering ? 1.1 : 1.0;
  }

}

class AIMenuItem {
  final IconData icon;
  final String label;
  final int color;

  AIMenuItem({required this.icon, required this.label, required this.color});
}

import 'dart:async';
import 'package:get/get.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController extends GetxController {
  /// Logo Animations
  var scale = 0.0.obs;
  var rotation = 0.0.obs;
  var logoColor = Colors.white.obs;
  var iconRotation = 0.0.obs;
  var shimmerOffset = 0.0.obs;

  /// Ripple effect
  var rippleOpacity = 0.0.obs;
  var rippleScale = 0.0.obs;

  /// Text Animations
  var textOpacity = 0.0.obs;
  var textOffset = 1.0.obs;
  var taglineOpacity = 0.0.obs;
  var glowOpacity = 0.0.obs;

  /// Background elements
  var floatingBubbles = <Bubble>[].obs;
  var bgColors = [const Color(0xFFE53935), const Color(0xFFD32F2F)].obs;
  var bgAngle = 0.0.obs;

  /// Loader
  var dotIndex = 0.obs;
  var dotProgress = 0.0.obs;

  /// Timers - Declare as nullable
  Timer? loaderTimer1;
  Timer? loaderTimer2;
  Timer? bubbleAnimationTimer;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isNavigationTriggered = false;

  @override
  void onInit() {
    super.onInit();
    initBubbles();
    startAnimation();
  }

  void initBubbles() {
    for (int i = 0; i < 8; i++) {
      floatingBubbles.add(
        Bubble(
          id: i,
          x: (i * 50) % Get.width,
          y: (i * 30) % Get.height,
          size: 20 + (i * 5),
          speed: 1 + (i * 0.5),
        ),
      );
    }
  }

  void startAnimation() async {
    /// Step 1: Ripple Effect
    await Future.delayed(const Duration(milliseconds: 100));
    rippleOpacity.value = 0.6;
    rippleScale.value = 1;

    await Future.delayed(const Duration(milliseconds: 600));
    rippleOpacity.value = 0;
    rippleScale.value = 0;

    /// Step 2: Logo Pop + Rotate + Shimmer
    await Future.delayed(const Duration(milliseconds: 200));
    scale.value = 1;
    rotation.value = 0.2;
    iconRotation.value = 0.3;

    await Future.delayed(const Duration(milliseconds: 400));
    rotation.value = -0.1;
    iconRotation.value = -0.1;

    await Future.delayed(const Duration(milliseconds: 300));
    rotation.value = 0;
    iconRotation.value = 0;

    /// Step 3: Shimmer effect
    shimmerOffset.value = 1;
    await Future.delayed(const Duration(milliseconds: 800));
    shimmerOffset.value = 0;

    /// Step 4: Text Slide Up with Glow
    textOpacity.value = 1;
    textOffset.value = 0;

    await Future.delayed(const Duration(milliseconds: 300));
    taglineOpacity.value = 1;
    glowOpacity.value = 0.8;

    /// Step 5: Animated Gradient
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      bgAngle.value = i * 0.1;
      bgColors.value = [
        Color.lerp(const Color(0xFFE53935), const Color(0xFF7B1FA2), i / 10)!,
        Color.lerp(const Color(0xFFD32F2F), const Color(0xFFE91E63), i / 10)!,
      ];
    }

    /// Step 6: Loader Animation Loop
    startLoaderAnimation();

    /// Step 7: Start Bubble Animation
    animateBubbles();

    /// Step 8: Check auth state and navigate after delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if navigation hasn't been triggered yet
    if (!_isNavigationTriggered && Get.context != null) {
      await checkAndNavigate();
    }
  }

  Future<void> checkAndNavigate() async {
    if (_isNavigationTriggered) return;
    _isNavigationTriggered = true;

    // Cancel all timers before navigation
    cancelAllTimers();

    if (Get.context != null) {
      // Check if user is already logged in
      User? user = _auth.currentUser;

      // Check if token is still valid (optional but recommended)
      if (user != null) {
        try {
          // Force refresh token to check if it's still valid
          await user.getIdToken(true);
          // User is logged in, go directly to home
          if (Get.context != null) {
            Get.offAllNamed(AppRoutes.BOTTOM_BAR);
          }
        } catch (e) {
          // Token expired or invalid, sign out and go to login
          await _auth.signOut();
          if (Get.context != null) {
            Get.offAllNamed(AppRoutes.LOGIN);
          }
        }
      } else {
        // User not logged in, go to login
        if (Get.context != null) {
          Get.offAllNamed(AppRoutes.LOGIN);
        }
      }
    }
  }

  void startLoaderAnimation() {
    // Timer for dot indicator animation
    loaderTimer1 = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (Get.context != null && !_isNavigationTriggered) {
        dotIndex.value = (dotIndex.value + 1) % 3;
      } else {
        timer.cancel();
      }
    });

    // Timer for progress indicator
    loaderTimer2 = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (Get.context != null && !_isNavigationTriggered) {
        if (dotProgress.value < 1) {
          dotProgress.value += 0.01;
        } else {
          dotProgress.value = 0;
        }
      } else {
        timer.cancel();
      }
    });
  }

  void cancelAllTimers() {
    loaderTimer1?.cancel();
    loaderTimer2?.cancel();
    bubbleAnimationTimer?.cancel();

    loaderTimer1 = null;
    loaderTimer2 = null;
    bubbleAnimationTimer = null;
  }

  @override
  void onClose() {
    cancelAllTimers();
    super.onClose();
  }

  void animateBubbles() {
    bubbleAnimationTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) {
      if (Get.context != null && !_isNavigationTriggered) {
        for (var bubble in floatingBubbles) {
          bubble.y -= bubble.speed;
          if (bubble.y < -bubble.size) {
            bubble.y = Get.height + bubble.size;
            bubble.x = (bubble.id * 50) % Get.width;
          }
        }
        floatingBubbles.refresh();
      } else {
        timer.cancel();
      }
    });
  }
}

class Bubble {
  final int id;
  double x;
  double y;
  final double size;
  final double speed;

  Bubble({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

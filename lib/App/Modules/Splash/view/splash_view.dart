import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Splash/controller/splash_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    controller.animateBubbles();

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            /// Animated Gradient Background
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: Alignment.center,
                  startAngle: controller.bgAngle.value,
                  endAngle: controller.bgAngle.value + 6.28319,
                  colors: controller.bgColors,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// Floating Bubbles
            ...controller.floatingBubbles.map((bubble) {
              return Positioned(
                left: bubble.x,
                top: bubble.y,
                child: AnimatedOpacity(
                  opacity: 0.3,
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    width: bubble.size,
                    height: bubble.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            /// Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Logo Container with Ripple Effect
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Ripple Animation
                      AnimatedOpacity(
                        opacity: controller.rippleOpacity.value,
                        duration: const Duration(milliseconds: 600),
                        child: AnimatedScale(
                          scale: controller.rippleScale.value,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                      ),

                      /// Glow Effect
                      AnimatedOpacity(
                        opacity: controller.glowOpacity.value,
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// RC Logo with Transformations
                      Transform.rotate(
                        angle: controller.rotation.value,
                        child: AnimatedScale(
                          scale: controller.scale.value,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xffa855f7), Color(0xffec4899)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 25,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                /// Shimmer Effect Layer
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Obx(
                                      () => Align(
                                        alignment: Alignment(
                                          controller.shimmerOffset.value,
                                          0,
                                        ),
                                        child: Container(
                                          width: 65,
                                          height: 130,
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// RC Logo Text
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "RC",
                                        style: GoogleFonts.poppins(
                                          fontSize: 52,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 4,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 2,
                                        margin: const EdgeInsets.only(top: 4),
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  /// Main Title with Staggered Animation
                  Column(
                    children: [
                      AnimatedSlide(
                        offset: Offset(0, controller.textOffset.value),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        child: AnimatedOpacity(
                          opacity: controller.textOpacity.value,
                          duration: const Duration(milliseconds: 800),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white70,
                                  Colors.white,
                                ],
                                stops: [0, 0.5, 1],
                              ).createShader(bounds);
                            },
                            child: Text(
                              "Racha Ruchi",
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Tagline with Delayed Animation
                      AnimatedOpacity(
                        opacity: controller.taglineOpacity.value,
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "Taste the Tradition",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  /// Modern Dot Loader with Progress
                  Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: Duration(
                                milliseconds: 300 + (index * 200),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width:
                                  controller.dotIndex.value == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withValues(alpha: 0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Circular Progress Indicator
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          value: controller.dotProgress.value,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.8),
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Decorative Top & Bottom Shapes
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/App/Modules/Profile/widgets/profile_loading.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileLoading extends StatelessWidget {
  const ProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading indicator
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: const Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 16),
          // Loading text
          Text(
            'Loading Profile...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'Please wait while we load your data',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Skeleton Loading Shimmer
class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar shimmer
            _buildShimmerItem(
              width: 100,
              height: 100,
              shape: BoxShape.circle,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
            // Name shimmer
            _buildShimmerItem(
              width: 150,
              height: 20,
              borderRadius: 8,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 8),
            // Email shimmer
            _buildShimmerItem(
              width: 180,
              height: 16,
              borderRadius: 8,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 8),
            // Phone shimmer
            _buildShimmerItem(
              width: 160,
              height: 16,
              borderRadius: 8,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 24),
            // Stats shimmer
            Row(
              children: [
                Expanded(
                  child: _buildShimmerItem(
                    width: double.infinity,
                    height: 60,
                    borderRadius: 12,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShimmerItem(
                    width: double.infinity,
                    height: 60,
                    borderRadius: 12,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Menu items shimmer
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildShimmerItem(
                  width: double.infinity,
                  height: 50,
                  borderRadius: 12,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerItem({
    required double width,
    required double height,
    BoxShape shape = BoxShape.rectangle,
    double borderRadius = 0,
    required bool isDarkMode,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle
                ? BorderRadius.circular(borderRadius)
                : null,
      ),
    );
  }
}

// Alternative: Animated Skeleton Loading
class AnimatedProfileLoadingShimmer extends StatefulWidget {
  const AnimatedProfileLoadingShimmer({super.key});

  @override
  State<AnimatedProfileLoadingShimmer> createState() =>
      _AnimatedProfileLoadingShimmerState();
}

class _AnimatedProfileLoadingShimmerState
    extends State<AnimatedProfileLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar shimmer with animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(opacity: _animation.value, child: child);
              },
              child: _buildShimmerItem(
                width: 100,
                height: 100,
                shape: BoxShape.circle,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 16),
            // Name shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(opacity: _animation.value, child: child);
              },
              child: _buildShimmerItem(
                width: 150,
                height: 20,
                borderRadius: 8,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 8),
            // Email shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(opacity: _animation.value, child: child);
              },
              child: _buildShimmerItem(
                width: 180,
                height: 16,
                borderRadius: 8,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 8),
            // Phone shimmer
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(opacity: _animation.value, child: child);
              },
              child: _buildShimmerItem(
                width: 160,
                height: 16,
                borderRadius: 8,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 24),
            // Stats shimmer
            Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(opacity: _animation.value, child: child);
                    },
                    child: _buildShimmerItem(
                      width: double.infinity,
                      height: 60,
                      borderRadius: 12,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(opacity: _animation.value, child: child);
                    },
                    child: _buildShimmerItem(
                      width: double.infinity,
                      height: 60,
                      borderRadius: 12,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Menu items shimmer
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(opacity: _animation.value, child: child);
                  },
                  child: _buildShimmerItem(
                    width: double.infinity,
                    height: 50,
                    borderRadius: 12,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerItem({
    required double width,
    required double height,
    BoxShape shape = BoxShape.rectangle,
    double borderRadius = 0,
    required bool isDarkMode,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle
                ? BorderRadius.circular(borderRadius)
                : null,
      ),
    );
  }
}

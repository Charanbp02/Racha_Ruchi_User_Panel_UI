// lib/App/Modules/Categories/widgets/category_loading_shimmer.dart
import 'package:flutter/material.dart';

class CategoryLoadingShimmer extends StatelessWidget {
  final int itemCount;
  final double height;
  final double width;

  const CategoryLoadingShimmer({
    super.key,
    this.itemCount = 6,
    this.height = 40,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildShimmerItem(),
          );
        },
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon placeholder
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          // Text placeholder
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

// Optional: Animated Shimmer Version
class AnimatedCategoryLoadingShimmer extends StatefulWidget {
  final int itemCount;
  final double height;
  final double width;

  const AnimatedCategoryLoadingShimmer({
    super.key,
    this.itemCount = 6,
    this.height = 40,
    this.width = 80,
  });

  @override
  State<AnimatedCategoryLoadingShimmer> createState() =>
      _AnimatedCategoryLoadingShimmerState();
}

class _AnimatedCategoryLoadingShimmerState
    extends State<AnimatedCategoryLoadingShimmer>
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
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(opacity: _animation.value, child: child);
              },
              child: _buildShimmerItem(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon placeholder
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          // Text placeholder
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

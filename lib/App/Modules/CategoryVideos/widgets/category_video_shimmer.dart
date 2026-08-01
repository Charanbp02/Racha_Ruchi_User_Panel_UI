// lib/App/Modules/CategoryVideos/widgets/category_video_shimmer.dart
import 'package:flutter/material.dart';

class CategoryVideoShimmer extends StatelessWidget {
  const CategoryVideoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 16,
      ), // YouTube-style padding
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail shimmer - full width, no rounded corners
              SizedBox(
                width: screenWidth,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE53935),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Info shimmer with horizontal padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar shimmer
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text shimmers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title shimmer (2 lines)
                          Container(
                            height: 14,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 14,
                            width: screenWidth * 0.7,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 8),
                          // Channel name shimmer
                          Container(
                            height: 12,
                            width: 120,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 6),
                          // Views and time shimmer
                          Container(
                            height: 10,
                            width: 100,
                            color: Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ),
                    // Menu button shimmer
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

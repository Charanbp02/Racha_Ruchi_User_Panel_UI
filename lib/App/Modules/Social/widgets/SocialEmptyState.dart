import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SocialEmptyState extends StatelessWidget {
  final bool isFollowersTab;
  final VoidCallback? onDiscoverPressed;

  const SocialEmptyState({
    super.key,
    required this.isFollowersTab,
    this.onDiscoverPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyIcon(),
          const SizedBox(height: 20),
          _buildEmptyTitle(),
          const SizedBox(height: 8),
          _buildEmptySubtitle(),
          const SizedBox(height: 20),
          if (!isFollowersTab) _buildDiscoverButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isFollowersTab ? Iconsax.profile_2user : Iconsax.user_add,
        size: 60,
        color: const Color(0xFFE53935),
      ),
    );
  }

  Widget _buildEmptyTitle() {
    return Text(
      isFollowersTab ? 'No Followers Yet' : 'No Following Yet',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D2D2D),
      ),
    );
  }

  Widget _buildEmptySubtitle() {
    return Text(
      isFollowersTab
          ? 'When someone follows you, they\'ll appear here'
          : 'When you follow someone, they\'ll appear here',
      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDiscoverButton() {
    return ElevatedButton(
      onPressed: onDiscoverPressed ?? () => Get.toNamed('/discover'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Discover People'),
    );
  }
}

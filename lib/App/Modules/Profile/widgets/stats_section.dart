// lib/App/Modules/Profile/widgets/stats_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/stat_item.dart';
import 'package:racharuchi/App/Modules/My_Recipes/view/my_recipes_view.dart';
import 'package:racharuchi/App/Modules/Social/view/social_view.dart';

class StatsSection extends StatelessWidget {
  final ProfileController controller;

  const StatsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            value: controller.recipes.value,
            label: 'Recipes',
            icon: Iconsax.document,
            onTap: () => Get.to(() => const MyRecipesView()),
          ),
          _buildDivider(isDarkMode),
          StatItem(
            value: controller.followers.value,
            label: 'Followers',
            icon: Iconsax.user,
            onTap: () => Get.to(() => const SocialView(showFollowers: true)),
          ),
          _buildDivider(isDarkMode),
          StatItem(
            value: controller.following.value,
            label: 'Following',
            icon: Iconsax.user_add,
            onTap: () => Get.to(() => const SocialView(showFollowers: false)),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      width: 1,
      height: 40,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
    );
  }
}

// Alternative: Stats Section with Title
class StatsSectionWithTitle extends StatelessWidget {
  final ProfileController controller;

  const StatsSectionWithTitle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Statistics',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(
                value: controller.recipes.value,
                label: 'Recipes',
                icon: Iconsax.document,
                onTap: () => Get.to(() => const MyRecipesView()),
              ),
              _buildDivider(isDarkMode),
              StatItem(
                value: controller.followers.value,
                label: 'Followers',
                icon: Iconsax.user,
                onTap:
                    () => Get.to(() => const SocialView(showFollowers: true)),
              ),
              _buildDivider(isDarkMode),
              StatItem(
                value: controller.following.value,
                label: 'Following',
                icon: Iconsax.user_add,
                onTap:
                    () => Get.to(() => const SocialView(showFollowers: false)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      width: 1,
      height: 40,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
    );
  }
}

// Alternative: Stats Section with Progress Bars (Fixed)
class StatsSectionWithProgress extends StatelessWidget {
  final ProfileController controller;

  const StatsSectionWithProgress({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Convert string values to integers
    final recipes = int.tryParse(controller.recipes.value) ?? 0;
    final followers = int.tryParse(controller.followers.value) ?? 0;
    final following = int.tryParse(controller.following.value) ?? 0;
    final total = recipes + followers + following;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(
                value: controller.recipes.value,
                label: 'Recipes',
                icon: Iconsax.document,
                onTap: () => Get.to(() => const MyRecipesView()),
              ),
              _buildDivider(isDarkMode),
              StatItem(
                value: controller.followers.value,
                label: 'Followers',
                icon: Iconsax.user,
                onTap:
                    () => Get.to(() => const SocialView(showFollowers: true)),
              ),
              _buildDivider(isDarkMode),
              StatItem(
                value: controller.following.value,
                label: 'Following',
                icon: Iconsax.user_add,
                onTap:
                    () => Get.to(() => const SocialView(showFollowers: false)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bars
          _buildProgressBar(
            label: 'Recipes',
            value: recipes,
            total: total,
            color: const Color(0xFFE53935),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 6),
          _buildProgressBar(
            label: 'Followers',
            value: followers,
            total: total,
            color: const Color(0xFF1DA1F2),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 6),
          _buildProgressBar(
            label: 'Following',
            value: following,
            total: total,
            color: const Color(0xFF4CAF50),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required int value,
    required int total,
    required Color color,
    required bool isDarkMode,
  }) {
    final percentage = total > 0 ? (value / total) : 0.0;

    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor:
                  isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              color: color,
              minHeight: 4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(percentage * 100).toInt()}%',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      width: 1,
      height: 40,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
    );
  }
}

// lib/App/Modules/Profile/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;

  const ProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? Colors.grey.shade900 : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ProfileAvatar(controller: controller),
          const SizedBox(height: 16),
          _buildUserName(isDarkMode),
          const SizedBox(height: 4),
          _buildUserEmail(isDarkMode),
          const SizedBox(height: 2),
          _buildUserPhone(isDarkMode),
          const SizedBox(height: 16),
          // Bio removed - not available in controller
          const SizedBox(height: 16),
          if (!controller.isEditing.value) _buildEditButton(isDarkMode),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUserName(bool isDarkMode) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              controller.userName.value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (controller.isEditing.value)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 14,
                  color: Color(0xFFE53935),
                ),
              ),
              onPressed:
                  () => controller.editField('Name', controller.userName.value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildUserEmail(bool isDarkMode) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.email_rounded,
            size: 14,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Text(
            controller.userEmail.value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          if (controller.isEditing.value)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 14,
                  color: Color(0xFFE53935),
                ),
              ),
              onPressed:
                  () =>
                      controller.editField('Email', controller.userEmail.value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildUserPhone(bool isDarkMode) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.phone_rounded,
            size: 14,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Text(
            controller.userPhone.value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          if (controller.isEditing.value)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 14,
                  color: Color(0xFFE53935),
                ),
              ),
              onPressed:
                  () =>
                      controller.editField('Phone', controller.userPhone.value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildEditButton(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => controller.toggleEditMode(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative: Profile Header with Cover Image (Fixed)
class ProfileHeaderWithCover extends StatelessWidget {
  final ProfileController controller;

  const ProfileHeaderWithCover({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? Colors.grey.shade900 : Colors.white,
      child: Column(
        children: [
          // Cover Image
          _buildCoverImage(isDarkMode),
          // Avatar (overlapping)
          Transform.translate(
            offset: const Offset(0, -40),
            child: ProfileAvatar(controller: controller),
          ),
          const SizedBox(height: 8),
          _buildUserName(isDarkMode),
          const SizedBox(height: 4),
          _buildUserEmail(isDarkMode),
          const SizedBox(height: 2),
          _buildUserPhone(isDarkMode),
          const SizedBox(height: 16),
          if (!controller.isEditing.value) _buildEditButton(isDarkMode),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCoverImage(bool isDarkMode) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFD32F2F), const Color(0xFFE53935)],
        ),
      ),
      child: Stack(
        children: [
          // Pattern overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const NetworkImage(
                      'https://images.unsplash.com/photo-1557683316-973673baf926?w=500',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Edit cover button
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Change Cover',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(bool isDarkMode) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              controller.userName.value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (controller.isEditing.value)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 14,
                  color: Color(0xFFE53935),
                ),
              ),
              onPressed:
                  () => controller.editField('Name', controller.userName.value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildUserEmail(bool isDarkMode) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.email_rounded,
            size: 14,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Text(
            controller.userEmail.value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          if (controller.isEditing.value)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 14,
                  color: Color(0xFFE53935),
                ),
              ),
              onPressed:
                  () =>
                      controller.editField('Email', controller.userEmail.value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildUserPhone(bool isDarkMode) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.phone_rounded,
            size: 14,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Text(
            controller.userPhone.value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          if (controller.isEditing.value)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 14,
                  color: Color(0xFFE53935),
                ),
              ),
              onPressed:
                  () =>
                      controller.editField('Phone', controller.userPhone.value),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildEditButton(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => controller.toggleEditMode(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

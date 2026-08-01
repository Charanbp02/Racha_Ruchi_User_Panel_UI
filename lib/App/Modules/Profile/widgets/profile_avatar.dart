// lib/App/Modules/Profile/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';

class ProfileAvatar extends StatelessWidget {
  final ProfileController controller;

  const ProfileAvatar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showImagePickerDialog(),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.grey.shade300,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CachedNetworkImage(
                imageUrl: controller.userImage.value,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      width: 100,
                      height: 100,
                      color:
                          isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: 100,
                      height: 100,
                      color:
                          isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: isDarkMode ? Colors.grey.shade600 : Colors.grey,
                      ),
                    ),
              ),
            ),
          ),
          // Edit badge
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53935).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Iconsax.camera, size: 16, color: Colors.white),
            ),
          ),
          // Online indicator
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog() {
    final isDarkMode =
        Get.context != null
            ? Theme.of(Get.context!).brightness == Brightness.dark
            : false;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'Change Profile Picture',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose a new photo for your profile',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPickerOption(
                  icon: Iconsax.gallery,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    controller.pickImageFromGallery();
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildPickerOption(
                  icon: Iconsax.camera,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    controller.pickImageFromCamera();
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildPickerOption(
                  icon: Iconsax.profile_2user,
                  label: 'Default',
                  onTap: () {
                    Get.back();
                    controller.updateProfileImage(
                      'https://randomuser.me/api/portraits/men/1.jpg',
                    );
                  },
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Cancel button
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor:
                    isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Profile Avatar with Edit Animation
class AnimatedProfileAvatar extends StatefulWidget {
  final ProfileController controller;

  const AnimatedProfileAvatar({super.key, required this.controller});

  @override
  State<AnimatedProfileAvatar> createState() => _AnimatedProfileAvatarState();
}

class _AnimatedProfileAvatarState extends State<AnimatedProfileAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
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

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: () => _showImagePickerDialog(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.grey.shade300,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: widget.controller.userImage.value,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 100,
                        height: 100,
                        color:
                            isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color:
                            isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color:
                              isDarkMode ? Colors.grey.shade600 : Colors.grey,
                        ),
                      ),
                ),
              ),
            ),
            // Edit badge
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerDialog() {
    final isDarkMode =
        Get.context != null
            ? Theme.of(Get.context!).brightness == Brightness.dark
            : false;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Change Profile Picture',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose a new photo for your profile',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPickerOption(
                  icon: Iconsax.gallery,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    widget.controller.pickImageFromGallery();
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildPickerOption(
                  icon: Iconsax.camera,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    widget.controller.pickImageFromCamera();
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildPickerOption(
                  icon: Iconsax.profile_2user,
                  label: 'Default',
                  onTap: () {
                    Get.back();
                    widget.controller.updateProfileImage(
                      'https://randomuser.me/api/portraits/men/1.jpg',
                    );
                  },
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor:
                    isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

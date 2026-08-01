// lib/App/Modules/Profile/widgets/profile_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'Profile',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: _buildBackButton(isDarkMode),
      actions: [
        _buildEditButton(controller, isDarkMode),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isDarkMode) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildEditButton(ProfileController controller, bool isDarkMode) {
    return Obx(
      () => IconButton(
        onPressed: () => controller.toggleEditMode(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                controller.isEditing.value
                    ? const Color(0xFFE53935).withValues(alpha: 0.1)
                    : (isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            controller.isEditing.value ? Iconsax.save_2 : Iconsax.edit_2,
            size: 20,
            color:
                controller.isEditing.value
                    ? const Color(0xFFE53935)
                    : (isDarkMode ? Colors.white : const Color(0xFF2D2D2D)),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Alternative: Profile App Bar with Settings Menu
class ProfileAppBarWithSettings extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileAppBarWithSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(
        'Profile',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: _buildBackButton(isDarkMode),
      actions: [
        _buildEditButton(controller, isDarkMode),
        const SizedBox(width: 4),
        _buildSettingsButton(isDarkMode),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isDarkMode) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildEditButton(ProfileController controller, bool isDarkMode) {
    return Obx(
      () => IconButton(
        onPressed: () => controller.toggleEditMode(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                controller.isEditing.value
                    ? const Color(0xFFE53935).withValues(alpha: 0.1)
                    : (isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            controller.isEditing.value ? Iconsax.save_2 : Iconsax.edit_2,
            size: 20,
            color:
                controller.isEditing.value
                    ? const Color(0xFFE53935)
                    : (isDarkMode ? Colors.white : const Color(0xFF2D2D2D)),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(bool isDarkMode) {
    return IconButton(
      onPressed: () {
        // Navigate to settings or show settings dialog
        _showSettingsDialog();
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.more_vert_rounded,
          size: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    final isDarkMode =
        Get.context != null
            ? Theme.of(Get.context!).brightness == Brightness.dark
            : false;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 20),
            // Settings options
            _buildSettingsOption(
              icon: Iconsax.user,
              title: 'Edit Profile',
              onTap: () {
                Get.back();
                // Navigate to edit profile
              },
              isDarkMode: isDarkMode,
            ),
            _buildSettingsOption(
              icon: Iconsax.password_check,
              title: 'Change Password',
              onTap: () {
                Get.back();
                // Navigate to change password
              },
              isDarkMode: isDarkMode,
            ),
            _buildSettingsOption(
              icon: Iconsax.moon,
              title: 'Dark Mode',
              onTap: () {
                Get.back();
                // Toggle dark mode
              },
              isDarkMode: isDarkMode,
            ),
            _buildSettingsOption(
              icon: Iconsax.language_circle,
              title: 'Language',
              onTap: () {
                Get.back();
                // Navigate to language settings
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

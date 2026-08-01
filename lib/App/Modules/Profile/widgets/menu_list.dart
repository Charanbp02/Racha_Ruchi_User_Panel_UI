// lib/App/Modules/Profile/widgets/menu_list.dart
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racharuchi/App/Modules/Profile/controller/profile_controller.dart';
import 'package:racharuchi/App/Modules/Profile/widgets/menu_item_tile.dart';
import 'package:racharuchi/App/Modules/About/view/about_view.dart';
import 'package:racharuchi/App/Modules/AddressBook/view/address_view.dart';
import 'package:racharuchi/App/Modules/Coupons/view/coupons_view.dart';
import 'package:racharuchi/App/Modules/HelpSupport/view/help_support_view.dart';
import 'package:racharuchi/App/Modules/MyOrders/view/order_view.dart';
import 'package:racharuchi/App/Modules/My_Recipes/view/my_recipes_view.dart';
import 'package:racharuchi/App/Modules/Notifications/view/notification_view.dart';
import 'package:racharuchi/App/Modules/PrivacyPolicy/view/privacy_policy_view.dart';

class MenuList extends StatelessWidget {
  final ProfileController controller;

  const MenuList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isDarkMode),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.menuItems.length,
            itemBuilder: (context, index) {
              final item = controller.menuItems[index];
              return MenuItemTile(
                item: item,
                onTap: () => _handleMenuItemTap(item, controller),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
              Icons.settings_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuItemTap(
    Map<String, dynamic> item,
    ProfileController controller,
  ) {
    final String title = item['title'];

    switch (title) {
      case 'My Orders':
        Get.to(() => const OrderView());
        break;
      case 'My Recipes':
        Get.to(() => const MyRecipesView());
        break;
      case 'Address Book':
        Get.to(() => const AddressBookView());
        break;
      case 'Notifications':
        Get.to(() => const NotificationView());
        break;
      case 'Help & Support':
        Get.to(() => const HelpSupportView());
        break;
      case 'Privacy Policy':
        Get.to(() => const PrivacyPolicyView());
        break;
      case 'About Us':
        Get.to(() => const AboutView());
        break;
      case 'Logout':
        _showLogoutDialog(controller);
        break;
      default:
        controller.onMenuItemTap(item);
        break;
    }
  }

  void _showLogoutDialog(ProfileController controller) {
    final isDarkMode =
        Get.context != null
            ? Theme.of(Get.context!).brightness == Brightness.dark
            : false;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor:
                  isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Menu List with Search
class MenuListWithSearch extends StatelessWidget {
  final ProfileController controller;

  const MenuListWithSearch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final searchController = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isDarkMode),
          const SizedBox(height: 8),
          _buildSearchBar(searchController, isDarkMode),
          const SizedBox(height: 12),
          Obx(() {
            final filteredItems =
                controller.menuItems.where((item) {
                  final title = item['title'].toString().toLowerCase();
                  final query = searchController.text.toLowerCase();
                  return title.contains(query);
                }).toList();

            if (filteredItems.isEmpty) {
              return _buildEmptyState(isDarkMode);
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return MenuItemTile(
                  item: item,
                  onTap: () => _handleMenuItemTap(item, controller),
                );
              },
            );
          }),
          _buildFooter(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
              Icons.settings_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    TextEditingController searchController,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Search menu...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
            size: 20,
          ),
          suffixIcon: Obx(() {
            if (searchController.text.isNotEmpty) {
              return IconButton(
                onPressed: () {
                  searchController.clear();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color:
                      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
                  size: 20,
                ),
                splashRadius: 20,
              );
            }
            return const SizedBox.shrink();
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          // Update filtered list
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No results found',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: Text(
          '© 2024 Recipe App',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  void _handleMenuItemTap(
    Map<String, dynamic> item,
    ProfileController controller,
  ) {
    final String title = item['title'];

    switch (title) {
      case 'My Orders':
        Get.to(() => const OrderView());
        break;
      case 'My Recipes':
        Get.to(() => const MyRecipesView());
        break;
      case 'Coupons':
        Get.to(() => const CouponsView());
        break;
      case 'Address Book':
        Get.to(() => const AddressBookView());
        break;
      case 'Notifications':
        Get.to(() => const NotificationView());
        break;
      case 'Help & Support':
        Get.to(() => const HelpSupportView());
        break;
      case 'Privacy Policy':
        Get.to(() => const PrivacyPolicyView());
        break;
      case 'About Us':
        Get.to(() => const AboutView());
        break;
      case 'Logout':
        _showLogoutDialog(controller);
        break;
      default:
        controller.onMenuItemTap(item);
        break;
    }
  }

  void _showLogoutDialog(ProfileController controller) {
    final isDarkMode =
        Get.context != null
            ? Theme.of(Get.context!).brightness == Brightness.dark
            : false;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor:
                  isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

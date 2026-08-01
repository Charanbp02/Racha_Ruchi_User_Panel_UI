// lib/App/Modules/Profile/widgets/menu_item_tile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class MenuItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const MenuItemTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLogout = item['title'] == 'Logout';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor:
              isLogout
                  ? Colors.red.withValues(alpha: 0.1)
                  : const Color(0xFFE53935).withValues(alpha: 0.1),
          highlightColor:
              isLogout
                  ? Colors.red.withValues(alpha: 0.05)
                  : const Color(0xFFE53935).withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                _buildIcon(isLogout, isDarkMode),
                const SizedBox(width: 12),
                Expanded(child: _buildTitle(isLogout, isDarkMode)),
                _buildTrailing(isLogout, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isLogout, bool isDarkMode) {
    final iconColor = isLogout ? Colors.red : const Color(0xFFE53935);

    final bgColor =
        isLogout
            ? Colors.red.withValues(alpha: 0.1)
            : const Color(0xFFE53935).withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        _getIconForMenuItem(item['title']),
        size: 20,
        color:
            isLogout
                ? (isDarkMode ? Colors.red.shade300 : Colors.red)
                : (isDarkMode
                    ? const Color(0xFFE53935)
                    : const Color(0xFFE53935)),
      ),
    );
  }

  Widget _buildTitle(bool isLogout, bool isDarkMode) {
    return Text(
      item['title'],
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color:
            isLogout
                ? (isDarkMode ? Colors.red.shade300 : Colors.red)
                : (isDarkMode ? Colors.white : const Color(0xFF2D2D2D)),
      ),
    );
  }

  Widget _buildTrailing(bool isLogout, bool isDarkMode) {
    if (item['title'] == 'Version') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          item['subtitle'] ?? '1.0.0',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      );
    }

    if (isLogout) {
      return const SizedBox.shrink();
    }

    return Icon(
      Iconsax.arrow_right_3,
      size: 18,
      color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
    );
  }

  IconData _getIconForMenuItem(String title) {
    switch (title) {
      case 'My Orders':
        return Iconsax.shopping_bag;
      case 'My Recipes':
        return Iconsax.document;
      case 'Coupons':
        return Iconsax.discount_circle;
      case 'Address Book':
        return Iconsax.location;
      case 'Notifications':
        return Iconsax.notification;
      case 'Help & Support':
        return Iconsax.headphone;
      case 'Privacy Policy':
        return Iconsax.shield_tick;
      case 'Settings':
        return Iconsax.setting;
      case 'Logout':
        return Iconsax.logout;
      case 'Version':
        return Iconsax.info_circle;
      default:
        return Iconsax.setting;
    }
  }
}

// Alternative: Menu Item Tile with Badge
class MenuItemTileWithBadge extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;
  final int? badgeCount;

  const MenuItemTileWithBadge({
    super.key,
    required this.item,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isLogout = item['title'] == 'Logout';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor:
              isLogout
                  ? Colors.red.withValues(alpha: 0.1)
                  : const Color(0xFFE53935).withValues(alpha: 0.1),
          highlightColor:
              isLogout
                  ? Colors.red.withValues(alpha: 0.05)
                  : const Color(0xFFE53935).withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                _buildIcon(isLogout, isDarkMode),
                const SizedBox(width: 12),
                Expanded(child: _buildTitle(isLogout, isDarkMode)),
                if (badgeCount != null && badgeCount! > 0) _buildBadge(),
                _buildTrailing(isLogout, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isLogout, bool isDarkMode) {
    final iconColor = isLogout ? Colors.red : const Color(0xFFE53935);

    final bgColor =
        isLogout
            ? Colors.red.withValues(alpha: 0.1)
            : const Color(0xFFE53935).withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        _getIconForMenuItem(item['title']),
        size: 20,
        color:
            isLogout
                ? (isDarkMode ? Colors.red.shade300 : Colors.red)
                : (isDarkMode
                    ? const Color(0xFFE53935)
                    : const Color(0xFFE53935)),
      ),
    );
  }

  Widget _buildTitle(bool isLogout, bool isDarkMode) {
    return Text(
      item['title'],
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color:
            isLogout
                ? (isDarkMode ? Colors.red.shade300 : Colors.red)
                : (isDarkMode ? Colors.white : const Color(0xFF2D2D2D)),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeCount! > 99 ? '99+' : badgeCount!.toString(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTrailing(bool isLogout, bool isDarkMode) {
    if (isLogout) {
      return const SizedBox.shrink();
    }

    return Icon(
      Iconsax.arrow_right_3,
      size: 18,
      color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
    );
  }

  IconData _getIconForMenuItem(String title) {
    switch (title) {
      case 'My Orders':
        return Iconsax.shopping_bag;
      case 'My Recipes':
        return Iconsax.document;
      case 'Coupons':
        return Iconsax.discount_circle;
      case 'Address Book':
        return Iconsax.location;
      case 'Notifications':
        return Iconsax.notification;
      case 'Help & Support':
        return Iconsax.headphone;
      case 'Privacy Policy':
        return Iconsax.shield_tick;
      case 'Settings':
        return Iconsax.setting;
      case 'Logout':
        return Iconsax.logout;
      case 'Version':
        return Iconsax.info_circle;
      default:
        return Iconsax.setting;
    }
  }
}

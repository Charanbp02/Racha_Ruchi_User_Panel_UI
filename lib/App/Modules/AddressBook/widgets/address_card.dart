// lib/App/Modules/AddressBook/widgets/address_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';
import 'package:racharuchi/App/Modules/AddressBook/controller/address_controller.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final AddressController controller;

  const AddressCard({
    super.key,
    required this.address,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            address.isDefault
                ? const Color(0xFFE53935).withValues(alpha: 0.05)
                : (isDarkMode ? Colors.grey.shade800 : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              address.isDefault
                  ? const Color(0xFFE53935)
                  : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [_buildContent(isDarkMode), _buildActions(isDarkMode)],
      ),
    );
  }

  Widget _buildContent(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDarkMode),
          const SizedBox(height: 12),
          _buildDetailRow(Iconsax.user, address.name, isDarkMode),
          const SizedBox(height: 8),
          _buildPhoneRow(isDarkMode),
          const SizedBox(height: 8),
          _buildAddressRow(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      children: [
        _buildTypeBadge(isDarkMode),
        const Spacer(),
        if (address.isDefault) _buildDefaultBadge(),
      ],
    );
  }

  Widget _buildTypeBadge(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(address.type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTypeIcon(address.type),
            size: 14,
            color: _getTypeColor(address.type),
          ),
          const SizedBox(width: 4),
          Text(
            address.type,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getTypeColor(address.type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'DEFAULT',
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.grey.shade500 : Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneRow(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          Iconsax.call,
          size: 16,
          color: isDarkMode ? Colors.grey.shade500 : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          address.phone,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        if (address.alternatePhone != null) ...[
          const SizedBox(width: 16),
          Text(
            'Alt: ${address.alternatePhone}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddressRow(bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Iconsax.location,
          size: 16,
          color: isDarkMode ? Colors.grey.shade500 : Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.addressLine1,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              if (address.addressLine2 != null)
                Text(
                  address.addressLine2!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              if (address.landmark != null)
                Text(
                  'Landmark: ${address.landmark}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color:
                        isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                  ),
                ),
              Text(
                '${address.city}, ${address.state} - ${address.pincode}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                address.country,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!address.isDefault)
            Obx(
              () => TextButton.icon(
                onPressed:
                    controller.isSyncing.value
                        ? null
                        : () => controller.setDefaultAddress(address.id),
                icon:
                    controller.isSyncing.value
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFE53935),
                          ),
                        )
                        : const Icon(Iconsax.tick_circle, size: 18),
                label: Text(
                  'Set as Default',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFE53935),
                ),
              ),
            ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: () => controller.showEditAddressForm(address),
            icon: const Icon(Iconsax.edit, size: 18),
            label: Text(
              'Edit',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor:
                  isDarkMode ? Colors.grey.shade300 : const Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: () => controller.deleteAddress(address.id),
            icon: const Icon(Iconsax.trash, size: 18),
            label: Text(
              'Delete',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Home':
        return Iconsax.home;
      case 'Work':
        return Iconsax.building;
      default:
        return Iconsax.location;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Home':
        return const Color(0xFF4CAF50);
      case 'Work':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFFF9800);
    }
  }
}

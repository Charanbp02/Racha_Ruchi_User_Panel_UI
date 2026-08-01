// lib/App/Modules/AddressBook/widgets/address_type_chip.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressTypeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFE53935)
                  : (isDarkMode ? Colors.grey.shade800 : Colors.white),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color:
                isSelected
                    ? Colors.transparent
                    : (isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300),
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  isSelected
                      ? Colors.white
                      : (isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                color:
                    isSelected
                        ? Colors.white
                        : (isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

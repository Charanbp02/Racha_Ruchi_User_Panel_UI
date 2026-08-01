import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;
  final bool isFree;
  final bool isTax;
  final bool isSubtotal;
  final IconData? leadingIcon;
  final Color? customColor;
  final String? subtitle;

  const BillRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
    this.isFree = false,
    this.isTax = false,
    this.isSubtotal = false,
    this.leadingIcon,
    this.customColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine text color based on flags
    Color getTextColor() {
      if (customColor != null) return customColor!;
      if (isTotal) return const Color(0xFFE53935);
      if (isDiscount) return Colors.green.shade700;
      if (isFree) return Colors.green.shade600;
      if (isTax) return Colors.orange.shade700;
      if (isSubtotal) return const Color(0xFF1A1A2E);
      return Colors.grey.shade700;
    }

    // Determine font size based on flags
    double getLabelSize() {
      if (isTotal) return 16;
      if (isSubtotal) return 15;
      return 14;
    }

    double getValueSize() {
      if (isTotal) return 20;
      if (isSubtotal) return 16;
      return 15;
    }

    // Determine font weight based on flags
    FontWeight getLabelWeight() {
      if (isTotal || isSubtotal) return FontWeight.w700;
      return FontWeight.w500;
    }

    FontWeight getValueWeight() {
      if (isTotal) return FontWeight.w800;
      if (isSubtotal) return FontWeight.w700;
      return FontWeight.w600;
    }

    // Build leading icon if provided
    Widget? getLeadingIcon() {
      if (leadingIcon != null) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Icon(
            leadingIcon,
            size: 16,
            color: getTextColor().withValues(alpha: 0.7),
          ),
        );
      }

      // Auto-assign icons based on type
      if (isTotal) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Icon(
            Iconsax.receipt_item,
            size: 16,
            color: const Color(0xFFE53935).withValues(alpha: 0.7),
          ),
        );
      }
      if (isDiscount) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Icon(
            Iconsax.discount_shape,
            size: 16,
            color: Colors.green.shade700.withValues(alpha: 0.7),
          ),
        );
      }
      if (isFree) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Icon(
            Iconsax.tick_circle,
            size: 16,
            color: Colors.green.shade600.withValues(alpha: 0.7),
          ),
        );
      }
      if (isTax) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Icon(
            Iconsax.document_text,
            size: 16,
            color: Colors.orange.shade700.withValues(alpha: 0.7),
          ),
        );
      }
      return null;
    }

    // Build decoration for total row
    BoxDecoration? getDecoration() {
      if (isTotal) {
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE53935).withValues(alpha: 0.05),
              const Color(0xFFE53935).withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE53935).withValues(alpha: 0.1),
            width: 1,
          ),
        );
      }
      if (isDiscount && !isTotal) {
        return BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        );
      }
      return null;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isTotal ? 12 : 8,
        horizontal: isTotal ? 12 : 0,
      ),
      decoration: getDecoration(),
      child: Row(
        children: [
          // Leading icon
          if (getLeadingIcon() != null) getLeadingIcon()!,

          // Label with optional subtitle
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: getLabelSize(),
                    fontWeight: getLabelWeight(),
                    color:
                        isTotal || isSubtotal
                            ? const Color(0xFF1A1A2E)
                            : Colors.grey.shade700,
                    letterSpacing: isTotal ? 0 : -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Value with enhanced styling
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tax indicator badge
                if (isTax) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Tax',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],

                // Discount badge
                if (isDiscount) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],

                // Free badge
                if (isFree) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FREE',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],

                // Value text
                Text(
                  value,
                  style: TextStyle(
                    fontSize: getValueSize(),
                    fontWeight: getValueWeight(),
                    color: getTextColor(),
                    letterSpacing: isTotal ? 0.3 : 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

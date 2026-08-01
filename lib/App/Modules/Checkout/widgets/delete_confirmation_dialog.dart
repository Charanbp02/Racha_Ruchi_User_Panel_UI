import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String? title;
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final Color? accentColor;

  const DeleteConfirmationDialog({
    super.key,
    required this.onConfirm,
    this.title,
    this.message,
    this.confirmText,
    this.cancelText,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? const Color(0xFFE53935);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon with gradient background
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.12),
                    color.withValues(alpha: 0.06),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.15),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Iconsax.warning_2, color: color, size: 44),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title ?? 'Delete Address?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Message
            Text(
              message ??
                  'Are you sure you want to delete this address? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: Get.back,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.grey.shade50,
                      foregroundColor: Colors.grey.shade700,
                    ),
                    child: Text(
                      cancelText ?? 'Cancel',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Delete/Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      shadowColor: color.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.trash, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          confirmText ?? 'Delete',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative version with more customization options
class DeleteConfirmationDialogCustom extends StatelessWidget {
  final VoidCallback onConfirm;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconColor;
  final Color confirmButtonColor;
  final bool showIcon;

  const DeleteConfirmationDialogCustom({
    super.key,
    required this.onConfirm,
    this.title = 'Delete Address?',
    this.message =
        'Are you sure you want to delete this address? This action cannot be undone.',
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.icon = Iconsax.warning_2,
    this.iconColor = const Color(0xFFE53935),
    this.confirmButtonColor = const Color(0xFFE53935),
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              // Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withValues(alpha: 0.12),
                      iconColor.withValues(alpha: 0.06),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.15),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 44),
              ),
              const SizedBox(height: 20),
            ],

            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: Get.back,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.grey.shade50,
                      foregroundColor: Colors.grey.shade700,
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmButtonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      shadowColor: confirmButtonColor.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.trash, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          confirmText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example with different types
class DeleteConfirmationDialogExample extends StatelessWidget {
  const DeleteConfirmationDialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Default dialog
        ElevatedButton(
          onPressed: () {
            Get.dialog(
              DeleteConfirmationDialog(
                onConfirm: () {
                  // Handle delete
                },
              ),
              barrierDismissible: false,
            );
          },
          child: const Text('Show Default Dialog'),
        ),

        // Custom dialog
        ElevatedButton(
          onPressed: () {
            Get.dialog(
              DeleteConfirmationDialog(
                title: 'Remove Item?',
                message:
                    'Are you sure you want to remove this item from your cart?',
                confirmText: 'Remove',
                cancelText: 'Keep',
                accentColor: Colors.orange,
                onConfirm: () {
                  // Handle remove
                },
              ),
              barrierDismissible: false,
            );
          },
          child: const Text('Show Custom Dialog'),
        ),

        // Full custom dialog
        ElevatedButton(
          onPressed: () {
            Get.dialog(
              DeleteConfirmationDialogCustom(
                title: 'Logout?',
                message:
                    'Are you sure you want to logout? You will need to login again.',
                confirmText: 'Logout',
                cancelText: 'Stay',
                icon: Iconsax.logout,
                iconColor: Colors.orange,
                confirmButtonColor: Colors.orange,
                onConfirm: () {
                  // Handle logout
                },
              ),
              barrierDismissible: false,
            );
          },
          child: const Text('Show Custom Dialog'),
        ),
      ],
    );
  }
}

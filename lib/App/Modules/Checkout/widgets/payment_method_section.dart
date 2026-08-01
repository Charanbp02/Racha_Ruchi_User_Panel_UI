import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Checkout_Model/checkout_model.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';
import 'package:racharuchi/App/Modules/Checkout/utils/payment_icons.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFE53935).withValues(alpha: 0.12),
                          const Color(0xFFE53935).withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE53935).withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Iconsax.card,
                      color: Color(0xFFE53935),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Payment Method',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Selected method indicator
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            size: 12,
                            color: const Color(0xFFE53935),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.selectedPaymentMethod.value.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment Methods Grid
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  alignment: WrapAlignment.start,
                  children:
                      controller.paymentMethods.map((method) {
                        final isSelected =
                            controller
                                .selectedPaymentMethod
                                .value
                                .displayName ==
                            method;
                        return _buildPaymentChip(
                          method: method,
                          isSelected: isSelected,
                          onSelected:
                              () => controller.updatePaymentMethod(method),
                          theme: theme,
                        );
                      }).toList(),
                ),
              ),

              // Payment Security Note
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade50,
                      Colors.green.shade50.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.shield_tick,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your payment information is secure and encrypted',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentChip({
    required String method,
    required bool isSelected,
    required VoidCallback onSelected,
    required ThemeData theme,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment Icon with gradient background
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFFE53935).withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                PaymentIcons.getIcon(method),
                size: 20,
                color:
                    isSelected ? const Color(0xFFE53935) : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              method,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
                color:
                    isSelected
                        ? const Color(0xFFE53935)
                        : const Color(0xFF1A1A2E),
                letterSpacing: -0.2,
              ),
            ),
            // Selected checkmark
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Iconsax.tick_circle,
                size: 16,
                color: const Color(0xFFE53935),
              ),
            ],
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) onSelected();
        },
        selectedColor: const Color(0xFFE53935).withValues(alpha: 0.08),
        backgroundColor: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? const Color(0xFFE53935) : Colors.grey.shade200,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: isSelected ? 2 : 0,
        shadowColor:
            isSelected
                ? const Color(0xFFE53935).withValues(alpha: 0.2)
                : Colors.transparent,
        pressElevation: 0,
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// Enhanced version with more features and animations
class PaymentMethodSectionEnhanced extends StatelessWidget {
  const PaymentMethodSectionEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFE53935).withValues(alpha: 0.12),
                          const Color(0xFFE53935).withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE53935).withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Iconsax.card,
                      color: Color(0xFFE53935),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Payment Method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  // Selected method indicator
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(
                            0xFFE53935,
                          ).withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            size: 12,
                            color: const Color(0xFFE53935),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.selectedPaymentMethod.value.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment Methods Grid
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Wrap(
                    key: ValueKey(
                      controller.selectedPaymentMethod.value.displayName,
                    ),
                    spacing: 10,
                    runSpacing: 12,
                    alignment: WrapAlignment.start,
                    children:
                        controller.paymentMethods.map((method) {
                          final isSelected =
                              controller
                                  .selectedPaymentMethod
                                  .value
                                  .displayName ==
                              method;
                          return _buildEnhancedPaymentChip(
                            method: method,
                            isSelected: isSelected,
                            onSelected:
                                () => controller.updatePaymentMethod(method),
                            theme: theme,
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Security and Payment Details
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.shade50,
                            Colors.green.shade50.withValues(alpha: 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.shield_tick,
                            size: 18,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Secure & Encrypted',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade50,
                            Colors.blue.shade50.withValues(alpha: 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 18,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Instant Confirmation',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
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
      ),
    );
  }

  Widget _buildEnhancedPaymentChip({
    required String method,
    required bool isSelected,
    required VoidCallback onSelected,
    required ThemeData theme,
  }) {
    // Payment method colors
    final Map<String, Color> methodColors = {
      'UPI': const Color(0xFF059669),
      'Cash on Delivery': const Color(0xFF2563EB),
    };

    final Color chipColor = methodColors[method] ?? const Color(0xFFE53935);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform:
          Matrix4.identity()
            ..scale(isSelected ? 1.03 : 1.0)
            ..translate(0, isSelected ? -2 : 0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? chipColor.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                PaymentIcons.getIcon(method),
                size: 20,
                color: isSelected ? chipColor : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              method,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
                color: isSelected ? chipColor : const Color(0xFF1A1A2E),
                letterSpacing: -0.2,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(Iconsax.tick_circle, size: 16, color: chipColor),
            ],
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) onSelected();
        },
        selectedColor: chipColor.withValues(alpha: 0.08),
        backgroundColor: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? chipColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: isSelected ? 2 : 0,
        shadowColor:
            isSelected ? chipColor.withValues(alpha: 0.2) : Colors.transparent,
        pressElevation: 0,
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

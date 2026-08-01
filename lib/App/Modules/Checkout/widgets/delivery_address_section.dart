import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/address_list.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/add_address_form.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header with icon
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
                            color: const Color(
                              0xFFE53935,
                            ).withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.location,
                          color: Color(0xFFE53935),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Delivery Address',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),

                  // Add/Cancel Button
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color:
                            controller.isAddingNewAddress.value
                                ? Colors.red.shade50
                                : const Color(
                                  0xFFE53935,
                                ).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              controller.isAddingNewAddress.value
                                  ? Colors.red.shade200
                                  : const Color(
                                    0xFFE53935,
                                  ).withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: TextButton.icon(
                        onPressed: controller.toggleAddNewAddress,
                        icon: AnimatedRotation(
                          turns:
                              controller.isAddingNewAddress.value ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          child: Icon(
                            controller.isAddingNewAddress.value
                                ? Iconsax.close_circle
                                : Iconsax.add_circle,
                            size: 18,
                            color:
                                controller.isAddingNewAddress.value
                                    ? Colors.red.shade600
                                    : const Color(0xFFE53935),
                          ),
                        ),
                        label: Text(
                          controller.isAddingNewAddress.value
                              ? 'Cancel'
                              : 'Add New',
                          style: TextStyle(
                            color:
                                controller.isAddingNewAddress.value
                                    ? Colors.red.shade600
                                    : const Color(0xFFE53935),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor:
                              controller.isAddingNewAddress.value
                                  ? Colors.red.shade600
                                  : const Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Address List or Add Form with Animation
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child:
                    controller.isAddingNewAddress.value
                        ? Container(
                          key: const ValueKey('addForm'),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: const AddAddressForm(),
                        )
                        : Container(
                          key: const ValueKey('addressList'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          child: const AddressList(),
                        ),
              ),
            ),

            // Bottom spacing
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Alternative version with more features
class DeliveryAddressSectionEnhanced extends StatelessWidget {
  const DeliveryAddressSectionEnhanced({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header with icon
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
                            color: const Color(
                              0xFFE53935,
                            ).withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.location,
                          color: Color(0xFFE53935),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                              letterSpacing: -0.3,
                            ),
                          ),
                          // Address count badge
                          Obx(
                            () => Text(
                              '${controller.addresses.length} address${controller.addresses.length > 1 ? 'es' : ''}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Add/Cancel Button
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color:
                            controller.isAddingNewAddress.value
                                ? Colors.red.shade50
                                : const Color(
                                  0xFFE53935,
                                ).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              controller.isAddingNewAddress.value
                                  ? Colors.red.shade200
                                  : const Color(
                                    0xFFE53935,
                                  ).withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: TextButton.icon(
                        onPressed: controller.toggleAddNewAddress,
                        icon: AnimatedRotation(
                          turns:
                              controller.isAddingNewAddress.value ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          child: Icon(
                            controller.isAddingNewAddress.value
                                ? Iconsax.close_circle
                                : Iconsax.add_circle,
                            size: 18,
                            color:
                                controller.isAddingNewAddress.value
                                    ? Colors.red.shade600
                                    : const Color(0xFFE53935),
                          ),
                        ),
                        label: Text(
                          controller.isAddingNewAddress.value
                              ? 'Cancel'
                              : 'Add New',
                          style: TextStyle(
                            color:
                                controller.isAddingNewAddress.value
                                    ? Colors.red.shade600
                                    : const Color(0xFFE53935),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor:
                              controller.isAddingNewAddress.value
                                  ? Colors.red.shade600
                                  : const Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.grey.shade200,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Address List or Add Form with Animation
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child:
                    controller.isAddingNewAddress.value
                        ? Container(
                          key: const ValueKey('addForm'),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          child: const AddAddressForm(),
                        )
                        : Container(
                          key: const ValueKey('addressList'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          child: const AddressList(),
                        ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

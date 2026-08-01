import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/bill_row.dart';

class BillDetailsSection extends StatelessWidget {
  const BillDetailsSection({super.key});

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient icon
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
                      Iconsax.receipt,
                      color: Color(0xFFE53935),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Bill Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Order count - using addresses count as fallback
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
                      child: Text(
                        '${controller.addresses.length} address${controller.addresses.length > 1 ? 'es' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: const Color(0xFFE53935),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bill details with Obx
              Obx(
                () => Column(
                  children: [
                    // Subtotal
                    BillRow(
                      label: 'Subtotal',
                      value: '₹${controller.subtotal.value.toStringAsFixed(2)}',
                      isSubtotal: true,
                    ),
                    const SizedBox(height: 10),

                    // Delivery Charge
                    BillRow(
                      label: 'Delivery Charge',
                      value:
                          controller.deliveryCharge.value == 0
                              ? 'Free'
                              : '₹${controller.deliveryCharge.value.toStringAsFixed(2)}',
                      isFree: controller.deliveryCharge.value == 0,
                      leadingIcon: Iconsax.truck,
                    ),
                    const SizedBox(height: 10),

                    // Divider with gradient
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
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

                    const SizedBox(height: 16),

                    // Grand Total with enhanced styling
                    BillRow(
                      label: 'Grand Total',
                      value:
                          '₹${controller.grandTotal.value.toStringAsFixed(2)}',
                      isTotal: true,
                      leadingIcon: Iconsax.receipt_item,
                    ),

                    const SizedBox(height: 8),

                    // Tax savings info - Simplified
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Taxes included',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
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
}

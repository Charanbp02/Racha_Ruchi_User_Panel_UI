import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/address_tile.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/delete_confirmation_dialog.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/checkout_shimmer.dart';

class AddressList extends StatelessWidget {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();

    return Obx(() {
      if (controller.isLoadingAddresses.value) {
        return const CheckoutShimmer();
      }

      if (controller.addresses.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F0F5)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_off_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No addresses saved',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add a new address to continue',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey(controller.addresses.length),
          children:
              controller.addresses.map((address) {
                final isSelected =
                    controller.selectedAddress.value?.id == address.id;
                return AddressTile(
                  address: address,
                  isSelected: isSelected,
                  onTap: () => controller.selectAddress(address),
                  onDelete: () {
                    Get.dialog(
                      DeleteConfirmationDialog(
                        onConfirm: () => controller.deleteAddress(address),
                      ),
                    );
                  },
                );
              }).toList(),
        ),
      );
    });
  }
}

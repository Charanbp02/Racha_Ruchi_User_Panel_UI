import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';
import '../controller/address_controller.dart';

class AddressBookView extends StatelessWidget {
  const AddressBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.put(AddressController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Address Book',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF2D2D2D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add, color: Color(0xFFE53935)),
            onPressed: () => controller.showAddAddressForm(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE53935)),
          );
        }

        if (controller.addresses.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return _buildAddressCard(address, controller);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddAddressForm(),
        backgroundColor: const Color(0xFFE53935),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.location,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Addresses Saved',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.find<AddressController>().showAddAddressForm(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, AddressController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            address.isDefault
                ? const Color(0xFFE53935).withValues(alpha: 0.05)
                : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              address.isDefault
                  ? const Color(0xFFE53935)
                  : Colors.grey.shade200,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type and default badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(
                          address.type,
                        ).withValues(alpha: 0.1),
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
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getTypeColor(address.type),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (address.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Name
                Row(
                  children: [
                    const Icon(Iconsax.user, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      address.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Phone
                Row(
                  children: [
                    const Icon(Iconsax.call, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(address.phone, style: const TextStyle(fontSize: 14)),
                    if (address.alternatePhone != null) ...[
                      const SizedBox(width: 16),
                      Text(
                        'Alt: ${address.alternatePhone}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Iconsax.location, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.addressLine1,
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (address.addressLine2 != null)
                            Text(
                              address.addressLine2!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          if (address.landmark != null)
                            Text(
                              'Landmark: ${address.landmark}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          Text(
                            '${address.city}, ${address.state} - ${address.pincode}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            address.country,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton.icon(
                    onPressed: () => controller.setDefaultAddress(address.id),
                    icon: const Icon(Iconsax.tick_circle, size: 18),
                    label: const Text('Set as Default'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE53935),
                    ),
                  ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => controller.showEditAddressForm(address),
                  icon: const Icon(Iconsax.edit, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => controller.deleteAddress(address.id),
                  icon: const Icon(Iconsax.trash, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
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

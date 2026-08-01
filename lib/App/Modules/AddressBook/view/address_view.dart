// lib/App/Modules/AddressBook/view/address_book_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/AddressBook/controller/address_controller.dart';
import 'package:racharuchi/App/Modules/AddressBook/widgets/address_card.dart';
import 'package:racharuchi/App/Modules/AddressBook/widgets/empty_address_state.dart';

class AddressBookView extends StatelessWidget {
  const AddressBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.put(AddressController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
      appBar: _buildAppBar(isDarkMode),
      body: RefreshIndicator(
        onRefresh: controller.refreshAddresses,
        color: const Color(0xFFE53935),
        child: Obx(() {
          if (controller.isLoading.value && controller.addresses.isEmpty) {
            return _buildLoadingState(isDarkMode);
          }

          if (controller.addresses.isEmpty) {
            return const EmptyAddressState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return AddressCard(address: address, controller: controller);
            },
          );
        }),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Text(
        'Address Book',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: _buildBackButton(isDarkMode),
    );
  }

  Widget _buildBackButton(bool isDarkMode) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: const Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading addresses...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Get.find<AddressController>().showAddAddressForm(),
      backgroundColor: const Color(0xFFE53935),
      elevation: 0,
      child: const Icon(Iconsax.add, color: Colors.white),
    );
  }
}

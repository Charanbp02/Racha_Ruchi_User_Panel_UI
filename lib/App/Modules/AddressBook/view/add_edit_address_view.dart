// lib/App/Modules/AddressBook/view/add_edit_address_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';
import 'package:racharuchi/App/Modules/AddressBook/controller/address_controller.dart';
import 'package:racharuchi/App/Modules/AddressBook/widgets/address_type_chip.dart';
import 'package:racharuchi/App/Modules/AddressBook/widgets/address_form_field.dart';

class AddEditAddressView extends StatelessWidget {
  final AddressModel? address;

  AddEditAddressView({super.key, this.address}) {
    if (address != null) {
      _nameController.text = address!.name;
      _phoneController.text = address!.phone;
      _altPhoneController.text = address!.alternatePhone ?? '';
      _addressLine1Controller.text = address!.addressLine1;
      _addressLine2Controller.text = address!.addressLine2 ?? '';
      _landmarkController.text = address!.landmark ?? '';
      _cityController.text = address!.city;
      _stateController.text = address!.state;
      _pincodeController.text = address!.pincode;
      _countryController.text = address!.country;
      _selectedType.value = address!.type;
      _isDefault.value = address!.isDefault;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _selectedType = 'Home'.obs;
  final _isDefault = false.obs;

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.find<AddressController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FA),
      appBar: _buildAppBar(isDarkMode),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Type
              _buildAddressTypeSection(isDarkMode),
              const SizedBox(height: 20),

              // Form Fields
              AddressFormField(
                controller: _nameController,
                label: 'Full Name',
                icon: Iconsax.user,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AddressFormField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AddressFormField(
                controller: _altPhoneController,
                label: 'Alternate Phone Number (Optional)',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              AddressFormField(
                controller: _addressLine1Controller,
                label: 'Address Line 1',
                icon: Iconsax.location,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AddressFormField(
                controller: _addressLine2Controller,
                label: 'Address Line 2 (Optional)',
                icon: Iconsax.location,
              ),
              const SizedBox(height: 16),

              AddressFormField(
                controller: _landmarkController,
                label: 'Landmark (Optional)',
                icon: Iconsax.building,
              ),
              const SizedBox(height: 16),

              // City & State Row
              Row(
                children: [
                  Expanded(
                    child: AddressFormField(
                      controller: _cityController,
                      label: 'City',
                      icon: Iconsax.building,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AddressFormField(
                      controller: _stateController,
                      label: 'State',
                      icon: Iconsax.building,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pincode & Country Row
              Row(
                children: [
                  Expanded(
                    child: AddressFormField(
                      controller: _pincodeController,
                      label: 'Pincode',
                      icon: Iconsax.location,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter pincode';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AddressFormField(
                      controller: _countryController,
                      label: 'Country',
                      icon: Iconsax.flag,
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter country';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Set as Default
              _buildDefaultCheckbox(isDarkMode),
              const SizedBox(height: 30),

              // Save Button
              _buildSaveButton(controller, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Text(
        address == null ? 'Add New Address' : 'Edit Address',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 18,
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

  Widget _buildAddressTypeSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Type',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              AddressTypeChip(
                label: 'Home',
                icon: Iconsax.home,
                isSelected: _selectedType.value == 'Home',
                onTap: () => _selectedType.value = 'Home',
              ),
              const SizedBox(width: 12),
              AddressTypeChip(
                label: 'Work',
                icon: Iconsax.building,
                isSelected: _selectedType.value == 'Work',
                onTap: () => _selectedType.value = 'Work',
              ),
              const SizedBox(width: 12),
              AddressTypeChip(
                label: 'Other',
                icon: Iconsax.location,
                isSelected: _selectedType.value == 'Other',
                onTap: () => _selectedType.value = 'Other',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultCheckbox(bool isDarkMode) {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: _isDefault.value,
            onChanged: (value) => _isDefault.value = value ?? false,
            activeColor: const Color(0xFFE53935),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Text(
            'Set as default address',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(AddressController controller, bool isDarkMode) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      final newAddress = AddressModel(
                        id: address?.id ?? '',
                        type: _selectedType.value,
                        name: _nameController.text,
                        phone: _phoneController.text,
                        alternatePhone:
                            _altPhoneController.text.isNotEmpty
                                ? _altPhoneController.text
                                : null,
                        addressLine1: _addressLine1Controller.text,
                        addressLine2:
                            _addressLine2Controller.text.isNotEmpty
                                ? _addressLine2Controller.text
                                : null,
                        landmark:
                            _landmarkController.text.isNotEmpty
                                ? _landmarkController.text
                                : null,
                        city: _cityController.text,
                        state: _stateController.text,
                        pincode: _pincodeController.text,
                        country: _countryController.text,
                        isDefault: _isDefault.value,
                        createdAt: address?.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      if (address == null) {
                        controller.addAddress(newAddress);
                        // After adding, check if we should return to checkout
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (Get.previousRoute == '/checkout') {
                            Get.back(); // Go back to checkout
                          }
                        });
                      } else {
                        controller.editAddress(newAddress);
                      }
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child:
              controller.isLoading.value
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    address == null ? 'Add Address' : 'Update Address',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}

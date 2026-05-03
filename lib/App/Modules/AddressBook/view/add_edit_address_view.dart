import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';
import 'package:racharuchi/App/Modules/AddressBook/controller/address_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          address == null ? 'Add New Address' : 'Edit Address',
          style: const TextStyle(
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Type
              const Text(
                'Address Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    _buildTypeChip('Home', Iconsax.home, _selectedType),
                    const SizedBox(width: 12),
                    _buildTypeChip('Work', Iconsax.building, _selectedType),
                    const SizedBox(width: 12),
                    _buildTypeChip('Other', Iconsax.location, _selectedType),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Iconsax.user,
                validator:
                    (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 16),

              // Alternate Phone
              _buildTextField(
                controller: _altPhoneController,
                label: 'Alternate Phone Number (Optional)',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Address Line 1
              _buildTextField(
                controller: _addressLine1Controller,
                label: 'Address Line 1',
                icon: Iconsax.location,
                validator:
                    (value) => value!.isEmpty ? 'Please enter address' : null,
              ),
              const SizedBox(height: 16),

              // Address Line 2
              _buildTextField(
                controller: _addressLine2Controller,
                label: 'Address Line 2 (Optional)',
                icon: Iconsax.location,
              ),
              const SizedBox(height: 16),

              // Landmark
              _buildTextField(
                controller: _landmarkController,
                label: 'Landmark (Optional)',
                icon: Iconsax.building,
              ),
              const SizedBox(height: 16),

              // City & State Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: Iconsax.building,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter city' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _stateController,
                      label: 'State',
                      icon: Iconsax.building,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter state' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pincode & Country Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _pincodeController,
                      label: 'Pincode',
                      icon: Iconsax.location,
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter pincode' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _countryController,
                      label: 'Country',
                      icon: Iconsax.flag,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter country' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newAddress = AddressModel(
                        id: address?.id ?? DateTime.now().toString(),
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
                        isDefault: address?.isDefault ?? false,
                      );

                      if (address == null) {
                        controller.addAddress(newAddress);
                      } else {
                        controller.editAddress(newAddress);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    address == null ? 'Add Address' : 'Update Address',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon, RxString selectedType) {
    final isSelected = selectedType.value == label;
    return GestureDetector(
      onTap: () => selectedType.value = label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFFE53935)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

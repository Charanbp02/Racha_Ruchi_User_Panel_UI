import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';
import 'package:racharuchi/App/Modules/AddressBook/view/add_edit_address_view.dart';

class AddressController extends GetxController {
  var addresses = <AddressModel>[].obs;
  var isLoading = false.obs;
  var selectedAddressId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  void loadAddresses() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      addresses.value = [
        AddressModel(
          id: '1',
          type: 'Home',
          name: 'Ramesh Kumar',
          phone: '+91 98765 43210',
          alternatePhone: '+91 98765 43211',
          addressLine1: '123, MG Road',
          addressLine2: 'Near City Mall',
          landmark: 'Opposite City Metro Station',
          city: 'Bangalore',
          state: 'Karnataka',
          pincode: '560001',
          country: 'India',
          isDefault: true,
          latitude: 12.9716,
          longitude: 77.5946,
        ),
        AddressModel(
          id: '2',
          type: 'Work',
          name: 'Ramesh Kumar',
          phone: '+91 98765 43210',
          addressLine1: '456, Tech Park',
          addressLine2: 'Electronic City',
          landmark: 'Near Infosys Campus',
          city: 'Bangalore',
          state: 'Karnataka',
          pincode: '560100',
          country: 'India',
          isDefault: false,
          latitude: 12.8458,
          longitude: 77.6605,
        ),
        AddressModel(
          id: '3',
          type: 'Other',
          name: 'Ramesh Kumar',
          phone: '+91 98765 43210',
          addressLine1: '789, Residency Road',
          addressLine2: 'Shanthinagar',
          landmark: 'Near Forum Mall',
          city: 'Bangalore',
          state: 'Karnataka',
          pincode: '560025',
          country: 'India',
          isDefault: false,
          latitude: 12.9609,
          longitude: 77.5946,
        ),
      ];
      isLoading.value = false;
    });
  }

  void setDefaultAddress(String id) {
    for (var address in addresses) {
      address.isDefault = address.id == id;
    }
    selectedAddressId.value = id;
    addresses.refresh();

    Get.snackbar(
      'Default Address Updated',
      'Your default address has been changed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteAddress(String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              addresses.removeWhere((address) => address.id == id);
              Get.back();
              Get.snackbar(
                'Deleted',
                'Address deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void addAddress(AddressModel address) {
    addresses.add(address);
    addresses.refresh();
    Get.back();
    Get.snackbar(
      'Address Added',
      'New address added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void editAddress(AddressModel address) {
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      addresses[index] = address;
      addresses.refresh();
      Get.back();
      Get.snackbar(
        'Address Updated',
        'Address updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void showAddAddressForm() {
    Get.to(() =>  AddEditAddressView());
  }

  void showEditAddressForm(AddressModel address) {
    Get.to(() => AddEditAddressView(address: address));
  }
}



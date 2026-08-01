// lib/App/Modules/AddressBook/controller/address_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racharuchi/App/Models/Address_Book_Model/address_book_model.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class AddressController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var addresses = <AddressModel>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  var selectedAddressId = ''.obs;

  // Performance optimization
  bool _isInitialized = false;
  StreamSubscription<QuerySnapshot>? _addressesSubscription;

  String? get currentUserId => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    // Use post frame callback to avoid blocking initial rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUserId != null && !_isInitialized) {
        _initializeRealtimeAddresses();
      }
    });
  }

  @override
  void onClose() {
    _addressesSubscription?.cancel();
    super.onClose();
  }

  // Optimized real-time addresses listener
  void _initializeRealtimeAddresses() {
    if (currentUserId == null || _isInitialized) return;

    _isInitialized = true;
    isLoading.value = true;

    // Use simpler query without complex ordering initially
    _addressesSubscription = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('addresses')
        .snapshots()
        .listen(
          (snapshot) {
            // Process data in a non-blocking way
            Future(() {
              final addressList =
                  snapshot.docs.map((doc) {
                    return AddressModel.fromMap(doc.data(), doc.id);
                  }).toList();

              // Sort on client side (less strain on Firestore)
              addressList.sort((a, b) {
                if (a.isDefault && !b.isDefault) return -1;
                if (!a.isDefault && b.isDefault) return 1;
                return b.createdAt.compareTo(a.createdAt);
              });

              addresses.value = addressList;

              final defaultAddress = addressList.firstWhereOrNull(
                (a) => a.isDefault,
              );
              if (defaultAddress != null) {
                selectedAddressId.value = defaultAddress.id;
              }

              isLoading.value = false;
              print('✅ Addresses updated: ${addressList.length} addresses');
            });
          },
          onError: (error) {
            print('❌ Error loading addresses: $error');
            Future(() {
              isLoading.value = false;
              if (Get.isSnackbarOpen == false) {
                Get.snackbar(
                  'Error',
                  'Failed to load addresses. Please check your connection.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            });
          },
        );
  }

  // Set default address with batch write
  Future<void> setDefaultAddress(String id) async {
    if (currentUserId == null) return;

    isSyncing.value = true;

    try {
      final addressesRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('addresses');

      final batch = _firestore.batch();
      final snapshot = await addressesRef.get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isDefault': doc.id == id});
      }

      await batch.commit();

      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Success',
          'Default address updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error setting default address: $e');
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Error',
          'Failed to update default address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } finally {
      isSyncing.value = false;
    }
  }

  // Add new address
  Future<void> addAddress(AddressModel address) async {
    if (currentUserId == null) {
      _showError('Please login to add address');
      return;
    }

    isLoading.value = true;

    try {
      final addressesRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('addresses');

      // Check if this is the first address
      final snapshot = await addressesRef.limit(1).get();
      final isFirstAddress = snapshot.docs.isEmpty;

      final shouldBeDefault = address.isDefault || isFirstAddress;

      // If setting as default, update others
      if (shouldBeDefault && !isFirstAddress) {
        final allAddresses = await addressesRef.get();
        if (allAddresses.docs.isNotEmpty) {
          final batch = _firestore.batch();
          for (var doc in allAddresses.docs) {
            batch.update(doc.reference, {'isDefault': false});
          }
          await batch.commit();
        }
      }

      // Add new address
      final docRef = addressesRef.doc();
      final newAddress = AddressModel(
        id: docRef.id,
        type: address.type,
        name: address.name,
        phone: address.phone,
        alternatePhone: address.alternatePhone,
        addressLine1: address.addressLine1,
        addressLine2: address.addressLine2,
        landmark: address.landmark,
        city: address.city,
        state: address.state,
        pincode: address.pincode,
        country: address.country,
        isDefault: shouldBeDefault,
        latitude: address.latitude,
        longitude: address.longitude,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(newAddress.toMap());

      Get.back();
      _showSuccess('Address added successfully');
    } catch (e) {
      print('Error adding address: $e');
      _showError('Failed to add address');
    } finally {
      isLoading.value = false;
    }
  }

  // Edit address
  Future<void> editAddress(AddressModel address) async {
    if (currentUserId == null) {
      _showError('Please login to edit address');
      return;
    }

    isLoading.value = true;

    try {
      final addressRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('addresses')
          .doc(address.id);

      // If setting as default, update other addresses
      if (address.isDefault) {
        final addressesRef = _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('addresses');

        final snapshot = await addressesRef.get();
        if (snapshot.docs.isNotEmpty) {
          final batch = _firestore.batch();
          for (var doc in snapshot.docs) {
            if (doc.id != address.id) {
              batch.update(doc.reference, {'isDefault': false});
            }
          }
          await batch.commit();
        }
      }

      await addressRef.update(address.toMap(isUpdate: true));

      Get.back();
      _showSuccess('Address updated successfully');
    } catch (e) {
      print('Error updating address: $e');
      _showError('Failed to update address');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete address
  Future<void> deleteAddress(String id) async {
    if (currentUserId == null) {
      _showError('Please login to delete address');
      return;
    }

    // Show confirmation dialog first
    final shouldDelete =
        await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Delete Address'),
              ],
            ),
            content: const Text(
              'Are you sure you want to delete this address? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) return;

    isLoading.value = true;

    try {
      final addressRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('addresses')
          .doc(id);

      final addressDoc = await addressRef.get();
      final wasDefault = addressDoc.data()?['isDefault'] ?? false;

      await addressRef.delete();

      // If deleted address was default, set another as default
      if (wasDefault && addresses.length > 1) {
        final remainingAddresses = addresses.where((a) => a.id != id).toList();
        if (remainingAddresses.isNotEmpty) {
          await setDefaultAddress(remainingAddresses.first.id);
        }
      }

      _showSuccess('Address deleted successfully');
    } catch (e) {
      print('Error deleting address: $e');
      _showError('Failed to delete address');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods
  AddressModel? getAddressById(String id) {
    try {
      return addresses.firstWhere((address) => address.id == id);
    } catch (e) {
      return null;
    }
  }

  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  void showAddAddressForm() {
    Get.toNamed(Routes.ADD_EDIT_ADDRESS);
  }

  void showEditAddressForm(AddressModel address) {
    Get.toNamed(Routes.ADD_EDIT_ADDRESS, arguments: address);
  }

  Future<void> refreshAddresses() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
  }

  void _showSuccess(String message) {
    if (Get.isSnackbarOpen == false) {
      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void _showError(String message) {
    if (Get.isSnackbarOpen == false) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

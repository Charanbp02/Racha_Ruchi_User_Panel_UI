import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Checkout/controller/checkout_controller.dart';
import 'package:racharuchi/App/Modules/Checkout/widgets/form_text_field.dart';

class AddAddressForm extends StatelessWidget {
  const AddAddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: controller.addressFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.location_add,
                    color: Color(0xFFE53935),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add New Address',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Divider
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            const SizedBox(height: 24),

            // Contact Name
            _buildFormField(
              child: FormTextField(
                controller: controller.contactNameController,
                label: 'Contact Name *',
                icon: Iconsax.user,
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Contact name is required'
                            : null,
              ),
            ),
            const SizedBox(height: 18),

            // Mobile Number
            _buildFormField(
              child: FormTextField(
                controller: controller.mobileNumberController,
                label: 'Mobile Number *',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Mobile number is required';
                  }
                  if (value?.length != 10) return 'Enter valid 10-digit number';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 18),

            // Alternate Phone
            _buildFormField(
              child: FormTextField(
                controller: controller.alternatePhoneController,
                label: 'Alternate Phone (Optional)',
                icon: Iconsax.call_calling,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Address Line 1
            _buildFormField(
              child: FormTextField(
                controller: controller.addressLineController,
                label: 'Address Line 1 *',
                icon: Iconsax.building,
                maxLines: 2,
                validator:
                    (value) =>
                        value?.isEmpty ?? true ? 'Address is required' : null,
              ),
            ),
            const SizedBox(height: 18),

            // Address Line 2
            _buildFormField(
              child: FormTextField(
                controller: controller.addressLine2Controller,
                label: 'Address Line 2 (Optional)',
                icon: Iconsax.building_4,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 18),

            // Landmark
            _buildFormField(
              child: FormTextField(
                controller: controller.landmarkController,
                label: 'Landmark (Optional)',
                icon: Iconsax.location,
              ),
            ),
            const SizedBox(height: 18),

            // City & State
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildFormField(
                    child: FormTextField(
                      controller: controller.cityController,
                      label: 'City *',
                      icon: Iconsax.building_3,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'City is required'
                                  : null,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildFormField(
                    child: FormTextField(
                      controller: controller.stateController,
                      label: 'State *',
                      icon: Iconsax.map,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'State is required'
                                  : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Pincode & Country
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildFormField(
                    child: FormTextField(
                      controller: controller.pincodeController,
                      label: 'Pincode *',
                      icon: Iconsax.location_tick,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Pincode is required';
                        }
                        if (value?.length != 6) {
                          return 'Enter valid 6-digit pincode';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildFormField(
                    child: FormTextField(
                      controller: controller.countryController,
                      label: 'Country *',
                      icon: Iconsax.global,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'Country is required'
                                  : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Save Address Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.addNewAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: const Color(0xFFE53935).withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.save_2, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Save Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Optional: Add subtle text at bottom
            const SizedBox(height: 12),
            Center(
              child: Text(
                'All fields marked with * are required',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent form field styling
  Widget _buildFormField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: child,
    );
  }
}

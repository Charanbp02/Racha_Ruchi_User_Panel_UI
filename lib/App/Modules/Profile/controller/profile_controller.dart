import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // User Information
  var userName = 'Rajesh Kumar'.obs;
  var userEmail = 'rajesh.kumar@example.com'.obs;
  var userPhone = '+91 98765 43210'.obs;
  var userImage = 'https://randomuser.me/api/portraits/men/1.jpg'.obs;

  // Stats
  var recipes = '24'.obs;
  var followers = '1.2k'.obs;
  var following = '345'.obs;
  var totalLikes = '2.3k'.obs;

  // UI States
  var isLoading = false.obs;
  var isEditing = false.obs;

  // Menu Items
  var menuItems =
      <Map<String, dynamic>>[
        {'title': 'My Orders', 'icon': Iconsax.shopping_bag},
        {'title': 'My Recipes', 'icon': Iconsax.document},
        {'title': 'Coupons', 'icon': Iconsax.discount_circle},
        {'title': 'Address Book', 'icon': Iconsax.location},
        {'title': 'Notifications', 'icon': Iconsax.notification},
        {'title': 'Help & Support', 'icon': Iconsax.headphone},
        {'title': 'Privacy Policy', 'icon': Iconsax.shield_tick},
        {'title': 'Logout', 'icon': Iconsax.logout},
      ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  void toggleEditMode() {
    if (isEditing.value) {
      // Save changes
      saveProfile();
    }
    isEditing.value = !isEditing.value;
  }

  void saveProfile() async {
    isLoading.value = true;
    // Simulate saving to API
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void editField(String fieldName, String currentValue) {
    TextEditingController textController = TextEditingController(
      text: currentValue,
    );

    Get.dialog(
      AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter $fieldName',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              String newValue = textController.text.trim();
              if (newValue.isNotEmpty) {
                switch (fieldName) {
                  case 'Name':
                    userName.value = newValue;
                    break;
                  case 'Email':
                    userEmail.value = newValue;
                    break;
                  case 'Phone':
                    userPhone.value = newValue;
                    break;
                }
                Get.back();
                Get.snackbar(
                  'Updated',
                  '$fieldName updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void updateProfileImage(String imageUrl) {
    userImage.value = imageUrl;
    Get.snackbar(
      'Success',
      'Profile picture updated',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Get.snackbar(
        'Success',
        'Image selected from gallery',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Update with local path or upload URL
      // userImage.value = image.path;
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Get.snackbar(
        'Success',
        'Image captured from camera',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Update with local path or upload URL
      // userImage.value = image.path;
    }
  }

  void onMenuItemTap(Map<String, dynamic> item) {
    final String title = item['title'];

    switch (title) {
      case 'My Orders':
        // This is handled in the view now
        break;
      case 'Logout':
        logout();
        break;
      default:
        Get.snackbar(
          'Coming Soon',
          '$title feature is under development',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
    }
  }

  void logout() {
    // Clear user data
    Get.offAllNamed('/login');
  }
}

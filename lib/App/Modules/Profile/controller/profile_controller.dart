import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ProfileController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final FirebaseStorage _storage;

  // User Information
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userImage = ''.obs;
  var userId = ''.obs;

  // Stats
  var recipes = '0'.obs;
  var followers = '0'.obs;
  var following = '0'.obs;
  var totalLikes = '0'.obs;

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
        {'title': 'About Us', 'icon': Iconsax.info_circle},
        {'title': 'Logout', 'icon': Iconsax.logout},
      ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize Firebase Storage
    _storage = FirebaseStorage.instance;
    fetchUserData();
    fetchUserStats();
  }

  void fetchUserData() async {
    try {
      isLoading.value = true;

      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        userId.value = currentUser.uid;
        userEmail.value = currentUser.email ?? '';
        userName.value = currentUser.displayName ?? '';
        userImage.value = currentUser.photoURL ?? '';

        // Fetch additional user data from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          userName.value = userData['name'] ?? currentUser.displayName ?? '';
          userPhone.value = userData['phone'] ?? '';
          if (userData['imageUrl'] != null && userData['imageUrl'] != '') {
            userImage.value = userData['imageUrl'];
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUserStats() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Fetch user's recipes count
      QuerySnapshot recipesSnapshot =
          await _firestore
              .collection('recipes')
              .where('userId', isEqualTo: currentUser.uid)
              .get();
      recipes.value = recipesSnapshot.docs.length.toString();

      // Fetch followers count
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        followers.value = (userData['followersCount'] ?? 0).toString();
        following.value = (userData['followingCount'] ?? 0).toString();
        totalLikes.value = (userData['totalLikes'] ?? 0).toString();
      }
    } catch (e) {
      print('Error fetching user stats: $e');
    }
  }

  void toggleEditMode() {
    if (isEditing.value) {
      // Save changes
      saveProfile();
    }
    isEditing.value = !isEditing.value;
  }

  void saveProfile() async {
    try {
      isLoading.value = true;

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      // Update Firebase Auth profile
      await currentUser.updateDisplayName(userName.value);
      await currentUser.reload();

      // Update Firestore
      await _firestore.collection('users').doc(currentUser.uid).set({
        'name': userName.value,
        'email': userEmail.value,
        'phone': userPhone.value,
        'imageUrl': userImage.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
            onPressed: () async {
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

                // Save immediately to Firebase
                saveProfile();
                Get.back();
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

  Future<void> updateProfileImage(String imageUrl) async {
    try {
      isLoading.value = true;

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      // Update Firestore with new image URL
      await _firestore.collection('users').doc(currentUser.uid).update({
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      userImage.value = imageUrl;

      Get.snackbar(
        'Success',
        'Profile picture updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile picture',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Upload image to Firebase Storage
        String imageUrl = await uploadImageToStorage(image);
        await updateProfileImage(imageUrl);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        // Upload image to Firebase Storage
        String imageUrl = await uploadImageToStorage(image);
        await updateProfileImage(imageUrl);
      }
    } catch (e) {
      print('Error picking image from camera: $e');
      Get.snackbar(
        'Error',
        'Failed to capture image from camera',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String> uploadImageToStorage(XFile image) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      String fileName =
          'profile_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child('profile_images/$fileName');

      await ref.putFile(File(image.path));
      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
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

  void logout() async {
    try {
      await _auth.signOut();
      // Clear user data
      userName.value = '';
      userEmail.value = '';
      userPhone.value = '';
      userImage.value = '';
      userId.value = '';

      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error logging out: $e');
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

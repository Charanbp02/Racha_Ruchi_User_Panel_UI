import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class SignUpController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;
  var agreeToTerms = false.obs;
  var errorMessage = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  void validateAndSignUp() async {
    errorMessage.value = '';

    // Validate name
    if (name.value.isEmpty) {
      errorMessage.value = 'Please enter your name';
      return;
    }

    // Validate email
    if (email.value.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }

    if (!GetUtils.isEmail(email.value)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }

    // Validate password
    if (password.value.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return;
    }

    if (password.value.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return;
    }

    // Validate confirm password
    if (confirmPassword.value != password.value) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    // Validate terms
    if (!agreeToTerms.value) {
      errorMessage.value = 'Please agree to the terms and conditions';
      return;
    }

    isLoading.value = true;

    try {
      // Create user with Firebase
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.value.trim(),
            password: password.value,
          );

      // Update user profile with name
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name.value);
        await userCredential.user!.reload();

        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name.value,
          'email': email.value.trim(),
          'phone': '',
          'imageUrl': '',
          'followersCount': 0,
          'followingCount': 0,
          'totalLikes': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Show success message
      Get.snackbar(
        'Welcome! 🎉',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate directly to home page after a short delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Navigate to home page and remove all previous routes
      Get.offAllNamed(AppRoutes.BOTTOM_BAR);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = 'Failed to create account. Please try again.';
      }
      errorMessage.value = message;
      Get.snackbar(
        'Sign Up Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      Get.snackbar(
        'Error',
        'Failed to create account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void login() {
    Get.back(); // Navigate back to login screen
  }
}

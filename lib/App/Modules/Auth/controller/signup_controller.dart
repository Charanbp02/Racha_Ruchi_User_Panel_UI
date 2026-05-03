import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    Get.snackbar(
      'Success',
      'Account created successfully! Please login.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back to login
    Get.back();

    isLoading.value = false;
  }

  void login() {
    Get.back();
  }
}

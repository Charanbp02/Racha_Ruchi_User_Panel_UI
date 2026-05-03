import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void validateAndLogin() async {
    // Clear previous error
    errorMessage.value = '';

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

    // Start login process
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Check credentials (demo purpose)
    if (email.value == 'demo@racharuchi.com' && password.value == '123456') {
      // Save credentials if remember me is checked
      if (rememberMe.value) {
        // Save to shared preferences
        Get.find<CacheManager>().saveUserCredentials(
          email.value,
          password.value,
        );
      }

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home
      Get.offAllNamed('/bottom-nav');
    } else {
      errorMessage.value = 'Invalid email or password';
      Get.snackbar(
        'Login Failed',
        'Invalid email or password. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  void forgotPassword() {
    Get.snackbar(
      'Reset Password',
      'Password reset link sent to your email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void signUp() {
    Get.toNamed('/signup');
  }

  void continueWithGoogle() {
    Get.snackbar(
      'Google Sign In',
      'Google sign in feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void continueWithFacebook() {
    Get.snackbar(
      'Facebook Sign In',
      'Facebook sign in feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void continueWithApple() {
    Get.snackbar(
      'Apple Sign In',
      'Apple sign in feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class CacheManager extends GetxService {
  void saveUserCredentials(String email, String password) {
    // Implement shared preferences saving
    print('Saved credentials for $email');
  }
}

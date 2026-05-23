import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var errorMessage = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadSavedCredentials();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
    if (!rememberMe.value) {
      CacheManager().clearCredentials();
    }
  }

  Future<void> loadSavedCredentials() async {
    final credentials = await CacheManager().getUserCredentials();
    if (credentials != null) {
      email.value = credentials['email']!;
      password.value = credentials['password']!;
      rememberMe.value = true;
    }
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

    try {
      // Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );

      // Save credentials if remember me is checked
      if (rememberMe.value) {
        await CacheManager().saveUserCredentials(email.value, password.value);
      } else {
        await CacheManager().clearCredentials();
      }

      // Ensure user document exists in Firestore
      await ensureUserDocument(userCredential.user!);

      String userName = userCredential.user?.displayName ?? '';

      Get.snackbar(
        'Success',
        userName.isNotEmpty ? 'Welcome back $userName!' : 'Login Successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home
      Get.offAllNamed(AppRoutes.BOTTOM_BAR);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = 'Login failed. Please try again.';
      }
      errorMessage.value = message;
      Get.snackbar(
        'Login Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      Get.snackbar(
        'Error',
        'Failed to login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ensureUserDocument(User user) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create user document if it doesn't exist
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone': '',
          'imageUrl': user.photoURL ?? '',
          'followersCount': 0,
          'followingCount': 0,
          'totalLikes': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error ensuring user document: $e');
    }
  }

  Future<void> continueWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Ensure user document exists in Firestore
      await ensureUserDocument(userCredential.user!);

      Get.snackbar(
        'Success',
        'Google Login Successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(AppRoutes.BOTTOM_BAR);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Google Sign In Failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() async {
    if (email.value.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await _auth.sendPasswordResetEmail(email: email.value.trim());
      Get.snackbar(
        'Reset Password',
        'Password reset link sent to ${email.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Failed',
        e.message ?? 'Failed to send reset email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signUp() {
    Get.toNamed(AppRoutes.SIGNUP);
  }
}

class CacheManager {
  static const String _keyEmail = 'saved_email';
  static const String _keyPassword = 'saved_password';
  static const String _keyRememberMe = 'remember_me';

  Future<void> saveUserCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    await prefs.setBool(_keyRememberMe, true);
  }

  Future<Map<String, String>?> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;

    if (rememberMe) {
      final email = prefs.getString(_keyEmail);
      final password = prefs.getString(_keyPassword);
      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
    }
    return null;
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.setBool(_keyRememberMe, false);
  }

  Future<bool> isRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }
}

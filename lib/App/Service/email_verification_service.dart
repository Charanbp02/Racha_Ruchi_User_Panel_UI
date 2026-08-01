// lib/App/Modules/Auth/service/email_verification_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racharuchi/App/Routes/app_routes.dart';

class EmailVerificationService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isEmailVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen(_handleAuthStateChange);
  }

  void _handleAuthStateChange(User? user) {
    if (user != null) {
      // Check verification status immediately
      _checkVerificationStatus();

      // Set up periodic check every 5 seconds while user is logged in
      Future.delayed(const Duration(seconds: 5), () {
        if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
          _checkVerificationStatus();
        }
      });
    } else {
      isEmailVerified.value = false;
    }
  }

  Future<void> _checkVerificationStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      final updatedUser = _auth.currentUser;
      if (updatedUser != null) {
        isEmailVerified.value = updatedUser.emailVerified;

        // If email just got verified, update Firestore
        if (isEmailVerified.value) {
          await _updateEmailVerificationStatus(updatedUser.uid);
        }
      }
    }
  }

  Future<void> _updateEmailVerificationStatus(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'emailVerified': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating email verification status: $e');
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> checkAndRedirect() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      // User is logged in but email not verified
      await _auth.signOut();
      Get.offAllNamed(AppRoutes.LOGIN);
      Get.snackbar(
        'Email Required',
        'Please verify your email address before accessing the app.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }
    return true;
  }

  Future<void> resendVerificationEmail(String email, String password) async {
    try {
      // Sign in temporarily to resend verification
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      await _auth.signOut();

      Get.snackbar(
        'Verification Email Sent',
        'Please check your inbox to verify your email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend verification email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

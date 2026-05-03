import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Auth/controller/signup_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Back Button
                  IconButton(
                    icon: const Icon(Iconsax.arrow_left, size: 28),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign up to get started",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sign Up Form
                  _buildSignUpForm(controller),

                  const SizedBox(height: 24),

                  // Sign Up Button
                  _buildSignUpButton(controller),

                  const SizedBox(height: 24),

                  // Terms and Conditions
                  _buildTermsAndConditions(controller),

                  const SizedBox(height: 24),

                  // Login Link
                  _buildLoginLink(controller),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(SignUpController controller) {
    return Column(
      children: [
        // Name Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            onChanged: (value) => controller.name.value = value,
            decoration: InputDecoration(
              hintText: "Full Name",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Iconsax.user, color: Color(0xFFE53935)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE53935),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Email Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            onChanged: (value) => controller.email.value = value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Iconsax.sms, color: Color(0xFFE53935)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE53935),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Password Field
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              onChanged: (value) => controller.password.value = value,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Iconsax.lock, color: Color(0xFFE53935)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: Colors.grey,
                  ),
                  onPressed: () => controller.togglePasswordVisibility(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password Field
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              onChanged: (value) => controller.confirmPassword.value = value,
              obscureText: !controller.isConfirmPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Iconsax.lock, color: Color(0xFFE53935)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: Colors.grey,
                  ),
                  onPressed: () => controller.toggleConfirmPasswordVisibility(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),

        // Error Message
        Obx(
          () =>
              controller.errorMessage.value.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.warning_2,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(SignUpController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () => controller.validateAndSignUp(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child:
              controller.isLoading.value
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions(SignUpController controller) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: controller.agreeToTerms.value,
              onChanged: (_) => controller.toggleAgreeToTerms(),
              activeColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "I agree to the ",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                children: [
                  TextSpan(
                    text: "Terms of Service",
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink(SignUpController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        GestureDetector(
          onTap: () => controller.login(),
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Color(0xFFE53935),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

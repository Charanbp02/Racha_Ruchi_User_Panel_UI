import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Auth/controller/signup_controller.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_header.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_text_field.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_button.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_link.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/error_message.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/terms_and_conditions.dart';

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
                  const SizedBox(height: 12),
                  AuthHeader(
                    title: "Create Account",
                    subtitle:
                        "Join our community and start your journey with us",
                    showBackButton: true,
                  ),
                  const SizedBox(height: 40),
                  _buildSignUpForm(controller),
                  const SizedBox(height: 28),
                  AuthButton(
                    text: "Create Account",
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.validateAndSignUp,
                    isLoading: controller.isLoading.value,
                  ),
                  const SizedBox(height: 20),
                  TermsAndConditions(
                    isChecked: controller.agreeToTerms,
                    onTap: controller.toggleAgreeToTerms,
                  ),
                  const SizedBox(height: 20),
                  AuthLink(
                    question: "Already have an account? ",
                    actionText: "Sign In",
                    onTap: controller.login,
                    showArrow: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(SignUpController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AuthTextField(
            hint: "Full Name ",
            prefixIcon: Iconsax.user,
            onChanged: (value) => controller.name.value = value,
          ),
          const SizedBox(height: 14),
          AuthTextField(
            hint: "Email Address",
            prefixIcon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.email.value = value,
          ),
          const SizedBox(height: 14),
          Obx(
            () => PasswordTextField(
              hint: "Password",
              onChanged: (value) => controller.password.value = value,
              isPasswordVisible: controller.isPasswordVisible.value,
              onToggleVisibility: controller.togglePasswordVisibility,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => PasswordTextField(
              hint: "Confirm Password",
              onChanged: (value) => controller.confirmPassword.value = value,
              isPasswordVisible: controller.isConfirmPasswordVisible.value,
              onToggleVisibility: controller.toggleConfirmPasswordVisibility,
            ),
          ),
          ErrorMessage(errorMessage: controller.errorMessage),
        ],
      ),
    );
  }
}

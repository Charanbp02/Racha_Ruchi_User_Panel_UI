import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Auth/controller/login_controller.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_header.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_text_field.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_button.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/social_login_button.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_divider.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/auth_link.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/error_message.dart';
import 'package:racharuchi/App/Modules/Auth/widgets/remember_me_checkbox.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: Get.height - Get.mediaQuery.padding.top,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),
                  _buildAppHeader(),
                  const SizedBox(height: 40),
                  AuthHeader(
                    title: "Welcome back!",
                    subtitle: "Sign in to continue your culinary journey",
                  ),
                  const SizedBox(height: 32),
                  _buildLoginForm(controller),
                  const SizedBox(height: 20),
                  _buildLoginOptions(controller),
                  const SizedBox(height: 28),
                  AuthButton(
                    text: "Sign in",
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.validateAndLogin,
                    isLoading: controller.isLoading.value,
                  ),
                  const SizedBox(height: 24),
                  const AuthDivider(),
                  const SizedBox(height: 24),
                  _buildSocialLogin(controller),
                  const Spacer(flex: 1),
                  AuthLink(
                    question: "Don't have an account? ",
                    actionText: "Sign up",
                    onTap: controller.signUp,
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

  Widget _buildAppHeader() {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE53935), Color(0xFFC62828)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53935).withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "RC",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Racha Ruchi",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Taste the Tradition",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginController controller) {
    return Column(
      children: [
        AuthTextField(
          hint: "Email address",
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => controller.email.value = value,
        ),
        const SizedBox(height: 16),
        Obx(
          () => PasswordTextField(
            hint: "Password",
            onChanged: (value) => controller.password.value = value,
            isPasswordVisible: controller.isPasswordVisible.value,
            onToggleVisibility: controller.togglePasswordVisibility,
          ),
        ),
        ErrorMessage(errorMessage: controller.errorMessage),
      ],
    );
  }

  Widget _buildLoginOptions(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RememberMeCheckbox(
          isChecked: controller.rememberMe,
          onTap: controller.toggleRememberMe,
        ),
        TextButton(
          onPressed: controller.forgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Forgot password?",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE53935),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin(LoginController controller) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            label: "Continue with Google",
            onTap: controller.continueWithGoogle,
            customIcon: Image.network(
              "https://www.google.com/favicon.ico",
              width: 35,
              height: 35,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Iconsax.chrome, size: 35);
              },
            ),
          ),
        ),
      ],
    );
  }
}

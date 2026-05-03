import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Auth/controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height - Get.mediaQuery.padding.top,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(flex: 1),

                    // Logo and Brand Name
                    _buildLogoSection(),

                    const SizedBox(height: 40),

                    // Welcome Text
                    _buildWelcomeSection(),

                    const SizedBox(height: 32),

                    // Login Form
                    _buildLoginForm(controller),

                    const SizedBox(height: 16),

                    // Forgot Password
                    _buildForgotPassword(controller),

                    const SizedBox(height: 24),

                    // Login Button
                    _buildLoginButton(controller),

                    const SizedBox(height: 24),

                    // Divider with OR
                    _buildOrDivider(),

                    const SizedBox(height: 24),

                    // Social Login Buttons
                    _buildSocialLoginButtons(controller),

                    const Spacer(flex: 1),

                    // Sign Up Link
                    _buildSignUpLink(controller),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "RC",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Racha Ruchi",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Taste the Tradition",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D2D2D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to continue your culinary journey",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginController controller) {
    return Column(
      children: [
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

  Widget _buildForgotPassword(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me
        Obx(
          () => Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (_) => controller.toggleRememberMe(),
                  activeColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Remember Me",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        // Forgot Password
        TextButton(
          onPressed: () => controller.forgotPassword(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
          ),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE53935),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () => controller.validateAndLogin(),
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
                    "Sign In",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLoginButtons(LoginController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            icon: Iconsax.chrome,
            label: "Google",
            color: Colors.white,
            textColor: Colors.black87,
            borderColor: Colors.grey.shade300,
            onTap: () => controller.continueWithGoogle(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            icon: Iconsax.people,
            label: "Facebook",
            color: Colors.blue.shade700,
            textColor: Colors.white,
            borderColor: Colors.blue.shade700,
            onTap: () => controller.continueWithFacebook(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            icon: Iconsax.mobile,
            label: "Apple",
            color: Colors.black,
            textColor: Colors.white,
            borderColor: Colors.black,
            onTap: () => controller.continueWithApple(),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpLink(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        GestureDetector(
          onTap: () => controller.signUp(),
          child: const Text(
            "Sign Up",
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

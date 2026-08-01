import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final Widget? customIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const SocialLoginButton({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    this.customIcon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade50,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom icon or default icon
            customIcon ??
                Icon(
                  icon ?? Iconsax.chrome,
                  size: 20,
                  color: textColor ?? Colors.grey.shade700,
                ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.grey.shade700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Google-specific button widget
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleLoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      label: "Google",
      onTap: onTap,
      customIcon: _buildGoogleIcon(),
      backgroundColor: Colors.white,
      textColor: Colors.grey.shade700,
      borderColor: Colors.grey.shade200,
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Image.network(
        'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
        errorBuilder: (context, error, stackTrace) {
          // Fallback icon if image fails to load
          return const Icon(Iconsax.chrome, size: 20, color: Colors.grey);
        },
      ),
    );
  }
}

// Facebook-specific button widget
class FacebookLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const FacebookLoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      label: "Facebook",
      onTap: onTap,
      customIcon: _buildFacebookIcon(),
      backgroundColor: Colors.white,
      textColor: Colors.grey.shade700,
      borderColor: Colors.grey.shade200,
    );
  }

  Widget _buildFacebookIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

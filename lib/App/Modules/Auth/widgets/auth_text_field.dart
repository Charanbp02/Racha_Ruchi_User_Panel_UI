import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String) onChanged;
  final String? errorText;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: errorText != null ? Colors.red.shade400 : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          prefixIcon: Icon(
            prefixIcon,
            size: 22,
            color: const Color(0xFFE53935),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorText: errorText,
          errorStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;
  final String? errorText;

  const PasswordTextField({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      hint: hint,
      prefixIcon: Iconsax.lock,
      obscureText: !isPasswordVisible,
      onChanged: onChanged,
      errorText: errorText,
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Iconsax.eye_slash : Iconsax.eye,
          color: Colors.grey.shade500,
          size: 20,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }
}

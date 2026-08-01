import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? hintText;
  final String? helperText;
  final bool isRequired;
  final bool isPassword;
  final bool isEmail;
  final bool isPhone;
  final bool isSearch;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final FocusNode? focusNode;
  final int? maxLength;
  final Color? fillColor;
  final EdgeInsets? contentPadding;

  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.hintText,
    this.helperText,
    this.isRequired = false,
    this.isPassword = false,
    this.isEmail = false,
    this.isPhone = false,
    this.isSearch = false,
    this.isReadOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autoFocus = false,
    this.focusNode,
    this.maxLength,
    this.fillColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFFE53935);

    // Determine keyboard type based on flags
    TextInputType getKeyboardType() {
      if (isEmail) return TextInputType.emailAddress;
      if (isPhone) return TextInputType.phone;
      if (keyboardType != null) return keyboardType!;
      return TextInputType.text;
    }

    // Determine input formatters based on flags
    List<TextInputFormatter>? getInputFormatters() {
      if (isEmail) {
        return [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          LengthLimitingTextInputFormatter(100),
        ];
      }
      if (isPhone) {
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
      }
      return inputFormatters;
    }

    // Build validator
    String? Function(String?)? getValidator() {
      if (validator != null) return validator;

      if (isRequired) {
        return (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          if (isEmail) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email address';
            }
          }
          if (isPhone) {
            if (value.length != 10) {
              return 'Enter a valid 10-digit phone number';
            }
          }
          return null;
        };
      }

      if (isEmail) {
        return (value) {
          if (value != null && value.isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email address';
            }
          }
          return null;
        };
      }

      return null;
    }

    // Build suffix icon
    Widget? getSuffixIcon() {
      if (isPassword) {
        return IconButton(
          icon: Icon(Iconsax.eye_slash, size: 18, color: Colors.grey.shade400),
          onPressed: () {
            // Toggle password visibility
            // You can implement this with a stateful wrapper
          },
        );
      }
      if (isSearch) {
        return IconButton(
          icon: Icon(
            Iconsax.close_circle,
            size: 18,
            color: Colors.grey.shade400,
          ),
          onPressed: () {
            controller.clear();
            if (onChanged != null) onChanged!('');
          },
        );
      }
      return null;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                focusNode?.hasFocus == true
                    ? primaryColor.withValues(alpha: 0.08)
                    : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: getKeyboardType(),
        inputFormatters: getInputFormatters() ?? inputFormatters,
        validator: getValidator(),
        maxLines: maxLines,
        obscureText: isPassword,
        readOnly: isReadOnly,
        onTap: onTap,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        textInputAction: textInputAction ?? TextInputAction.next,
        autofocus: autoFocus,
        maxLength: maxLength,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFFE53935),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          helperText: helperText,
          helperStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            margin: const EdgeInsets.only(right: 4),
            child: Icon(
              icon,
              color:
                  focusNode?.hasFocus == true
                      ? primaryColor
                      : Colors.grey.shade500,
              size: 20,
            ),
          ),
          suffixIcon: getSuffixIcon(),
          filled: true,
          fillColor:
              fillColor ?? (isReadOnly ? Colors.grey.shade50 : Colors.white),
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: maxLength != null ? null : '',
        ),
        buildCounter: (
          context, {
          required currentLength,
          required isFocused,
          required maxLength,
        }) {
          if (maxLength == null) return null;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color:
                  currentLength > maxLength * 0.8
                      ? (currentLength > maxLength * 0.9
                          ? Colors.red.shade100
                          : Colors.orange.shade100)
                      : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$currentLength/$maxLength',
              style: TextStyle(
                fontSize: 10,
                color:
                    currentLength > maxLength * 0.8
                        ? (currentLength > maxLength * 0.9
                            ? Colors.red.shade700
                            : Colors.orange.shade700)
                        : Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Utility version with simplified API
class SimpleFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isRequired;
  final bool isPhone;
  final bool isEmail;
  final bool isPassword;
  final int maxLines;
  final String? hintText;
  final String? Function(String?)? validator;

  const SimpleFormTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isRequired = false,
    this.isPhone = false,
    this.isEmail = false,
    this.isPassword = false,
    this.maxLines = 1,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      controller: controller,
      label: label,
      icon: icon,
      isRequired: isRequired,
      isPhone: isPhone,
      isEmail: isEmail,
      isPassword: isPassword,
      maxLines: maxLines,
      hintText: hintText,
      validator: validator,
    );
  }
}

// Example usage with different field types
class FormTextFieldExample extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  FormTextFieldExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Name field
            FormTextField(
              controller: nameController,
              label: 'Full Name',
              icon: Iconsax.user,
              isRequired: true,
              hintText: 'Enter your full name',
            ),
            const SizedBox(height: 16),

            // Email field
            FormTextField(
              controller: emailController,
              label: 'Email',
              icon: Iconsax.sms,
              isEmail: true,
              isRequired: true,
              hintText: 'Enter your email address',
            ),
            const SizedBox(height: 16),

            // Phone field
            FormTextField(
              controller: phoneController,
              label: 'Phone Number',
              icon: Iconsax.call,
              isPhone: true,
              isRequired: true,
              hintText: 'Enter 10-digit number',
            ),
            const SizedBox(height: 16),

            // Password field
            FormTextField(
              controller: passwordController,
              label: 'Password',
              icon: Iconsax.lock,
              isPassword: true,
              isRequired: true,
              hintText: 'Enter your password',
            ),
            const SizedBox(height: 16),

            // Address field with multiple lines
            FormTextField(
              controller: addressController,
              label: 'Address',
              icon: Iconsax.building,
              maxLines: 3,
              hintText: 'Enter your full address',
            ),
          ],
        ),
      ),
    );
  }
}

// lib/App/Modules/Upload/widgets/text_input_field.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool showCounter;
  final String? initialValue;

  const TextInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.maxLines = 1,
    this.maxLength = 100,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.showCounter = false,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Create controller if not provided and initialValue is set
    final textController =
        controller ??
        (initialValue != null
            ? TextEditingController(text: initialValue)
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with count
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            if (showCounter && textController != null)
              _buildCharacterCounter(textController),
          ],
        ),
        const SizedBox(height: 8),
        _buildTextField(textController),
      ],
    );
  }

  Widget _buildTextField(TextEditingController? textController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          onChanged(value);
        },
        maxLines: maxLines,
        maxLength: maxLength,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          height: maxLines > 1 ? 1.5 : 1.0,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          counterText: '', // Hide default counter
        ),
      ),
    );
  }

  Widget _buildCharacterCounter(TextEditingController controller) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final length = value.text.length;
        final isNearLimit = length >= maxLength * 0.8;
        final isAtLimit = length >= maxLength;

        return Text(
          '$length/$maxLength',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isNearLimit ? FontWeight.w600 : FontWeight.normal,
            color:
                isAtLimit
                    ? const Color(0xFFE53935)
                    : isNearLimit
                    ? Colors.orange.shade600
                    : Colors.grey.shade400,
          ),
        );
      },
    );
  }
}

// Alternative: With character counter (simpler version)
class SimpleTextInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const SimpleTextInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.maxLines = 1,
    this.maxLength = 100,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: maxLines,
            maxLength: maxLength,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: maxLines > 1 ? 1.5 : 1.0,
            ),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}

// Alternative: With error validation
class ValidatedTextInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final String? errorText;
  final bool isRequired;
  final TextEditingController? controller;
  final String? initialValue;

  const ValidatedTextInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.maxLines = 1,
    this.maxLength = 100,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.isRequired = false,
    this.controller,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Create controller if not provided and initialValue is set
    final textController =
        controller ??
        (initialValue != null
            ? TextEditingController(text: initialValue)
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFFE53935),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  errorText != null
                      ? const Color(0xFFE53935)
                      : Colors.grey.shade200,
              width: errorText != null ? 2 : 1.5,
            ),
          ),
          child: TextField(
            controller: textController,
            onChanged: onChanged,
            maxLines: maxLines,
            maxLength: maxLength,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: maxLines > 1 ? 1.5 : 1.0,
            ),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              counterText: '',
              suffixIcon:
                  errorText != null
                      ? Icon(
                        Icons.error_outline_rounded,
                        color: const Color(0xFFE53935),
                        size: 20,
                      )
                      : null,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFFE53935),
            ),
          ),
        ],
      ],
    );
  }
}

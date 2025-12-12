// filepath: /Users/marcelocesar/Desktop/t4g_dashboard/lib/src/components/custom_text_field.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';

/// A reusable custom text field component with consistent styling
class CustomTextField extends StatelessWidget {
  /// The label text to display above the text field
  final String label;

  /// The hint text to display inside the text field
  final String? hintText;

  /// Callback function when the text field value changes
  final Function(String) onChanged;

  /// Whether to obscure the text (for password fields)
  final bool obscureText;

  /// Optional suffix icon widget
  final Widget? suffixIcon;

  /// Optional prefix icon widget
  final Widget? prefixIcon;

  /// Keyboard type for the text field
  final TextInputType keyboardType;

  /// Text controller for the field
  final TextEditingController? controller;

  /// Constructor for the custom text field
  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColorTertiary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.grey.shade200),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

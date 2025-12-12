// core/widgets/modern_text_field.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';

class ModernTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final bool isRequired;
  final FocusNode? focusNode;
  final bool isFocused;
  final Color? borderColor;
  final Color? labelColor;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final String? errorText;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;

  const ModernTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.isRequired = false,
    this.focusNode,
    this.isFocused = false,
    this.borderColor,
    this.labelColor,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.errorText,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.onTap,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ??
        (isFocused ? AppColors.primaryLight : AppColors.lightBorder);
    final effectiveLabelColor =
        labelColor ??
        (isFocused ? AppColors.primaryLight : AppColors.lightTextSecondary);

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: effectiveLabelColor,
              ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.primary),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText != null ? Colors.red : effectiveBorderColor,
                width: isFocused ? 2 : 1,
              ),
              boxShadow:
                  isFocused
                      ? [
                        BoxShadow(
                          color: AppColors.blueGradientStart.withValues(
                            alpha: 0.1,
                          ),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              enabled: enabled,
              readOnly: readOnly,
              textAlign: textAlign,
              textCapitalization: textCapitalization,
              autocorrect: autocorrect,
              enableSuggestions: enableSuggestions,
              style: const TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.lightTextSecondary,
                  fontSize: 16,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: InputBorder.none,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                counterText: maxLength != null ? null : '',
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

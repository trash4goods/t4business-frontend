// lib/core/components/profile/compact_form_field.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';

class CompactFormField extends StatelessWidget {
  final String label;
  final String? value;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool readOnly;
  final bool required;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const CompactFormField({
    super.key,
    required this.label,
    this.value,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.readOnly = false,
    this.required = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compact label
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 2),
              Text(
                '*',
                style: TextStyle(color: AppColors.destructive, fontSize: 12),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        // Compact input
        Container(
          height: 40,
          decoration: BoxDecoration(
            color:
                readOnly
                    ? AppColors.surfaceContainer.withOpacity(0.3)
                    : AppColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.fieldBorder.withOpacity(0.6)),
          ),
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            style: AppTextStyles.bodySmall,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon:
                  prefixIcon != null
                      ? Icon(
                        prefixIcon,
                        size: 16,
                        color: AppColors.textSecondary,
                      )
                      : null,
              suffix: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

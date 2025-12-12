import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class FormFieldComponent extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;
  final String? helpText;

  const FormFieldComponent({
    super.key,
    required this.label,
    this.required = false,
    required this.child,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        SizedBox(height: 6),
        child,
        if (helpText != null) ...[
          SizedBox(height: 4),
          Text(
            helpText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

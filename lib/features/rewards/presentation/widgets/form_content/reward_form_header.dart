import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/app/themes/app_text_styles.dart';

class RewardViewFormHeader extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;
  final Future<void> Function() onCreate;

  const RewardViewFormHeader({
    super.key,
    required this.isEditing,
    required this.isLoading,
    required this.isFormValid,
    required this.onBack,
    required this.onCancel,
    required this.onSave,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        // border: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        children: [
          ShadButton.ghost(
            onPressed: onBack,
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Reward' : 'Create Reward',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Create rewards that users can unlock by completing recycling rules',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              ShadButton.outline(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ShadButton(
                enabled: isFormValid && !isLoading,
                onPressed: isFormValid && !isLoading ? isEditing ? () async => await onSave() : () async => await onCreate() : null,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Update Reward' : 'Create Reward'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

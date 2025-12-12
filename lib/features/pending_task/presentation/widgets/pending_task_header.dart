import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class PendingTaskHeader extends StatelessWidget {
  final bool isMobile;

  const PendingTaskHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      color: AppColors.surface,

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.task_alt,
              size: isMobile ? 20 : 24,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Tasks',
                  style:
                      isMobile
                          ? AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          )
                          : AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                ),
                if (!isMobile) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Complete the required tasks to continue',
                    style: AppTextStyles.muted,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

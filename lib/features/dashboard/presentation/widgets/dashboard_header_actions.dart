import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class DashboardHeaderActions extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onRefresh;
  final VoidCallback onDownloadReport;
  final VoidCallback onShowDateRangePicker;
  final RxString selectedDateRangeText;

  const DashboardHeaderActions({
    super.key,
    required this.isDesktop,
    required this.onRefresh,
    required this.onDownloadReport,
    required this.onShowDateRangePicker,
    required this.selectedDateRangeText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Refresh
        ShadButton.outline(
          onPressed: onRefresh,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh_outlined, size: 16, color: AppColors.primary),
              if (isDesktop) ...[
                const SizedBox(width: 6),
                Text(
                  'Refresh',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Download Report
        ShadButton.outline(
          onPressed: onDownloadReport,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download_outlined, size: 16, color: AppColors.primary),
              if (isDesktop) ...[
                const SizedBox(width: 6),
                Text(
                  'Download Report',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: 12),
          Obx(
            () => ShadButton.outline(
              onPressed: onShowDateRangePicker,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedDateRangeText.value,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

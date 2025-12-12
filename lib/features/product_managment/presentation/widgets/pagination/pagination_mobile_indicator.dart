import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Mobile page indicator showing "Page X of Y"
class PaginationMobileIndicator extends StatelessWidget {
  final int safeCurrentPage;
  final int totalPages;
  final VoidCallback? onPageJumpRequested;

  const PaginationMobileIndicator({
    super.key,
    required this.safeCurrentPage,
    required this.totalPages,
    this.onPageJumpRequested,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPageJumpRequested,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(6),
          color: AppColors.surfaceColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Page $safeCurrentPage of $totalPages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (onPageJumpRequested != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.edit_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
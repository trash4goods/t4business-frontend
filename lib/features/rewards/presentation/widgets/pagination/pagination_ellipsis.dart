import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Ellipsis indicator for pagination (shows "..." between page numbers)
class RewardsViewPaginationEllipsis extends StatelessWidget {
  const RewardsViewPaginationEllipsis({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      child: Text(
        '...',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
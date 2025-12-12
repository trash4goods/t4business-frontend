import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Individual page number button for pagination
class PaginationPageButton extends StatelessWidget {
  final int page;
  final int safeCurrentPage;
  final bool isLoading;
  final Function(int page) onPageChanged;

  const PaginationPageButton({
    super.key,
    required this.page,
    required this.safeCurrentPage,
    required this.isLoading,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = page == safeCurrentPage;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 36,
      constraints: const BoxConstraints(minWidth: 36),
      decoration: BoxDecoration(
        color: isActive 
          ? AppColors.primary 
          : AppColors.surfaceColor,
        border: Border.all(
          color: isActive 
            ? AppColors.primary 
            : AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () => onPageChanged(page),
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
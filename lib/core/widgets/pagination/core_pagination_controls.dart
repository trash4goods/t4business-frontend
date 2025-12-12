import 'package:flutter/material.dart';
import 'core_pagination_nav_button.dart';
import 'core_pagination_mobile_indicator.dart';
import 'core_pagination_page_numbers.dart';

/// Main pagination controls (Previous, page numbers, Next)
class CorePaginationControls extends StatelessWidget {
  final bool isMobile;
  final int safeCurrentPage;
  final bool isLoading;
  final bool hasNext;
  final int currentPage;
  final Function(int page) onPageChanged;
  final VoidCallback? onPageJumpRequested;
  final int totalPages;

  const CorePaginationControls({
    super.key,
    required this.isMobile,
    required this.safeCurrentPage,
    required this.isLoading,
    required this.hasNext,
    required this.currentPage,
    required this.onPageChanged,
    this.onPageJumpRequested,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        CorePaginationNavButton(
          onPressed: (safeCurrentPage > 1 && !isLoading) 
            ? () => onPageChanged(safeCurrentPage - 1) 
            : null,
          icon: Icons.chevron_left,
          label: isMobile ? null : 'Previous',
        ),
        
        const SizedBox(width: 8),
        
        // Page numbers or mobile indicator
        if (isMobile) ...[
          CorePaginationMobileIndicator(
            safeCurrentPage: safeCurrentPage,
            totalPages: totalPages,
            onPageJumpRequested: onPageJumpRequested,
          ),
        ] else ...[
          CorePaginationPageNumbers(
            totalPages: totalPages,
            currentPage: currentPage,
            isLoading: isLoading,
            onPageChanged: onPageChanged,
          ),
        ],
        
        const SizedBox(width: 8),
        
        // Next button
        CorePaginationNavButton(
          onPressed: (hasNext && !isLoading) 
            ? () => onPageChanged(currentPage + 1) 
            : null,
          icon: Icons.chevron_right,
          label: isMobile ? null : 'Next',
          iconRight: true,
        ),
      ],
    );
  }
}
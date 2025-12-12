import 'package:flutter/material.dart';
import 'pagination_nav_button.dart';
import 'pagination_mobile_indicator.dart';
import 'pagination_page_numbers.dart';

/// Main pagination controls (Previous, page numbers, Next)
class PaginationControls extends StatelessWidget {
  final bool isMobile;
  final int safeCurrentPage;
  final bool isLoading;
  final bool hasNext;
  final int currentPage;
  final Function(int page) onPageChanged;
  final VoidCallback? onPageJumpRequested;
  final int totalPages;

  const PaginationControls({
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
        PaginationNavButton(
          onPressed: (safeCurrentPage > 1 && !isLoading) 
            ? () => onPageChanged(safeCurrentPage - 1) 
            : null,
          icon: Icons.chevron_left,
          label: isMobile ? null : 'Previous',
        ),
        
        const SizedBox(width: 8),
        
        // Page numbers or mobile indicator
        if (isMobile) ...[
          PaginationMobileIndicator(
            safeCurrentPage: safeCurrentPage,
            totalPages: totalPages,
            onPageJumpRequested: onPageJumpRequested,
          ),
        ] else ...[
          PaginationPageNumbers(
            totalPages: totalPages,
            currentPage: currentPage,
            isLoading: isLoading,
            onPageChanged: onPageChanged,
          ),
        ],
        
        const SizedBox(width: 8),
        
        // Next button
        PaginationNavButton(
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
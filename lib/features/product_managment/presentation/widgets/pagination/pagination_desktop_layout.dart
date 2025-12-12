import 'package:flutter/material.dart';
import 'pagination_results_info.dart';
import 'pagination_controls.dart';

/// Desktop layout for pagination (horizontal with results info on left)
class PaginationDesktopLayout extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int perPage;
  final int safeCurrentPage;
  final bool isLoading;
  final bool hasNext;
  final Function(int page) onPageChanged;
  final VoidCallback? onPageJumpRequested;
  final int totalPages;

  const PaginationDesktopLayout({
    super.key,
    required this.currentPage,
    required this.totalCount,
    required this.perPage,
    required this.safeCurrentPage,
    required this.isLoading,
    required this.hasNext,
    required this.onPageChanged,
    this.onPageJumpRequested,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side: Results info
        Expanded(
          child: PaginationResultsInfo(
            currentPage: currentPage,
            totalCount: totalCount,
            perPage: perPage,
            safeCurrentPage: safeCurrentPage,
          ),
        ),
        
        // Right side: Pagination controls
        PaginationControls(
          isMobile: false,
          safeCurrentPage: safeCurrentPage,
          isLoading: isLoading,
          hasNext: hasNext,
          currentPage: currentPage,
          onPageChanged: onPageChanged,
          onPageJumpRequested: onPageJumpRequested,
          totalPages: totalPages,
        ),
      ],
    );
  }
}
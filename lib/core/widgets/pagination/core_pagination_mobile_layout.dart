import 'package:flutter/material.dart';
import 'core_pagination_results_info.dart';
import 'core_pagination_controls.dart';

/// Mobile layout for pagination (vertical with results info on top)
class CorePaginationMobileLayout extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int perPage;
  final int safeCurrentPage;
  final bool isLoading;
  final bool hasNext;
  final Function(int page) onPageChanged;
  final VoidCallback? onPageJumpRequested;
  final int totalPages;

  const CorePaginationMobileLayout({
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CorePaginationResultsInfo(
          currentPage: currentPage,
          totalCount: totalCount,
          perPage: perPage,
          safeCurrentPage: safeCurrentPage,
        ),
        const SizedBox(height: 12),
        CorePaginationControls(
          isMobile: true,
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
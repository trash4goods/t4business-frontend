import 'package:flutter/material.dart';
import '../../app/themes/app_colors.dart';
import '../../utils/pagination_utils.dart';
import 'core_pagination_desktop_layout.dart';
import 'core_pagination_mobile_layout.dart';

/// Core reusable pagination widget for the entire application
/// Follows GetX architecture - stateless with all state passed from parent
class CorePaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int perPage;
  final bool hasNext;
  final Function(int page) onPageChanged;
  final bool isLoading;
  final VoidCallback? onPageJumpRequested;

  const CorePaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalCount,
    required this.perPage,
    required this.hasNext,
    required this.onPageChanged,
    this.isLoading = false,
    this.onPageJumpRequested,
  });

  int get totalPages => CorePaginationUtils.calculateTotalPages(totalCount, perPage);
  bool get hasPrevious => CorePaginationUtils.hasPrevious(currentPage);
  int get safeCurrentPage => CorePaginationUtils.getSafeCurrentPage(currentPage, totalPages);

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) return const SizedBox.shrink();
    
    // Early return if pagination state is inconsistent
    if (totalPages < 1) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: isMobile 
        ? CorePaginationMobileLayout(
            currentPage: currentPage,
            totalCount: totalCount,
            perPage: perPage,
            safeCurrentPage: safeCurrentPage,
            isLoading: isLoading,
            hasNext: hasNext,
            onPageChanged: onPageChanged,
            onPageJumpRequested: onPageJumpRequested,
            totalPages: totalPages,
          )
        : CorePaginationDesktopLayout(
            currentPage: currentPage,
            totalCount: totalCount,
            perPage: perPage,
            safeCurrentPage: safeCurrentPage,
            isLoading: isLoading,
            hasNext: hasNext,
            onPageChanged: onPageChanged,
            onPageJumpRequested: onPageJumpRequested,
            totalPages: totalPages,
          ),
    );
  }
}
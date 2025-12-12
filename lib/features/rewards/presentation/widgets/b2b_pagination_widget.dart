import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../product_managment/utils/pagination_utils.dart';
import 'pagination/pagination_desktop_layout.dart';
import 'pagination/pagination_mobile_layout.dart';

/// Professional B2B Pagination Widget (Stateless)
/// Follows GetX architecture - receives all functions/values from parent
/// Uses separate component widgets for better maintainability
class RewardsViewPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int perPage;
  final bool hasNext;
  final Function(int page) onPageChanged;
  final bool isLoading;
  final VoidCallback? onPageJumpRequested;

  const RewardsViewPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalCount,
    required this.perPage,
    required this.hasNext,
    required this.onPageChanged,
    this.isLoading = false,
    this.onPageJumpRequested,
  });

  int get totalPages => PaginationUtils.calculateTotalPages(totalCount, perPage);
  bool get hasPrevious => PaginationUtils.hasPrevious(currentPage);
  int get safeCurrentPage => PaginationUtils.getSafeCurrentPage(currentPage, totalPages);

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
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: isMobile 
        ? RewardsViewPaginationMobileLayout(
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
        : RewardsViewPaginationDesktopLayout(
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
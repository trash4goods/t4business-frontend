import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Displays results information for pagination
/// Shows "Showing X-Y of Z results" or "No results found"
class RewardsViewPaginationResultsInfo extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final int perPage;
  final int safeCurrentPage;

  const RewardsViewPaginationResultsInfo({
    super.key,
    required this.currentPage,
    required this.totalCount,
    required this.perPage,
    required this.safeCurrentPage,
  });

  @override
  Widget build(BuildContext context) {
    final startItem = totalCount > 0 
      ? ((safeCurrentPage - 1) * perPage) + 1 
      : 0;
    final endItem = (safeCurrentPage * perPage)
      .clamp(0, totalCount);
    
    return Text(
      totalCount > 0 
        ? 'Showing $startItem–$endItem of $totalCount results'
        : 'No results found',
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
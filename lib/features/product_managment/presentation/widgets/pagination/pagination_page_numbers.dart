import 'package:flutter/material.dart';
import '../../../utils/pagination_utils.dart';

/// Builds the list of page numbers for desktop pagination
class PaginationPageNumbers extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final bool isLoading;
  final Function(int page) onPageChanged;

  const PaginationPageNumbers({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.isLoading,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: PaginationUtils.buildPageNumbersList(
        totalPages: totalPages,
        currentPage: currentPage,
        isLoading: isLoading,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
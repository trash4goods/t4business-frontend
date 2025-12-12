import 'package:flutter/material.dart';
import '../presentation/widgets/pagination/pagination_page_button.dart';
import '../presentation/widgets/pagination/pagination_ellipsis.dart';

/// Utility class for pagination calculations and widget building
class PaginationUtils {
  
  /// Calculate total pages from count and per page
  static int calculateTotalPages(int totalCount, int perPage) {
    return totalCount > 0 
      ? (totalCount / perPage).ceil() 
      : 1;
  }
  
  /// Check if there's a previous page
  static bool hasPrevious(int currentPage) {
    return currentPage > 1;
  }
  
  /// Get safe current page that handles edge cases
  static int getSafeCurrentPage(int currentPage, int totalPages) {
    return currentPage.clamp(1, totalPages);
  }
  
  /// Build the list of page number widgets
  static List<Widget> buildPageNumbersList({
    required int totalPages,
    required int currentPage,
    required bool isLoading,
    required Function(int page) onPageChanged,
  }) {
    List<Widget> pages = [];
    
    // Handle single page case
    if (totalPages <= 1) {
      pages.add(PaginationPageButton(
        page: 1,
        safeCurrentPage: getSafeCurrentPage(currentPage, totalPages),
        isLoading: isLoading,
        onPageChanged: onPageChanged,
      ));
      return pages;
    }
    
    // Safe current page handling
    final safePage = getSafeCurrentPage(currentPage, totalPages);
    
    // Show first page
    pages.add(PaginationPageButton(
      page: 1,
      safeCurrentPage: safePage,
      isLoading: isLoading,
      onPageChanged: onPageChanged,
    ));
    
    // Calculate range around current page with safe bounds
    int start = (safePage - 1).clamp(1, totalPages);
    int end = (safePage + 1).clamp(1, totalPages);
    
    // Ensure start is at least 2 and end is at most totalPages - 1
    // Only if totalPages > 2
    if (totalPages > 2) {
      start = start.clamp(2, totalPages - 1);
      end = end.clamp(2, totalPages - 1);
      
      // Adjust range for better UX
      if (safePage <= 3 && totalPages > 4) {
        end = 4.clamp(2, totalPages - 1);
      } else if (safePage >= totalPages - 2 && totalPages > 4) {
        start = (totalPages - 3).clamp(2, totalPages - 1);
      }
      
      // Add ellipsis if needed
      if (start > 2) {
        pages.add(const PaginationEllipsis());
      }
      
      // Add middle pages
      for (int i = start; i <= end; i++) {
        if (i > 1 && i < totalPages) {
          pages.add(PaginationPageButton(
            page: i,
            safeCurrentPage: safePage,
            isLoading: isLoading,
            onPageChanged: onPageChanged,
          ));
        }
      }
      
      // Add ellipsis if needed
      if (end < totalPages - 1) {
        pages.add(const PaginationEllipsis());
      }
    }
    
    // Show last page (only if different from first page)
    if (totalPages > 1) {
      pages.add(PaginationPageButton(
        page: totalPages,
        safeCurrentPage: safePage,
        isLoading: isLoading,
        onPageChanged: onPageChanged,
      ));
    }
    
    return pages;
  }
}
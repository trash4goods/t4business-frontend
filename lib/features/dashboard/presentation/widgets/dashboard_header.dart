import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/constants.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import 'dashboard_header_actions.dart';

class DashboardHeader extends StatelessWidget {
  final BoxConstraints constraints;
  final RxString selectedDateRangeText;
  final VoidCallback onRefresh;
  final VoidCallback onDownloadReport;
  final VoidCallback onShowDateRangePicker;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DashboardHeader({
    super.key,
    required this.constraints,
    required this.selectedDateRangeText,
    required this.onRefresh,
    required this.onDownloadReport,
    required this.onShowDateRangePicker,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 20),
                onPressed: scaffoldKey.currentState?.openDrawer ?? () => log('the scaffold key is null: ${scaffoldKey.currentState}'),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.foreground,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: isDesktop
                      ? AppTextStyles.h3green
                      : AppTextStyles.h4green,
                ),
              ],
            ),
          ),
          DashboardHeaderActions(
            isDesktop: isDesktop,
            onRefresh: onRefresh,
            onDownloadReport: onDownloadReport,
            onShowDateRangePicker: onShowDateRangePicker,
            selectedDateRangeText: selectedDateRangeText,
          ),
        ],
      ),
    );
  }
}

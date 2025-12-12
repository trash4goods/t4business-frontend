import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import 'dashboard_header.dart';
import 'dashboard_error_state.dart';

class DashboardContent extends StatelessWidget {
  final BoxConstraints constraints;
  final RxString selectedDateRangeText;
  final VoidCallback onRefresh;
  final VoidCallback onDownloadReport;
  final VoidCallback onShowDateRangePicker;
  final bool Function() isLoading;
  final String? Function() error;
  final VoidCallback onRetry;
  final Widget Function(BuildContext, BoxConstraints) buildMainContent;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DashboardContent({
    super.key,
    required this.constraints,
    required this.selectedDateRangeText,
    required this.onRefresh,
    required this.onDownloadReport,
    required this.onShowDateRangePicker,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    required this.buildMainContent,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardHeader(
          constraints: constraints,
          selectedDateRangeText: selectedDateRangeText,
          onRefresh: onRefresh,
          onDownloadReport: onDownloadReport,
          onShowDateRangePicker: onShowDateRangePicker,
          scaffoldKey: scaffoldKey,
        ),
        Expanded(
          child: Obx(() {
            if (isLoading()) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              );
            }

            final err = error();
            if (err != null) {
              return DashboardErrorState(
                message: err,
                onRetry: onRetry,
              );
            }

            return buildMainContent(context, constraints);
          }),
        ),
      ],
    );
  }
}

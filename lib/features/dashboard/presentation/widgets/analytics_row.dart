import 'package:flutter/material.dart';
import '../../../../core/app/constants.dart';
import '../../../auth/data/models/user_auth/user_auth_model.dart';
import 'trend_chart.dart';
import 'top_performers.dart';

class AnalyticsRow extends StatelessWidget {
  final BoxConstraints constraints;
  final VoidCallback onViewAllTopPerformers;
  final UserAuthModel? user;

  const AnalyticsRow({
    super.key,
    required this.constraints,
    required this.onViewAllTopPerformers,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return isDesktop
        ? Row(
          children: [
            Expanded(flex: 2, child: TrendChart(user: user)),
            const SizedBox(width: 24),
            Expanded(child: TopPerformers(onViewAll: onViewAllTopPerformers)),
          ],
        )
        : Column(
          children: [
            TrendChart(user: user),
            const SizedBox(height: 24),
            TopPerformers(onViewAll: onViewAllTopPerformers),
          ],
        );
  }
}

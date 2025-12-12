import 'package:flutter/material.dart';
import '../../../../core/app/constants.dart';

class ActivityAndActions extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget recentActivityFeed;
  final Widget quickActions;

  const ActivityAndActions({
    super.key,
    required this.constraints,
    required this.recentActivityFeed,
    required this.quickActions,
  });

  bool get isDesktop => constraints.maxWidth > AppConstants.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return isDesktop
        ? Row(
            children: [
              Expanded(flex: 2, child: recentActivityFeed),
              const SizedBox(width: 24),
              Expanded(child: quickActions),
            ],
          )
        : Column(
            children: [
              recentActivityFeed,
              const SizedBox(height: 24),
              quickActions,
            ],
          );
  }
}

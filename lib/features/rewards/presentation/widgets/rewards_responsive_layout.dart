import 'package:flutter/material.dart';

import '../presenters/interface/rewards_presenter.interface.dart';
import 'rewards_desktop_layout.dart';
import 'rewards_mobile_layout.dart';
import 'rewards_tablet_layout.dart';

class RewardsViewResponsiveLayout extends StatelessWidget {
  final BoxConstraints constraints;
  final bool isMobile;
  final bool isTablet;
  final RewardsPresenterInterface presenter;
  final Widget Function() buildFormContent;
  final Widget Function() buildPreviewPanel;
  final Widget Function() buildRewardsList;

  const RewardsViewResponsiveLayout({
    super.key,
    required this.constraints,
    required this.isMobile,
    required this.isTablet,
    required this.presenter,
    required this.buildFormContent,
    required this.buildPreviewPanel,
    required this.buildRewardsList,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return RewardsViewMobileLayout(
        presenter: presenter,
        buildFormContent: buildFormContent,
        buildPreviewPanel: buildPreviewPanel,
        buildRewardsList: buildRewardsList,
      );
    } else if (isTablet) {
      return RewardsViewTabletLayout(
        presenter: presenter,
        buildFormContent: buildFormContent,
        buildPreviewPanel: buildPreviewPanel,
        buildRewardsList: buildRewardsList,
      );
    } else {
      return RewardsViewDesktopLayout(
        presenter: presenter,
        buildFormContent: buildFormContent,
        buildPreviewPanel: buildPreviewPanel,
        buildRewardsList: buildRewardsList,
      );
    }
  }
}

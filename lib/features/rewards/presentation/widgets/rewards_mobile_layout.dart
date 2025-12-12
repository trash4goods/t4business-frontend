import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../presenters/interface/rewards_presenter.interface.dart';

class RewardsViewMobileLayout extends StatelessWidget {
  final RewardsPresenterInterface presenter;
  final Widget Function() buildFormContent;
  final Widget Function() buildPreviewPanel;
  final Widget Function() buildRewardsList;

  const RewardsViewMobileLayout({
    super.key,
    required this.presenter,
    required this.buildFormContent,
    required this.buildPreviewPanel,
    required this.buildRewardsList,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (presenter.isCreating) {
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const ShadCard(
                padding: EdgeInsets.zero,
                child: TabBar(
                  tabs: [Tab(text: 'Form'), Tab(text: 'Preview')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [buildFormContent(), buildPreviewPanel()],
                ),
              ),
            ],
          ),
        );
      } else {
        return buildRewardsList();
      }
    });
  }
}

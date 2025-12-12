import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presenters/interface/rewards_presenter.interface.dart';

class RewardsViewTabletLayout extends StatelessWidget {
  final RewardsPresenterInterface presenter;
  final Widget Function() buildFormContent;
  final Widget Function() buildPreviewPanel;
  final Widget Function() buildRewardsList;

  const RewardsViewTabletLayout({
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
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: buildFormContent(),
            ),
            Container(
              height: 320,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: buildPreviewPanel(),
            ),
          ],
        );
      } else {
        return buildRewardsList();
      }
    });
  }
}

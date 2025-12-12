import 'package:flutter/material.dart';
import '../../../../../rules/data/models/rule.dart';
import 'mobile_device_frame.dart';
import 'mobile_preview_content.dart';

class RewardViewMobilePreview extends StatelessWidget {
  final String title;
  final String description;
  final String headerImage;
  final List<String> carouselImages;
  final String logo;
  final List<String> categories;
  final List<RuleModel> linkedRules;
  final bool canCheckout;
  final int quantity;
  final DateTime? expiryDate;

  const RewardViewMobilePreview({
    super.key,
    required this.title,
    required this.description,
    required this.headerImage,
    required this.carouselImages,
    required this.logo,
    required this.categories,
    required this.linkedRules,
    required this.canCheckout,
    this.quantity = 0,
    this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return  RewardsViewMobileDeviceFrame(
          child: RewardsViewMobilePreviewContent(
            title: title,
            description: description,
            headerImage: headerImage,
            carouselImages: carouselImages,
            logo: logo,
            linkedRules: linkedRules,
            categories: categories,
            quantity: quantity,
            canCheckout: canCheckout,
            expiryDate: expiryDate,
          ),
    );
  }
}

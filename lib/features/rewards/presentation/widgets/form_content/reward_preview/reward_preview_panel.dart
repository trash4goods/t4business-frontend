import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';
import '../../../../../../core/app/themes/app_text_styles.dart';
import '../../../../../rules/data/models/rule.dart';
import 'mobile_preview.dart';

class RewardViewPreviewPanel extends StatelessWidget {
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

  const RewardViewPreviewPanel({
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShadBadge(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.phone_iphone,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Preview',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Real-time mobile preview',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: RewardViewMobilePreview(
                  title: title,
                  description: description,
                  headerImage: headerImage,
                  carouselImages: carouselImages,
                  logo: logo,
                  categories: categories,
                  linkedRules: linkedRules,
                  canCheckout: canCheckout,
                  quantity: quantity,
                  expiryDate: expiryDate,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../rules/data/models/rule.dart';
import 'reward_brand_section.dart';
import 'reward_carousel_section.dart';
import 'reward_description_section.dart';
import 'reward_header_image.dart';
import 'reward_info_section.dart';
import 'reward_rules_section.dart';

class RewardsViewMobilePreviewContent extends StatelessWidget {
  final String title;
  final String description;
  final String headerImage;
  final List<String> carouselImages;
  final String logo;
  final List<RuleModel> linkedRules;
  final List<String> categories;
  final int quantity;
  final bool canCheckout;
  final DateTime? expiryDate;

  const RewardsViewMobilePreviewContent({
    super.key,
    required this.title,
    required this.description,
    required this.headerImage,
    required this.carouselImages,
    required this.logo,
    required this.linkedRules,
    required this.categories,
    this.quantity = 0,
    this.canCheckout = true,
    this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Header with brand colors (green theme)
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2E7D32), // Dark green
                Color(0xFF4CAF50), // Medium green
              ],
            ),
          ),
          child: RewardViewHeaderImage(
            headerImage: headerImage,
            carouselImages: carouselImages,
          ),
        ),

        // Content area
        DraggableScrollableSheet(
          maxChildSize: 1.0,
          minChildSize: 0.6,
          initialChildSize: 0.6,
          builder: (BuildContext context, scrollController) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // Drag Handle
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 4,
                        width: 40,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),

                  // Reward Title and Description
                  SliverToBoxAdapter(
                    child: RewardViewInfoSection(
                      title: title,
                      categories: categories,
                      canCheckout: canCheckout,
                    ),
                  ),

                  // Carousel Images Section
                  if (carouselImages.isNotEmpty)
                    SliverToBoxAdapter(
                      child: RewardViewCarouselSection(carouselImages: carouselImages),
                    ),

                  // Brand logo and stock info
                  SliverToBoxAdapter(
                    child: RewardViewBrandSection(
                      logo: logo,
                      quantity: quantity,
                      expiryDate: expiryDate,
                      canCheckout: canCheckout,
                    ),
                  ),

                  // Linked Rules Section
                  if (linkedRules.isNotEmpty)
                    SliverToBoxAdapter(
                      child: RewardViewRulesSection(linkedRules: linkedRules),
                    ),

                  // Description
                  SliverToBoxAdapter(
                    child: RewardViewDescriptionSection(description: description),
                  ),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

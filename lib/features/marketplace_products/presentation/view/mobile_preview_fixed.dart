// lib/features/rewards/presentation/components/reward_mobile_preview.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/utils/custom_colors.dart';
import '../../../rules/data/models/rule.dart';
import '../components/banner_image_component.dart';

class RewardMobilePreview extends StatelessWidget {
  final String title;
  final String description;
  final String headerImage;
  final List<String> carouselImages;
  final String logo;
  final String barcode;
  final List<String> categories;
  final List<RuleModel> linkedRules;
  final bool canCheckout;

  const RewardMobilePreview({
    super.key,
    required this.title,
    required this.description,
    required this.headerImage,
    required this.carouselImages,
    required this.logo,
    required this.barcode,
    required this.categories,
    required this.linkedRules,
    required this.canCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 540,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Status bar
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_4_bar,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Icon(Icons.battery_full, color: Colors.white, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Screen content
          Positioned(
            top: 40,
            left: 8,
            right: 8,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _buildRewardDetailsView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardDetailsView() {
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
          child: _buildHeaderContent(),
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        children: [
                          // Voucher badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF4CAF50,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  size: 16,
                                  color: const Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Voucher',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            title.isNotEmpty
                                ? title
                                : '15% Mind the Trash Discount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Carousel Images Section
                  if (carouselImages.isNotEmpty)
                    SliverToBoxAdapter(child: _buildCarouselSection()),

                  // Brand logo and stock info
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Stock indicator
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'In stock',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Brand logo
                          if (logo.isNotEmpty)
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _buildLogoImage(),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Linked Rules Section
                  if (linkedRules.isNotEmpty)
                    SliverToBoxAdapter(child: _buildLinkedRulesSection()),

                  // Description
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        description.isNotEmpty
                            ? description
                            : '15% discount on all products from the 1st Zero Waste Online Store in Portugal. Vegan, organic, and plastic-free products that promote a more conscious lifestyle. Not applicable to promotional items. Code valid until 31/12/2025.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),


      ],
    );
  }

  Widget _buildHeaderContent() {
    // Display header image instead of static text/back button
    return _buildHeaderImage();
  }

  // Builds the header image with similar behaviour to the product mobile preview
  Widget _buildHeaderImage() {
    // Start with the provided header image
    String displayImage = headerImage;

    // If no dedicated header image, use the first carousel image as fallback
    if (displayImage.isEmpty && carouselImages.isNotEmpty) {
      displayImage = carouselImages.first;
    }

    if (displayImage.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: BannerImage.buildCarouselImage(displayImage),
        ),
      );
    }

    // Fallback placeholder when no image is available
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: BannerImage(
        placeholderPath: "assets/images/default_event_picture.jpg",
        files: const [],
      ),
    );
  }

  Widget _buildCarouselSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PageView.builder(
        itemCount: carouselImages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildCarouselImage(carouselImages[index]),
          );
        },
      ),
    );
  }

  Widget _buildCarouselImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'mind the trash',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'choosing sustainability',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '15%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.white,
              size: 32,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoImage() {
    if (logo.isEmpty) {
      return const Center(
        child: Text(
          'mind\nthe\ntrash',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.1,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        logo,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.business, color: Colors.white, size: 24),
          );
        },
      ),
    );
  }

  Widget _buildLinkedRulesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.rule,
                  size: 16,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...linkedRules.map(
            (rule) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${rule.title} (${rule.recycleCount}x recycle)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: canCheckout ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
        borderRadius: BorderRadius.circular(25),
        boxShadow:
            canCheckout
                ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canCheckout ? () {} : null,
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: Text(
              canCheckout ? 'Checkout' : 'Complete Rules to Unlock',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

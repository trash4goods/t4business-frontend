import 'package:flutter/material.dart';
import 'banner_image_component.dart';

class RewardViewHeaderImage extends StatelessWidget {
  final String headerImage;
  final List<String> carouselImages;

  const RewardViewHeaderImage({
    super.key,
    required this.headerImage,
    required this.carouselImages,
  });

  @override
  Widget build(BuildContext context) {
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
          child: RewardsViewBannerImage.buildCarouselImage(displayImage),
        ),
      );
    }

    // Fallback placeholder when no image is available
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: RewardsViewBannerImage(
        placeholderPath: "assets/images/default_event_picture.jpg",
        files: const [],
      ),
    );
  }
}

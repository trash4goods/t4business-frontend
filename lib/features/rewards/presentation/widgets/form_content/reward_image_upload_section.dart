import 'package:flutter/material.dart';
import 'image_upload_component.dart';

class RewardViewHeaderImageUploadSection extends StatelessWidget {
  final String headerImage;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const RewardViewHeaderImageUploadSection({
    super.key,
    required this.headerImage,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerImage.isNotEmpty)
          SizedBox(
            height: 100,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 100,
              margin: const EdgeInsets.only(bottom: 8),
              child: RewardViewImageUploadComponent(
                imageUrl: headerImage,
                onUpload: () {},
                onRemove: onRemove,
                title: '',
                subtitle: '',
                compact: true,
                width: 100,
                height: 100,
              ),
            ),
          ),
        if (headerImage.isEmpty)
          RewardViewImageUploadComponent(
            onUpload: onUpload,
            title: 'Upload Header Image',
            subtitle: 'This will appear at the top of your reward preview',
            compact: true,
          ),
      ],
    );
  }
}

class RewardCarouselImagesUploadSection extends StatelessWidget {
  final List<String> carouselImages;
  final VoidCallback onAddImage;
  final ValueChanged<int> onRemoveAt;

  const RewardCarouselImagesUploadSection({
    super.key,
    required this.carouselImages,
    required this.onAddImage,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (carouselImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: carouselImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: RewardViewImageUploadComponent(
                    imageUrl: carouselImages[index],
                    onUpload: () {},
                    onRemove: () => onRemoveAt(index),
                    title: '',
                    subtitle: '',
                    compact: true,
                    width: 100,
                    height: 100,
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        if (carouselImages.length < 3)
          RewardViewImageUploadComponent(
            onUpload: onAddImage,
            title: 'Add Carousel Image',
            subtitle: 'Add ${carouselImages.isEmpty ? "1-3" : "${3 - carouselImages.length} more"} image(s)',
            compact: true,
          ),
      ],
    );
  }
}

class RewardLogoUploadSection extends StatelessWidget {
  final String? logo;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const RewardLogoUploadSection({
    super.key,
    required this.logo,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return RewardViewImageUploadComponent(
      imageUrl: (logo == null || logo!.isEmpty) ? null : logo,
      onUpload: onUpload,
      onRemove: onRemove,
      title: 'Upload Brand Logo',
      subtitle: 'Brand logo for the reward',
      compact: true,
      width: 100,
      height: 100,
    );
  }
}

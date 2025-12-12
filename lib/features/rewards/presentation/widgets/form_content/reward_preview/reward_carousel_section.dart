import 'package:flutter/material.dart';

class RewardViewCarouselSection extends StatelessWidget {
  final List<String> carouselImages;

  const RewardViewCarouselSection({
    super.key,
    required this.carouselImages,
  });

  @override
  Widget build(BuildContext context) {
    if (carouselImages.isEmpty) {
      return const SizedBox.shrink();
    }

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
}

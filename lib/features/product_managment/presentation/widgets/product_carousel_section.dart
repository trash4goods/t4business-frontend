import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/banner_image_component.dart';
import '../components/image_slider_dots_component.dart';
import '../controllers/interface/mobile_preview.controller.dart';
import '../presenters/scan_product_details_presenter.dart';

class ProductCarouselSection extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;
  final MobilePreviewControllerInterface businessController;

  const ProductCarouselSection({
    super.key,
    required this.presenter,
    required this.businessController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 201,
          width: Get.width - 21,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: presenter.scannedProduct?.middleImages.isNotEmpty == true
              ? _buildImageCarousel()
              : _buildDefaultImage(),
        ),
        if (presenter.scannedProduct?.middleImages.isNotEmpty == true)
          _buildCarouselDots(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return PageView.builder(
      itemCount: presenter.scannedProduct?.middleImages.length,
      controller: PageController(
        initialPage: presenter.productCarouselCurrent,
      ),
      onPageChanged: businessController.onCarouselPageChanged,
      itemBuilder: (context, index) {
        final imageUrl = presenter.scannedProduct?.middleImages[index];
        return GestureDetector(
          onTap: () => businessController.onImageTapped(imageUrl?.url),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: BannerImage.buildCarouselImage(
                imageUrl?.url ?? '',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultImage() {
    return GestureDetector(
      onTap: businessController.onDefaultImageTapped,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "assets/images/default_event_picture.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ImageSliderDots(
        count: presenter.scannedProduct?.middleImages.length ?? 0,
        currentIndex: presenter.productCarouselCurrent,
        onDotTapped: businessController.onCarouselDotTapped,
      ),
    );
  }
}

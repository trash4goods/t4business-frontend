import 'package:flutter/material.dart';
import '../components/banner_image_component.dart';
import '../presenters/scan_product_details_presenter.dart';

class ProductHeaderImage extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;

  const ProductHeaderImage({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    if (presenter.isPageLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Use the first carousel image as header if no dedicated header image
    String? displayImage = presenter.headerImageUrl;

    if (displayImage?.isEmpty != false &&
        presenter.scannedProduct?.middleImages.isNotEmpty == true) {
      displayImage = presenter.scannedProduct?.middleImages.first.url;
    }

    if (displayImage?.isNotEmpty == true) {
      return SizedBox(
        width: double.infinity,
        height: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0), // Remove border radius for full width
          child: BannerImage.buildCarouselImage(displayImage),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 140,
        child: BannerImage(
          placeholderPath: "assets/images/default_event_picture.jpg",
          files: [],
        ),
      );
    }
  }
}

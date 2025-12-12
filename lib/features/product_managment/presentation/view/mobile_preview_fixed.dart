import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/implementation/mobile_preview.controller.dart';
import '../presenters/scan_product_details_presenter.dart';
import '../widgets/mobile_device_frame.dart';
import '../widgets/mobile_preview_content.dart';

class MobilePreviewWidgetFixed extends StatelessWidget {
  final String title;
  final String description;
  final String? headerImage;
  final List<String>? carouselImages;
  final String? recyclingImage;
  final String barcode;
  final List<String> categories;
  final String brand;

  const MobilePreviewWidgetFixed({
    super.key,
    required this.title,
    required this.description,
    this.headerImage,
    this.carouselImages,
    this.recyclingImage,
    required this.barcode,
    required this.categories,
    this.brand = '',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanProductDetailsViewPresentation>(
      init: ScanProductDetailsViewPresentation(),
      builder: (presenter) {
        final businessController = MobilePreviewControllerImpl(
          presenter: presenter,
        );

        // Update product data whenever widget rebuilds
        presenter.updateProductData(
          title: title,
          description: description,
          headerImage: headerImage,
          carouselImages: carouselImages,
          recyclingImage: recyclingImage,
          barcode: barcode,
          categories: categories,
          brand: brand,
        );

        return MobileDeviceFrame(
          child: MobilePreviewContent(
            presenter: presenter,
            businessController: businessController,
            categories: categories,
            barcode: barcode,
          ),
        );
      },
    );
  }
}

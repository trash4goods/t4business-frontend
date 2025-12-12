import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/custom_colors.dart';
import '../controllers/interface/mobile_preview.controller.dart';
import '../presenters/scan_product_details_presenter.dart';
import 'product_header_image.dart';
import 'product_info_section.dart';
import 'product_carousel_section.dart';
import 'product_details_section.dart';

class MobilePreviewContent extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;
  final MobilePreviewControllerInterface businessController;
  final List<String> categories;
  final String barcode;

  const MobilePreviewContent({
    super.key,
    required this.presenter,
    required this.businessController,
    required this.categories,
    required this.barcode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Header Image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 160,
          child: ProductHeaderImage(presenter: presenter),
        ),

        // Content area with draggable sheet
        DraggableScrollableSheet(
          maxChildSize: 1.0,
          minChildSize: 0.65,
          initialChildSize: 0.65,
          builder: (BuildContext context, scrollController) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: CustomColors.primaryWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // Product Info Section
                  SliverToBoxAdapter(
                    child: ProductInfoSection(
                      presenter: presenter,
                      categories: categories,
                      barcode: barcode,
                    ),
                  ),

                  // Carousel Images Section - Wrap this in Obx since it checks reactive state
                  /*Obx(() {
                    if (presenter.scannedProduct?.middleImages.isNotEmpty ??
                        false) {
                      return SliverToBoxAdapter(
                        child: ProductCarouselSection(
                          presenter: presenter,
                          businessController: businessController,
                        ),
                      );
                    }
                    return SliverToBoxAdapter(child: SizedBox.shrink());
                  }),*/

                  // Product Details Section
                  SliverToBoxAdapter(
                    child: ProductDetailsSection(presenter: presenter),
                  ),

                  // Bottom padding
                  SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

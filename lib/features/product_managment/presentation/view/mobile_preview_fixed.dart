import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/utils/custom_colors.dart';
import '../../../../core/utils/translation_helper.dart';
import '../components/banner_image_component.dart';
import '../components/image_slider_dots_component.dart';
import '../controllers/scan_product_details_controller.dart';
import '../presenters/scan_product_details_presenter.dart';

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
        final controller = ScanProductDetailsViewControl(presenter);

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

        return Container(
          width: 260,
          height: 540,
          decoration: BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 10),
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
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
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
                          Icon(
                            Icons.battery_full,
                            color: Colors.white,
                            size: 14,
                          ),
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
                    child: _buildScanProductDetailsView(presenter, controller),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScanProductDetailsView(
    ScanProductDetailsViewPresentation presenter,
    ScanProductDetailsViewControl controller,
  ) {
    return Obx(
      () => Stack(
        children: [
          // Top Header Image (single image, not carousel)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160, // Adjust height
            child:
                presenter.isPageLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildHeaderImage(presenter),
          ),

          // Content area
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

                    // Product Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Text(
                          BackendTranslationHelper.translate(
                            presenter.scannedProduct?.name ?? "PRODUCT NAME",
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Product Brand
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: Text(
                          BackendTranslationHelper.translate(
                            presenter.scannedProduct?.brand ?? "Product Brand",
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    // Categories section (if not empty)
                    if (categories.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 6),
                              // Categories wrap
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children:
                                    categories.map((category) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFFE8F5E8,
                                          ), // Light green background
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Color(
                                              0xFF4CAF50,
                                            ).withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2E7D32),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Barcode
                    if (barcode.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Barcode',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      barcode.isNotEmpty
                                          ? barcode
                                          : '123456789123',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Carousel Images Section
                    if (presenter.scannedProduct?.middleImages.isNotEmpty ==
                        true)
                      SliverToBoxAdapter(
                        child: _buildCarouselImagesSection(presenter),
                      ),

                    // Product Details Section
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate(
                                          'scan_product.product_details.how_to_recycle',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF557159),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        BackendTranslationHelper.translate(
                                          presenter
                                                  .scannedProduct
                                                  ?.instructions ??
                                              'No Instructions Given',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF557159),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: BannerImage(
                                    placeholderPath:
                                        "assets/images/default_event_picture.jpg",
                                    files:
                                        presenter
                                            .scannedProduct
                                            ?.middleImages ??
                                        [],
                                    lastImageUrl:
                                        presenter
                                            .scannedProduct
                                            ?.lastImageUrl ??
                                        '',
                                    shoudlShowT4Glogo:
                                        ((presenter.scannedProduct?.files ?? [])
                                                .length ==
                                            1) ||
                                        (presenter.scannedProduct?.files ?? [])
                                            .isEmpty,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom padding
                    SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(ScanProductDetailsViewPresentation presenter) {
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
          borderRadius: BorderRadius.circular(
            0,
          ), // Remove border radius for full width
          child: BannerImage.buildCarouselImage(displayImage!),
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

  Widget _buildCarouselImagesSection(
    ScanProductDetailsViewPresentation presenter,
  ) {
    return Column(
      children: [
        Container(
          height: 201,
          width: Get.width - 21,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              presenter.scannedProduct?.middleImages.isNotEmpty == true
                  ? PageView.builder(
                    itemCount: presenter.scannedProduct?.middleImages.length,
                    controller: PageController(
                      initialPage: presenter.productCarouselCurrent,
                    ),
                    onPageChanged:
                        (index) => presenter.productCarouselCurrent = index,
                    itemBuilder: (context, index) {
                      final imageUrl =
                          presenter.scannedProduct?.middleImages[index];
                      return GestureDetector(
                        onTap:
                            () => print(
                              'Tapped image: ${imageUrl?.url}',
                            ), // Replace with your show full screen logic
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
                  )
                  : GestureDetector(
                    onTap: () => print('Tapped default image'),
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
                  ),
        ),
        if (presenter.scannedProduct?.middleImages.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ImageSliderDots(
              count: presenter.scannedProduct?.middleImages.length ?? 0,
              currentIndex: presenter.productCarouselCurrent,
              onDotTapped: (index) => presenter.productCarouselCurrent = index,
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

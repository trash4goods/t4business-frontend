import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_file_entity.dart';
import '../../domain/entities/scanned_product_entity.dart';
import '../../data/models/upload_file_model.dart';
import '../../utils/image_display_helper.dart';
import '../interfaces/scan_product_details_interfaces.dart';

class ScanProductDetailsViewPresentation extends ScanProductDetailsViewPresenter
    with GetSingleTickerProviderStateMixin {
  ScanProductDetailsViewPresentation() {
    _initPresenter();
  }

  final _currentImageIndex = RxInt(0);
  @override
  int get currentImageIndex => _currentImageIndex.value;
  @override
  set currentImageIndex(int value) => _currentImageIndex.value = value;

  final _isPageLoading = RxBool(false);
  @override
  bool get isPageLoading => _isPageLoading.value;
  @override
  set isPageLoading(bool value) => _isPageLoading.value = value;

  final _productCarouselCurrent = RxInt(0);
  @override
  int get productCarouselCurrent => _productCarouselCurrent.value;
  @override
  set productCarouselCurrent(int value) =>
      _productCarouselCurrent.value = value;

  final _productFileList = Rx<List<ProductFileEntity>?>(<ProductFileEntity>[]);
  @override
  List<ProductFileEntity>? get productFileList => _productFileList.value;
  @override
  set productFileList(List<ProductFileEntity>? value) =>
      _productFileList.value = value;

  final _scannedProduct = Rx<ScannedProductEntity?>(ScannedProductEntity());
  @override
  ScannedProductEntity? get scannedProduct => _scannedProduct.value;
  @override
  set scannedProduct(ScannedProductEntity? value) =>
      _scannedProduct.value = value;

  @override
  final carouselController = CarouselSliderController();

  // Header image URL (separate from carousel)
  String? headerImageUrl;

  Future<void> _initPresenter() async {
    _isPageLoading.value = false;
  }

  // Method to update product data from form using ImageDisplayHelper
  void updateProductData({
    required String title,
    required String description,
    String? headerImage,
    List<String>? carouselImages,
    String? recyclingImage,
    required String barcode,
    required List<String> categories,
    String brand = '',
  }) {
    log('📱 MobilePreview updateProductData called:');
    log('  📷 headerImage: $headerImage');
    log('  🎠 carouselImages: $carouselImages');
    log('  ♻️ recyclingImage: $recyclingImage');

    // Create upload files list from the provided images
    List<UploadFileModel> uploadFiles = [];

    // Add header image first (if provided)
    if (headerImage?.isNotEmpty == true) {
      uploadFiles.add(UploadFileModel(url: headerImage));
    }

    // Add carousel images in the middle
    if (carouselImages?.isNotEmpty == true) {
      uploadFiles.addAll(
        carouselImages!.map((url) => UploadFileModel(url: url)),
      );
    }

    // Add recycling image last (if provided and different from carousel images)
    if (recyclingImage?.isNotEmpty == true &&
        (carouselImages?.contains(recyclingImage) != true)) {
      uploadFiles.add(UploadFileModel(url: recyclingImage));
    }

    // Use ImageDisplayHelper to categorize images according to business rules
    final imageSections = ImageDisplayHelper.categorizeImages(uploadFiles);

    log('📋 ImageDisplayHelper results:');
    log('  📷 Header: ${imageSections.headerImage}');
    log('  🎠 Carousel: ${imageSections.carouselImages}');
    log('  ♻️ Details: ${imageSections.productDetailsImage}');

    // Convert carousel images to ProductFileEntity for compatibility
    List<ProductFileEntity> carouselFileList =
        imageSections.carouselImages
            .map((url) => ProductFileEntity(url: url))
            .toList();

    productFileList = carouselFileList;

    scannedProduct = ScannedProductEntity(
      name: title.isNotEmpty ? title : "PRODUCT NAME",
      brand: brand.isNotEmpty ? brand : "Product Brand",
      instructions:
          description.isNotEmpty ? description : "No Instructions Given",
      middleImages: carouselFileList,
      lastImageUrl: imageSections.productDetailsImage,
      files: carouselFileList,
    );

    // Store header image separately using ImageDisplayHelper result
    headerImageUrl = imageSections.headerImage;

    // Reset carousel position when data changes
    productCarouselCurrent = 0;
    currentImageIndex = 0;
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import '../../../domain/entities/product_file_entity.dart';
import '../../../domain/entities/scanned_product_entity.dart';
import '../interface/scan_product_details_interfaces.dart';

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

  // Method to update product data from form
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
    print('📱 MobilePreview updateProductData called:');
    print('  📷 headerImage: $headerImage');
    print('  🎠 carouselImages: $carouselImages');
    print('  ♻️ recyclingImage: $recyclingImage');

    // Header image is separate - not part of carousel
    String? finalHeaderImage =
        headerImage?.isNotEmpty == true ? headerImage : null;

    // Carousel images are separate from header
    List<ProductFileEntity> carouselFileList = [];
    if (carouselImages?.isNotEmpty == true) {
      print('✅ Adding ${carouselImages!.length} carousel images');
      carouselFileList.addAll(
        carouselImages.map((url) => ProductFileEntity(url: url)),
      );
    }

    // Determine recycling image based on carousel images
    String? finalRecyclingImage;
    if (carouselImages?.isNotEmpty == true) {
      if (carouselImages!.length == 1) {
        // If only 1 carousel image, use it for recycling
        finalRecyclingImage = carouselImages.first;
        print(
          '✅ Using single carousel image for recycling: $finalRecyclingImage',
        );
      } else if (carouselImages.length >= 2) {
        // If 2+ carousel images, use the last one for recycling
        finalRecyclingImage = carouselImages.last;
        print(
          '✅ Using last carousel image for recycling: $finalRecyclingImage',
        );
      }
    }

    print('📋 Final carousel images count: ${carouselFileList.length}');
    print('📋 Final recycling image: $finalRecyclingImage');

    productFileList = carouselFileList;

    scannedProduct = ScannedProductEntity(
      name: title.isNotEmpty ? title : "PRODUCT NAME",
      brand: brand.isNotEmpty ? brand : "Product Brand",
      instructions:
          description.isNotEmpty ? description : "No Instructions Given",
      middleImages: carouselFileList, // Only carousel images, not header
      lastImageUrl: finalRecyclingImage,
      files: carouselFileList,
    );

    // Store header image separately
    headerImageUrl = finalHeaderImage;

    // Reset carousel position when data changes
    productCarouselCurrent = 0;
    currentImageIndex = 0;
  }
}
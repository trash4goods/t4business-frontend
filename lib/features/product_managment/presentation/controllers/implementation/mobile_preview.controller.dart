import 'package:get/get.dart';
import '../../../../../core/services/snackbar.dart';
import '../../presenters/scan_product_details_presenter.dart';
import '../interface/mobile_preview.controller.dart';

class MobilePreviewControllerImpl implements MobilePreviewControllerInterface {
  final ScanProductDetailsViewPresentation presenter;

  MobilePreviewControllerImpl({
    required this.presenter,
  });

  @override
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
    // Update presenter with product data
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
  }

  @override
  void onCarouselPageChanged(int index) {
    presenter.productCarouselCurrent = index;
  }

  @override
  void onCarouselDotTapped(int index) {
    presenter.productCarouselCurrent = index;
  }

  @override
  void onImageTapped(String? imageUrl) {
    if (imageUrl?.isNotEmpty == true) {
      // TODO: Implement full screen image view
      print('Tapped image: $imageUrl');
    }
  }

  @override
  void onDefaultImageTapped() {
    print('Tapped default image');
  }

  @override
  void navigateBack() {
    Get.back();
  }

  @override
  void showError(String message) {
    SnackbarService.showError(
      message,
      position: SnackPosition.TOP,
      actionLabel: 'Dismiss',
      onActionPressed: () => Get.back(),
    );
  }

  @override
  void showSuccess(String message) {
    SnackbarService.showSuccess(
      message,
      title: 'Success',
    );
  }
}

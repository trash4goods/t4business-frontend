abstract class MobilePreviewControllerInterface {
  // Product data management
  void updateProductData({
    required String title,
    required String description,
    String? headerImage,
    List<String>? carouselImages,
    String? recyclingImage,
    required String barcode,
    required List<String> categories,
    String brand = '',
  });
  
  // Image carousel navigation
  void onCarouselPageChanged(int index);
  void onCarouselDotTapped(int index);
  
  // Image interaction
  void onImageTapped(String? imageUrl);
  void onDefaultImageTapped();
  
  // Navigation methods
  void navigateBack();
  
  // UI state methods
  void showError(String message);
  void showSuccess(String message);
}

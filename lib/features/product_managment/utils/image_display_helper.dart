import '../data/models/upload_file_model.dart';
import '../data/models/barcode/barcode_result_file.dart';

class ImageDisplayHelper {
  // Legacy method for backward compatibility
  static ImageSections categorizeImages(List<UploadFileModel> uploadFiles) {
    if (uploadFiles.isEmpty) {
      return ImageSections.empty();
    }

    if (uploadFiles.length == 1) {
      return ImageSections(
        headerImage: uploadFiles.first.url,
        carouselImages: [],
        productDetailsImage: null,
      );
    }

    if (uploadFiles.length == 2) {
      return ImageSections(
        headerImage: uploadFiles.first.url,
        carouselImages: [],
        productDetailsImage: uploadFiles.last.url,
      );
    }

    // 3 or more images
    return ImageSections(
      headerImage: uploadFiles.first.url,
      carouselImages:
          uploadFiles
              .sublist(1, uploadFiles.length - 1)
              .map((file) => file.url ?? '')
              .where((url) => url.isNotEmpty)
              .toList(),
      productDetailsImage: uploadFiles.last.url,
    );
  }

  // New method for barcode result files
  static ImageSections categorizeResultFiles(
    List<BarcodeResultFileModel> files,
  ) {
    if (files.isEmpty) {
      return ImageSections.empty();
    }

    if (files.length == 1) {
      return ImageSections(
        headerImage: files.first.url,
        carouselImages: [],
        productDetailsImage: null,
      );
    }

    if (files.length == 2) {
      return ImageSections(
        headerImage: files.first.url,
        carouselImages: [],
        productDetailsImage: files.last.url,
      );
    }

    // 3 or more images
    return ImageSections(
      headerImage: files.first.url,
      carouselImages:
          files
              .sublist(1, files.length - 1)
              .map((file) => file.url ?? '')
              .where((url) => url.isNotEmpty)
              .toList(),
      productDetailsImage: files.last.url,
    );
  }
}

class ImageSections {
  final String? headerImage;
  final List<String> carouselImages;
  final String? productDetailsImage;

  ImageSections({
    this.headerImage,
    required this.carouselImages,
    this.productDetailsImage,
  });

  factory ImageSections.empty() => ImageSections(carouselImages: []);

  bool get hasHeaderImage => headerImage?.isNotEmpty ?? false;
  bool get hasCarouselImages => carouselImages.isNotEmpty;
  bool get hasProductDetailsImage => productDetailsImage?.isNotEmpty ?? false;

  @override
  String toString() =>
      'ImageSections(headerImage: $headerImage, carouselImages: ${carouselImages.length}, productDetailsImage: $productDetailsImage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageSections &&
        other.headerImage == headerImage &&
        other.productDetailsImage == productDetailsImage &&
        other.carouselImages.length == carouselImages.length;
  }

  @override
  int get hashCode =>
      Object.hash(headerImage, carouselImages.length, productDetailsImage);
}

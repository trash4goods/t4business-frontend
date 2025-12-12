import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../../../domain/entities/product_file_entity.dart';
import '../../../domain/entities/scanned_product_entity.dart';

abstract class ScanProductDetailsViewPresenter extends GetxController {
  ScannedProductEntity? get scannedProduct;
  set scannedProduct(ScannedProductEntity? value);

  bool get isPageLoading;
  set isPageLoading(bool value);

  CarouselSliderController get carouselController;

  int get currentImageIndex;
  set currentImageIndex(int value);

  List<ProductFileEntity>? get productFileList;
  set productFileList(List<ProductFileEntity>? value);

  int get productCarouselCurrent;
  set productCarouselCurrent(int value);
}
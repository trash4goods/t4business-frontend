import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import '../../../data/models/product.dart';
import '../interface/product.dart';

class ProductsControllerImpl extends GetxController
    implements ProductsControllerInterface {
  // Mock data for demonstration
  final RxList<ProductModel> _products = <ProductModel>[].obs;
  final RxList<String> _categories =
      <String>[
        'Bottles',
        'Electronics',
        'Stationery',
        'Clothing',
        'Accessories',
        'Food & Beverage',
        'Home & Garden',
        'Sports & Outdoors',
      ].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMockData();
  }

  void _initializeMockData() {
    _products.addAll([
      ProductModel(
        id: 1,
        title: 'Coca-Cola 1L',
        brand: 'Coca-Cola',
        description:
            'Sustainable coca cola bottle made from recycled materials',
        headerImage: AppImages.cocaColaCanBarcode,
        carouselImage: [AppImages.cocaColaCan, AppImages.cocaColaCans],
        barcode: '1234567890123',
        category: ['Bottles', 'Eco-friendly'],
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      ProductModel(
        id: 2,
        title: 'Pingo Doce Water Bottle 1L',
        brand: 'Pingo Doce',
        description: 'Sustainable water bottle made from recycled materials',
        headerImage: AppImages.pingoDoceWaterBottleBarcode,
        carouselImage: [AppImages.pingoDoceWaterBottle],
        barcode: '2234567890123',
        category: ['Bottles', 'Eco-friendly'],
        createdAt: DateTime.now().subtract(Duration(days: 20)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      ProductModel(
        id: 1,
        title: 'Coca-Cola 5L Zero',
        brand: 'Coca-Cola',
        description:
            'Sustainable coca cola bottle made from recycled materials',
        headerImage: AppImages.cocaColaCan,
        carouselImage: [AppImages.cocaColaCan, AppImages.cocaColaCans],
        barcode: '1234567890123',
        category: ['Eco-friendly'],
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
      ),
    ]);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API call
    return _products.toList();
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _products.firstWhereOrNull((product) => product.id == id);
  }

  @override
  Future<bool> createProduct(ProductModel product) async {
    await Future.delayed(Duration(milliseconds: 800));
    try {
      final newProduct = product.copyWith(
        id: _products.length + 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _products.add(newProduct);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    await Future.delayed(Duration(milliseconds: 600));
    try {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product.copyWith(updatedAt: DateTime.now());
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    await Future.delayed(Duration(milliseconds: 400));
    try {
      _products.removeWhere((product) => product.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  List<ProductModel> filterProductsByCategory(String category) {
    if (category.isEmpty) return _products.toList();
    return _products
        .where(
          (product) => product.category.any(
            (cat) => cat.toLowerCase().contains(category.toLowerCase()),
          ),
        )
        .toList();
  }

  @override
  List<String> getAllCategories() {
    return _categories.toList();
  }

  @override
  Future<String> uploadImage(String imagePath) async {
    log('🔄 Controller: Uploading image from path: $imagePath');

    try {
      if (kIsWeb) {
        // For web, we can't store files locally, so we return the blob URL directly
        // In a real app, you'd upload to a server and get back a URL
        log('🌐 Web platform detected - using blob URL directly');
        await Future.delayed(
          Duration(milliseconds: 1000),
        ); // Simulate upload delay

        // For web, return the blob URL as-is since we can't store locally
        final webImageUrl = imagePath; // Use the blob URL directly
        log('✅ Controller: Returning web image URL: $webImageUrl');
        return webImageUrl;
      } else {
        // For mobile/desktop, use local storage
        log('📱 Mobile/Desktop platform detected - storing locally');

        // This would work on mobile/desktop
        // final appDocDir = await getApplicationDocumentsDirectory();
        // For now, return a mock local path
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final mockLocalPath =
            '/local/product_images/product_image_$timestamp.jpg';

        await Future.delayed(Duration(milliseconds: 1000));
        log('✅ Controller: Returning mock local path: $mockLocalPath');
        return mockLocalPath;
      }
    } catch (e) {
      log('💥 Controller error: $e');

      // Fallback: return a test image URL that will work
      final fallbackUrl =
          'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}';
      log('🔄 Using fallback URL: $fallbackUrl');
      return fallbackUrl;
    }
  }

  @override
  Future<bool> validateBarcode(String barcode) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Simple validation: check if barcode is 13 digits
    return barcode.length == 13 && int.tryParse(barcode) != null;
  }
}

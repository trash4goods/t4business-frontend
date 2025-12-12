import 'dart:typed_data';

import '../../../data/models/barcode/index.dart';

abstract class ProductsControllerInterface {
  // Loading state
  bool get isLoading;

  // Error state
  String? get errorMessage;

  // Pagination state
  int get currentPage;
  int get totalCount;
  bool get hasNextPage;
  int get perPage;
  List<BarcodeResultModel> get products;

  // API-based methods with pagination
  Future<BarcodeModel> getProducts({int perPage = 10, int page = 1});

  Future<BarcodeResultModel?> getProductById(String id);
  Future<BarcodeResultModel> createProduct(BarcodeResultModel product);
  Future<BarcodeResultModel> updateProduct(
    String id,
    BarcodeResultModel product,
  );
  Future<void> deleteProduct(String id);

  // Pagination methods
  Future<void> refreshProducts();
  Future<void> loadNextPage();

  // Legacy methods for backward compatibility
  Future<List<BarcodeResultModel>> getAllProducts();
  Future<bool> createProductLegacy(BarcodeResultModel product);
  Future<bool> updateProductLegacy(BarcodeResultModel product);
  Future<bool> deleteProductLegacy(int id);

  // Utility methods
  List<BarcodeResultModel> filterProductsByCategory(String category);
  List<String> getAllCategories();
  Future<String> uploadImage(String imagePath);
  Future<String> uploadImageWithBytes(Uint8List fileBytes, String fileName);
  Future<bool> validateBarcode(String barcode);
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName});
  
  // UI feedback methods
  void showError(String message);
  void showSuccess(String message);
}

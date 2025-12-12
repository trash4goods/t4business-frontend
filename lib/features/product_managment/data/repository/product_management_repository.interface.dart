import 'dart:typed_data';

import '../models/barcode/index.dart';
import '../models/barcode_upload.dart';

abstract class ProductManagementRepositoryInterface {
  /// Get products with pagination
  /// [token] - Bearer token for authentication
  /// [perPage] - Number of items per page (default: 10)
  /// [page] - Page number (default: 1)
  Future<BarcodeModel> getProducts(
    String token, {
    int perPage = 10,
    int page = 1,
  });

  /// Create a new product
  /// [product] - Product data to create (BarcodeUploadModel for API compatibility)
  /// [token] - Bearer token for authentication
  Future<BarcodeResultModel> createProduct(
    BarcodeUploadModel product,
    String token,
  );

  /// Update an existing product
  /// [id] - Product ID to update
  /// [product] - Updated product data (BarcodeUploadModel for API compatibility)
  /// [token] - Bearer token for authentication
  Future<BarcodeResultModel> updateProduct(
    String id,
    BarcodeUploadModel product,
    String token,
  );

  /// Delete a product
  /// [id] - Product ID to delete
  /// [token] - Bearer token for authentication
  Future<void> deleteProduct(String id, String token);

  /// Upload CSV file for bulk product creation
  /// [filePath] - Path to the CSV file to upload
  /// [token] - Bearer token for authentication
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName, String? token});
}

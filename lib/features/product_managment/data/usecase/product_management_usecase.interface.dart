import 'dart:typed_data';

import '../models/barcode/index.dart';
import '../models/pagination_response_model.dart';

/// Interface for Product Management Use Case
/// Defines business logic methods for product operations
abstract class ProductManagementUseCaseInterface {
  /// Get products with pagination and business logic processing
  /// [token] - Bearer token for authentication
  /// [perPage] - Number of items per page (default: 10)
  /// [page] - Page number (default: 1)
  ///
  /// Applies business logic to filter and process product data
  /// Throws [Exception] if operation fails
  Future<BarcodeModel> getProducts(
    String token, {
    int perPage = 10,
    int page = 1,
  });

  /// Create a new product with business logic processing
  /// [product] - Product data to create
  /// [token] - Bearer token for authentication
  ///
  /// Business rules applied:
  /// - Image categorization (first=header, last=details, middle=carousel)
  /// - Data processing and transformation
  ///
  /// Throws [Exception] if operation fails
  Future<BarcodeResultModel> createProduct(
    BarcodeResultModel product,
    String token,
  );

  /// Update an existing product with business logic processing
  /// [id] - Product ID to update
  /// [product] - Updated product data
  /// [token] - Bearer token for authentication
  ///
  /// Business rules applied:
  /// - Image categorization (first=header, last=details, middle=carousel)
  /// - Data processing and transformation
  ///
  /// Throws [Exception] if operation fails
  Future<BarcodeResultModel> updateProduct(
    String id,
    BarcodeResultModel product,
    String token,
  );

  /// Delete a product
  /// [id] - Product ID to delete
  /// [token] - Bearer token for authentication
  ///
  /// Throws [Exception] if operation fails
  Future<void> deleteProduct(String id, String token);

  /// Upload CSV file for bulk product creation
  /// [filePath] - Path to the CSV file to upload
  /// [token] - Bearer token for authentication
  ///
  /// Uploads CSV file to bulk endpoint for processing
  /// Returns response from the server
  ///
  /// Throws [Exception] if operation fails
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName, String? token});
}

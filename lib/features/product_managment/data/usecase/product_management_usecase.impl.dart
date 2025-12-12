import 'dart:typed_data';

import '../models/barcode/index.dart';
import '../models/barcode_upload.dart';
import '../transformers/barcode_model_transformer.dart';

import '../repository/product_management_repository.interface.dart';
import 'product_management_usecase.interface.dart';

/// Implementation of Product Management Use Case
/// Contains business logic coordination and data processing
class ProductManagementUseCaseImpl
    implements ProductManagementUseCaseInterface {
  final ProductManagementRepositoryInterface repository;

  ProductManagementUseCaseImpl(this.repository);

  @override
  Future<BarcodeModel> getProducts(
    String token, {
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      // Call repository to get products
      return await repository.getProducts(token, perPage: perPage, page: page);
    } catch (e) {
      throw Exception('Failed to get products: ${e.toString()}');
    }
  }

  @override
  Future<BarcodeResultModel> createProduct(
    BarcodeResultModel product,
    String token,
  ) async {
    try {
      // Apply business logic: process image categorization if images are provided
      BarcodeResultModel processedProduct = product;
      if (product.files != null && product.files!.isNotEmpty) {
        processedProduct = _applyImageBusinessRules(product);
      }

      // Validate the product data before transformation
      if (!BarcodeModelTransformer.isValidForUpdate(processedProduct)) {
        throw Exception('Product data is invalid for create operation');
      }

      // Transform BarcodeResultModel to BarcodeUploadModel with base64 image conversion
      BarcodeUploadModel uploadModel =
          await BarcodeModelTransformer.toUploadModelWithBase64Images(
            processedProduct,
          );

      // Call repository to create product with the transformed model
      return await repository.createProduct(uploadModel, token);
    } catch (e) {
      throw Exception('Failed to create product: ${e.toString()}');
    }
  }

  @override
  Future<BarcodeResultModel> updateProduct(
    String id,
    BarcodeResultModel product,
    String token,
  ) async {
    try {
      // Apply business logic: process image categorization if images are provided
      BarcodeResultModel processedProduct = product;
      if (product.files != null && product.files!.isNotEmpty) {
        processedProduct = _applyImageBusinessRules(product);
      }

      // Validate the product data before transformation
      if (!BarcodeModelTransformer.isValidForUpdate(processedProduct)) {
        throw Exception('Product data is invalid for update operation');
      }

      // Transform BarcodeResultModel to BarcodeUploadModel with base64 image conversion
      // Pass isUpdate: true to indicate this is an update operation
      BarcodeUploadModel uploadModel =
          await BarcodeModelTransformer.toUploadModelWithBase64Images(
            processedProduct,
            isUpdate: true,
          );

      // Call repository to update product with the transformed model
      return await repository.updateProduct(id, uploadModel, token);
    } catch (e) {
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProduct(String id, String token) async {
    try {
      // Call repository to delete product
      await repository.deleteProduct(id, token);
    } catch (e) {
      throw Exception('Failed to delete product: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName, String? token}) async {
    try {
      // Call repository to upload CSV file
      return await repository.uploadCsvFile(fileBytes: fileBytes, fileName: fileName, token: token);
    } catch (e) {
      throw Exception('Failed to upload CSV file: ${e.toString()}');
    }
  }

  /// Applies image business rules for categorization
  ///
  /// Business rules:
  /// - First image = header section
  /// - Last image = product details section
  /// - Middle images = carousel section
  BarcodeResultModel _applyImageBusinessRules(BarcodeResultModel product) {
    if (product.uploadFiles.isEmpty) {
      return product;
    }

    // The business logic for image categorization is already implemented
    // in the ProductModel class through the getter methods:
    // - headerImage: returns first image
    // - productDetailsImage: returns last image (if more than 1)
    // - carouselImages: returns middle images (if more than 2)

    // For now, we just return the product as-is since the categorization
    // logic is handled by the model's getter methods
    return product;
  }
}

import 'dart:developer';
import 'dart:typed_data';

import '../datasource/remote/product_management_remote_datasource.interface.dart';
import '../models/barcode/index.dart';
import '../models/barcode_upload.dart';
import 'product_management_repository.interface.dart';

class ProductManagementRepositoryImpl
    implements ProductManagementRepositoryInterface {
  final ProductManagementRemoteDatasourceInterface remoteDatasource;

  ProductManagementRepositoryImpl(this.remoteDatasource);

  @override
  Future<BarcodeModel> getProducts(
    String token, {
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      log(
        '[ProductManagementRepositoryImpl] getProducts called with perPage: $perPage, page: $page',
      );

      // Basic pagination parameter validation
      if (perPage < 1 || perPage > 100) {
        throw ArgumentError('perPage must be between 1 and 100');
      }
      if (page < 1) {
        throw ArgumentError('page must be greater than 0');
      }

      final result = await remoteDatasource.getProducts(
        token,
        perPage: perPage,
        page: page,
      );

      log(
        '[ProductManagementRepositoryImpl] getProducts successful, count: ${result.pagination?.count ?? 'null'}',
      );
      return result;
    } catch (e) {
      log('[ProductManagementRepositoryImpl] getProducts error: $e');
      rethrow;
    }
  }

  @override
  Future<BarcodeResultModel> createProduct(
    BarcodeUploadModel product,
    String token,
  ) async {
    try {
      log(
        '[ProductManagementRepositoryImpl] createProduct called for: ${product.name}',
      );

      final result = await remoteDatasource.createProduct(product, token);

      log(
        '[ProductManagementRepositoryImpl] createProduct successful, id: ${result.id}',
      );
      return result;
    } catch (e) {
      log('[ProductManagementRepositoryImpl] createProduct error: $e');
      rethrow;
    }
  }

  @override
  Future<BarcodeResultModel> updateProduct(
    String id,
    BarcodeUploadModel product,
    String token,
  ) async {
    try {
      log('[ProductManagementRepositoryImpl] updateProduct called for id: $id');

      // Basic ID validation
      if (id.isEmpty) {
        throw ArgumentError('Product ID cannot be empty');
      }

      final result = await remoteDatasource.updateProduct(id, product, token);

      log(
        '[ProductManagementRepositoryImpl] updateProduct successful, id: ${result.id}',
      );
      return result;
    } catch (e) {
      log('[ProductManagementRepositoryImpl] updateProduct error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id, String token) async {
    try {
      log('[ProductManagementRepositoryImpl] deleteProduct called for id: $id');

      // Basic ID validation
      if (id.isEmpty) {
        throw ArgumentError('Product ID cannot be empty');
      }

      await remoteDatasource.deleteProduct(id, token);

      log(
        '[ProductManagementRepositoryImpl] deleteProduct successful for id: $id',
      );
    } catch (e) {
      log('[ProductManagementRepositoryImpl] deleteProduct error: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName, String? token}) async {
    try {
      log(
        '[ProductManagementRepositoryImpl] uploadCsvFile called for: $fileName',
      );

      // Basic file path validation
      if (fileName!.isEmpty) {
        throw ArgumentError('File name cannot be empty');
      }

      final result = await remoteDatasource.uploadCsvFile(fileBytes: fileBytes, fileName: fileName, token: token);

      log('[ProductManagementRepositoryImpl] uploadCsvFile successful');
      return result;
    } catch (e) {
      log('[ProductManagementRepositoryImpl] uploadCsvFile error: $e');
      rethrow;
    }
  }
}

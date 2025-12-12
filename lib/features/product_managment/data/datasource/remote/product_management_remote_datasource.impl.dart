import 'dart:developer';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../../../core/app/api_endpoints.dart';
import '../../../../../../core/app/api_method.dart';
import '../../../../../../core/services/http_interface.dart';
import '../../models/barcode/index.dart';
import '../../models/barcode_upload.dart';
import 'product_management_remote_datasource.interface.dart';

class ProductManagementRemoteDatasourceImpl
    implements ProductManagementRemoteDatasourceInterface {
  final IHttp http;

  ProductManagementRemoteDatasourceImpl(this.http);

  @override
  Future<BarcodeModel> getProducts(
    String token, {
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.get,
        endpoint: '${ApiEndpoints.getProducts}?perPage=$perPage&page=$page',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        isDevEnv: true,
      );

      log(
        '[ProductManagementRemoteDatasourceImpl] getProducts response status: ${response.statusCode}',
      );
      log(
        '[ProductManagementRemoteDatasourceImpl] getProducts response: ${response.response}',
      );

      if (response.statusCode == 200) {
        return BarcodeModel.fromJson(response.response);
      }

      throw _handleHttpError(
        response.statusCode,
        response.response,
        'Failed to load products',
      );
    } catch (e) {
      log('[ProductManagementRemoteDatasourceImpl] getProducts error: $e');
      rethrow;
    }
  }

  @override
  Future<BarcodeResultModel> createProduct(
    BarcodeUploadModel product,
    String token,
  ) async {
    try {
      final requestBody = product.toJson();
      log(
        '[ProductManagementRemoteDatasourceImpl] createProduct request body: $requestBody',
      );

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.createProduct,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
        isDevEnv: true,
      );

      log(
        '[ProductManagementRemoteDatasourceImpl] createProduct response status: ${response.statusCode}',
      );
      log(
        '[ProductManagementRemoteDatasourceImpl] createProduct response: ${response.response}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return BarcodeResultModel.fromJson(response.response);
      }

      throw _handleHttpError(
        response.statusCode,
        response.response,
        'Failed to create product',
      );
    } catch (e) {
      log('[ProductManagementRemoteDatasourceImpl] createProduct error: $e');
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
      final requestBody = product.toJson();
      log(
        '[ProductManagementRemoteDatasourceImpl] updateProduct request body: $requestBody',
      );

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.put,
        endpoint: '${ApiEndpoints.updateProduct}/$id',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
        isDevEnv: true,
      );

      log(
        '[ProductManagementRemoteDatasourceImpl] updateProduct response status: ${response.statusCode}',
      );
      log(
        '[ProductManagementRemoteDatasourceImpl] updateProduct response: ${response.response}',
      );

      if (response.statusCode == 200) {
        return BarcodeResultModel.fromJson(response.response);
      }

      throw _handleHttpError(
        response.statusCode,
        response.response,
        'Failed to update product',
      );
    } catch (e) {
      log('[ProductManagementRemoteDatasourceImpl] updateProduct error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id, String token) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.delete,
        endpoint: '${ApiEndpoints.deleteProduct}/$id',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        isDevEnv: true,
      );

      log(
        '[ProductManagementRemoteDatasourceImpl] deleteProduct response status: ${response.statusCode}',
      );
      log(
        '[ProductManagementRemoteDatasourceImpl] deleteProduct response: ${response.response}',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw _handleHttpError(
          response.statusCode,
          response.response,
          'Failed to delete product',
        );
      }
    } catch (e) {
      log('[ProductManagementRemoteDatasourceImpl] deleteProduct error: $e');
      rethrow;
    }
  }

  /// Handle HTTP errors and throw appropriate exceptions
  Exception _handleHttpError(
    int statusCode,
    dynamic response,
    String defaultMessage,
  ) {
    switch (statusCode) {
      case 400:
        return Exception(
          'Bad Request: Invalid request data. ${_extractErrorMessage(response)}',
        );
      case 401:
        return Exception(
          'Unauthorized: Authentication required. Please log in again.',
        );
      case 403:
        return Exception(
          'Forbidden: Insufficient permissions to perform this action.',
        );
      case 404:
        return Exception('Not Found: The requested resource was not found.');
      case 409:
        return Exception(
          'Conflict: Resource already exists or conflicts with existing data.',
        );
      case 422:
        return Exception('Validation Error: ${_extractErrorMessage(response)}');
      case 500:
        return Exception('Internal Server Error: Please try again later.');
      default:
        return Exception('$defaultMessage (Status: $statusCode)');
    }
  }

  @override
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName, String? token}) async {
    try {
      log(
        '[ProductManagementRemoteDatasourceImpl] uploadCsvFile called for: $fileName',
      );

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.uploadCsv,
        headers: {'Authorization': 'Bearer $token'},
        fileBytes: fileBytes,
        fileName: fileName,
        fileFieldName: 'file',
        isDevEnv: true,
      );

      log(
        '[ProductManagementRemoteDatasourceImpl] uploadCsvFile response status: ${response.statusCode}',
      );
      log(
        '[ProductManagementRemoteDatasourceImpl] uploadCsvFile response: ${response.response}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.response?.toString() ?? '';
      }

      throw _handleHttpError(
        response.statusCode,
        response.response,
        'Failed to upload CSV file',
      );
    } catch (e) {
      log('[ProductManagementRemoteDatasourceImpl] uploadCsvFile error: $e');
      rethrow;
    }
  }

  /// Extract error message from response
  String _extractErrorMessage(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('message')) {
        return response['message'].toString();
      }
      if (response.containsKey('error')) {
        return response['error'].toString();
      }
      if (response.containsKey('errors')) {
        final errors = response['errors'];
        if (errors is List) {
          return errors.join(', ');
        }
        if (errors is Map) {
          return errors.values.join(', ');
        }
        return errors.toString();
      }
    }
    return response?.toString() ?? '';
  }
}

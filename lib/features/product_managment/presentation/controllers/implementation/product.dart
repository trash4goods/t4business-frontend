import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../../data/models/barcode/index.dart';
import '../../../data/usecase/product_management_usecase.interface.dart';
import '../interface/product.dart';
import '../../../../../../utils/helpers/snackbar_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../widgets/delete_product_dialog.dart';
import '../../../utils/image_base64_converter.dart';

class ProductsControllerImpl extends GetxController
    implements ProductsControllerInterface {
  final ProductManagementUseCaseInterface _useCase;

  // State management
  final RxBool _isLoading = false.obs;
  final RxnString _errorMessage = RxnString();
  final RxList<BarcodeResultModel> _products = <BarcodeResultModel>[].obs;
  final RxList<String> _categories =
      <String>[
        'paper',
        'cardboard',
        'plastic',
        'metal',
        'glass',
        'tetrapak',
        'can',
        'pet'
      ].obs;

  // Pagination state
  final RxInt _currentPage = 1.obs;
  final RxInt _totalCount = 0.obs;
  final RxBool _hasNextPage = false.obs;
  final RxInt _perPage = 10.obs;

  ProductsControllerImpl(this._useCase);

  @override
  void onInit() {
    super.onInit();
    // Load initial products when controller is initialized
    _loadInitialProducts();
  }

  /// Load initial products with error handling
  Future<void> _loadInitialProducts() async {
    try {
      await refreshProducts();
    } catch (e) {
      // Don't show error snackbar on initial load, just log it
      log('[ProductsControllerImpl] Failed to load initial products: $e');
      _errorMessage.value =
          'Failed to load products. Please refresh to try again.';
    }
  }

  @override
  bool get isLoading => _isLoading.value;

  @override
  String? get errorMessage => _errorMessage.value;

  // Pagination getters
  @override
  int get currentPage => _currentPage.value;

  @override
  int get totalCount => _totalCount.value;

  @override
  bool get hasNextPage => _hasNextPage.value;

  @override
  int get perPage => _perPage.value;

  @override
  List<BarcodeResultModel> get products => _products.toList();

  /// Get authentication token from Firebase Auth
  Future<String> _getAuthToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken == null) return '';

      return cachedUser!.accessToken!;
    } catch (e) {
      log('[ProductsControllerImpl] Error getting auth token: $e');
      throw Exception('Authentication failed: ${e.toString()}');
    }
  }

  /// Handle errors and provide user-friendly messages
  void _handleError(dynamic error, String operation) {
    log('[ProductsControllerImpl] Error in $operation: $error');

    String userMessage;
    String errorString = error.toString().toLowerCase();

    if (errorString.contains('authentication') || errorString.contains('401')) {
      userMessage = 'Please log in to continue';
    } else if (errorString.contains('authorization') ||
        errorString.contains('403')) {
      userMessage = 'You don\'t have permission to perform this action';
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      userMessage = 'Network error. Please check your connection and try again';
    } else if (errorString.contains('validation') ||
        errorString.contains('400')) {
      userMessage = 'Please check your input and try again';
    } else if (errorString.contains('not found') ||
        errorString.contains('404')) {
      userMessage = 'Product not found';
    } else if (errorString.contains('conflict') ||
        errorString.contains('409')) {
      userMessage = 'A product with this code already exists';
    } else if (errorString.contains('server') || errorString.contains('500')) {
      userMessage = 'Server error. Please try again later';
    } else if (errorString.contains('timeout')) {
      userMessage = 'Request timed out. Please try again';
    } else {
      userMessage = 'An error occurred while $operation. Please try again';
    }

    _errorMessage.value = userMessage;
    // Don't show snackbar here - HttpService already shows error snackbars for HTTP errors
    // This method is still useful for setting the error message state
  }

  @override
  void showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.BOTTOM,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );

  /// Show success message
  void _showSuccess(String message) {
    showSuccess(message);
  }

  @override
  void showSuccess(String message) => SnackbarServiceHelper.showSuccess(
    message,
    position: SnackPosition.BOTTOM,
    actionLabel: 'OK',
  );

  // New API-based methods
  @override
  Future<BarcodeModel> getProducts({int perPage = 10, int page = 1, bool forceRefresh = false}) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final token = await _getAuthToken();
      final result = await _useCase.getProducts(
        token,
        perPage: perPage,
        page: page,
        forceRefresh: forceRefresh,
      );

      // Update pagination state
      _currentPage.value = result.pagination?.page ?? page;
      _totalCount.value = result.pagination?.count ?? 0;
      _hasNextPage.value = result.pagination?.hasNext ?? false;
      _perPage.value = result.pagination?.perPage ?? perPage;

      // Update local cache for backward compatibility
      if (page == 1) {
        // First page - replace all products
        _products.value = result.result ?? <BarcodeResultModel>[];
      } else {
        // Additional pages - append products
        if ((result.result ?? []).isNotEmpty) {
          _products.addAll(result.result!);
        }
      }

      return result;
    } catch (e) {
      _handleError(e, 'loading products');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refresh products (load first page)
  @override
  Future<void> refreshProducts() async {
    await getProducts(perPage: _perPage.value, page: 1);
  }

  /// Load next page of products
  @override
  Future<void> loadNextPage() async {
    if (_hasNextPage.value && !_isLoading.value) {
      await getProducts(perPage: _perPage.value, page: _currentPage.value + 1);
    }
  }

  @override
  Future<BarcodeResultModel?> getProductById(String id) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      // For now, get from local cache since API doesn't have single product endpoint
      final product = _products.firstWhereOrNull((p) => p.id.toString() == id);
      return product;
    } catch (e) {
      _handleError(e, 'loading product');
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<BarcodeResultModel> createProduct(BarcodeResultModel product) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final token = await _getAuthToken();
      final result = await _useCase.createProduct(product, token);

      // Refresh the product list to get the latest data
      await refreshProducts();

      _showSuccess('Product created successfully');
      return result;
    } catch (e) {
      _handleError(e, 'creating product');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<BarcodeResultModel> updateProduct(
    String id,
    BarcodeResultModel product,
  ) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final token = await _getAuthToken();
      final result = await _useCase.updateProduct(id, product, token);

      // Update local cache
      final index = _products.indexWhere((p) => p.id.toString() == id);
      if (index != -1) {
        _products[index] = result;
      } else {
        // If not found in cache, refresh the list
        await refreshProducts();
      }

      _showSuccess('Product updated successfully');
      return result;
    } catch (e) {
      _handleError(e, 'updating product');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Show confirmation dialog using ShadCN UI
    final confirmed = await showShadDialog<bool>(
      context: Get.context!,
      builder: (context) => DeleteProductDialog(
        onCancel: () => Get.back(result: false),
        onConfirm: () => Get.back(result: true),
      ),
    );

    if (confirmed != true) return;
    
    _errorMessage.value = null;

    try {
      final token = await _getAuthToken();
      await _useCase.deleteProduct(id, token);

      // Instead of just removing from cache, refresh the entire list
      // to ensure pagination data is accurate
      await refreshProducts();

      _showSuccess('Product deleted successfully');
    } catch (e) {
      _handleError(e, 'deleting product');
      rethrow;
    } 
  }

  // Legacy methods for backward compatibility
  @override
  Future<List<BarcodeResultModel>> getAllProducts() async {
    try {
      final result = await getProducts();
      return result.result ?? <BarcodeResultModel>[];
    } catch (e) {
      log('[ProductsControllerImpl] Error in getAllProducts: $e');
      return <BarcodeResultModel>[];
    }
  }

  @override
  Future<bool> createProductLegacy(BarcodeResultModel product) async {
    try {
      await createProduct(product);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProductLegacy(BarcodeResultModel product) async {
    try {
      if (product.id == null) return false;
      await updateProduct(product.id.toString(), product);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProductLegacy(int id) async {
    try {
      await deleteProduct(id.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  List<BarcodeResultModel> filterProductsByCategory(String category) {
    if (category.isEmpty) return _products.toList();
    return _products
        .where(
          (product) =>
              product.trashType?.toLowerCase().contains(
                category.toLowerCase(),
              ) ??
              false,
        )
        .toList();
  }

  @override
  List<String> getAllCategories() {
    return _categories.toList();
  }

  @override
  Future<String> uploadImage(String imagePath) async {
    log('🔄 Controller: Processing image from path: $imagePath');

    try {
      if (kIsWeb) {
        // On web, FilePicker provides a blob URL, but we need to get the actual bytes
        // The presenter should pass the bytes directly for web
        log('🌐 Web platform: Converting to base64 (path-based approach not supported)');
        // For web, the presenter should use uploadImageWithBytes method instead
        throw UnsupportedError(
          'Web platform requires bytes-based upload. Use uploadImageWithBytes instead.'
        );
      } else {
        // For mobile/desktop platforms, read the file and convert to base64
        log('📱 Mobile/Desktop platform: Reading file from path');
        
        final file = File(imagePath);
        
        // Check if file exists
        if (!await file.exists()) {
          throw Exception('File not found at path: $imagePath');
        }
        
        // Get file name from path
        final fileName = imagePath.split('/').last;
        
        // Read file bytes
        final fileBytes = await file.readAsBytes();
        
        log('📊 File size: ${fileBytes.length} bytes');
        
        // Convert to base64 using our utility (async to prevent UI blocking)
        final base64String = await ImageBase64Converter.bytesToBase64(fileBytes, fileName);
        
        log('✅ Successfully converted to base64');
        log('🌐 Base64 string length: ${base64String.length}');
        
        return base64String;
      }
    } catch (e) {
      log('💥 Image upload error: $e');
      _handleError(e, 'uploading image');
      rethrow;
    }
  }
  
  @override
  Future<String> uploadImageWithBytes(Uint8List fileBytes, String fileName) async {
    try {
      log('🔄 Starting image upload with bytes...');
      log('📁 File name: $fileName');
      log('📊 File size: ${fileBytes.length} bytes');
      
      // Convert to base64 using our utility (async to prevent UI blocking)
      final base64String = await ImageBase64Converter.bytesToBase64(fileBytes, fileName);
      
      log('✅ Successfully converted to base64');
      log('🌐 Base64 string length: ${base64String.length}');
      
      return base64String;
    } catch (e) {
      log('💥 Image upload error: $e');
      _handleError(e, 'uploading image');
      rethrow;
    }
  }

  @override
  Future<bool> validateBarcode(String barcode) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));

      // Validate barcode format
      if (barcode.isEmpty) return false;

      // Check if it's a valid number
      if (int.tryParse(barcode) == null) return false;

      // Check common barcode lengths (8, 12, 13, 14 digits)
      final validLengths = [8, 12, 13, 14];
      if (!validLengths.contains(barcode.length)) return false;

      // Check if barcode already exists in current products
      final existingProduct = _products.firstWhereOrNull(
        (product) => product.code == barcode,
      );

      if (existingProduct != null) {
        _errorMessage.value = 'A product with this barcode already exists';
        return false;
      }

      return true;
    } catch (e) {
      log('Barcode validation error: $e');
      return false;
    }
  }

  @override
  Future<String> uploadCsvFile({Uint8List? fileBytes, String? fileName}) async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final token = await _getAuthToken();
      final result = await _useCase.uploadCsvFile(fileBytes: fileBytes, fileName: fileName, token: token);

      // Refresh the product list to get the latest data after bulk upload
      await refreshProducts();

      _showSuccess('CSV file uploaded successfully');
      return result;
    } catch (e) {
      _handleError(e, 'uploading CSV file');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:web/web.dart' as web;
import '../../../../../core/app/app_routes.dart';
import '../../../data/models/csv_template/index.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../data/models/barcode/index.dart';
import '../../../data/datasource/local/product_local_datasource.dart';
import '../../../utils/filename_extractor.dart';
import '../../../../../utils/helpers/snackbar_service.dart';
import '../../controllers/interface/product.dart';
import '../interface/product.dart';

class ProductsPresenterImpl extends GetxController
    implements ProductsPresenterInterface {
  final ProductsControllerInterface controller;
  final DashboardShellControllerInterface dashboardShellController;

  ProductsPresenterImpl({
    required this.controller,
    required this.dashboardShellController,
  });

  // Observable properties
  final RxList<BarcodeResultModel> _products = <BarcodeResultModel>[].obs;
  final RxList<BarcodeResultModel> _filteredProducts =
      <BarcodeResultModel>[].obs;
  final RxList<String> _categories = <String>[].obs;
  final RxString _selectedCategory = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;

  // Form properties
  final RxList<Map<String, String>> _formItems = <Map<String, String>>[].obs;
  final RxBool _isAddingItem = false.obs;
  final RxString _formTitle = ''.obs;
  final RxString _formBrand = ''.obs;
  final RxString _formDescription = ''.obs;
  final RxString _formImage = ''.obs;
  final RxString _formBarcode = ''.obs;
  final RxList<String> _formCategories = <String>[].obs;
  final RxBool _isFormValid = false.obs;
  final RxBool _isCreating = false.obs;
  final Rx<BarcodeResultModel?> _editingProduct = Rx<BarcodeResultModel?>(null);
  final _user = Rxn<UserAuthModel>();

  // Mobile preview properties
  final RxString _previewTitle = ''.obs;
  final RxString _previewBrand = ''.obs;
  final RxString _previewDescription = ''.obs;
  final RxString _previewImage = ''.obs;
  final RxString _previewBarcode = ''.obs;
  final RxList<String> _previewCategories = <String>[].obs;

  // In ProductsPresenterImpl, add these properties:
  final RxString _formHeaderImage = ''.obs;
  final RxList<String> _formCarouselImages = <String>[].obs;
  final RxString _formRecyclingImage = ''.obs;
  final RxList<String> _formLinkedRewards = <String>[].obs;

  // New item input state
  final RxString _newItemTitle = ''.obs;
  final RxString _newItemBarcode = ''.obs;

  // Edit item state
  final RxInt _editingItemIndex = (-1).obs;
  final RxString _editItemTitle = ''.obs;
  final RxString _editItemBarcode = ''.obs;

  // Barcode controller for single barcode input
  late final TextEditingController _barcodeController;

  // Text controllers for new item inputs
  late final TextEditingController _newItemTitleController;
  late final TextEditingController _newItemBarcodeController;

  // Text controllers for edit item inputs
  late final TextEditingController _editItemTitleController;
  late final TextEditingController _editItemBarcodeController;

  // New properties for improvements
  late final RxString _viewMode;

  final RxString _currentRoute = AppRoutes.productManagement.obs;
  
  // CSV upload dialog state
  final RxString _csvFileName = ''.obs;
  final RxString _csvFilePath = ''.obs;
  final Rx<Uint8List?> _csvFileBytes = Rx<Uint8List?>(null);
  final RxBool _isCsvUploading = false.obs;
  final RxBool _isDownloadingTemplate = false.obs;
  final RxBool _hasDownloadedTemplate = false.obs;
  final RxBool _hasSelectedCsvFile = false.obs;

  // Track original files from API to preserve filenames during editing
  final RxList<BarcodeResultFileModel> _originalFiles =
      <BarcodeResultFileModel>[].obs;
  
  // Image conversion loading states
  final RxBool _isConvertingHeaderImage = false.obs;
  final RxBool _isConvertingCarouselImage = false.obs;
  final RxBool _isConvertingRecyclingImage = false.obs;
  
  // Computed save button state
  late final RxBool _canSaveProduct;
  
  // Pagination properties
  final RxInt _currentPage = 1.obs;
  final RxInt _totalCount = 0.obs;
  final RxBool _hasNextPage = false.obs;
  final RxInt _perPage = 10.obs;

  @override
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  late RxString currentRoute = _currentRoute;
  @override
  void onNavigate(String value) =>
      dashboardShellController.handleMobileNavigation(value);
  @override
  void onLogout() => dashboardShellController.logout();
  @override
  void onToggle() => dashboardShellController.toggleSidebar();
  
  // Pagination getters
  @override
  RxInt get currentPage => _currentPage;
  @override
  RxInt get totalCount => _totalCount;
  @override
  RxBool get hasNextPage => _hasNextPage;
  @override
  RxInt get perPage => _perPage;

  // Add getters:
  @override
  RxList<Map<String, String>> get formItems => _formItems;

  @override
  RxBool get isAddingItem => _isAddingItem;
  @override
  RxString get formHeaderImage => _formHeaderImage;

  @override
  RxList<String> get formCarouselImages => _formCarouselImages;

  @override
  RxString get formRecyclingImage => _formRecyclingImage;

  @override
  RxList<String> get formLinkedRewards => _formLinkedRewards;

  // Getters
  @override
  RxList<BarcodeResultModel> get products => _products;
  @override
  RxList<BarcodeResultModel> get filteredProducts => _filteredProducts;
  @override
  RxList<String> get categories => _categories;
  @override
  RxString get selectedCategory => _selectedCategory;
  @override
  RxBool get isLoading => _isLoading;
  @override
  RxString get searchQuery => _searchQuery;
  @override
  RxString get formTitle => _formTitle;
  @override
  RxString get formBrand => _formBrand;
  @override
  RxString get formDescription => _formDescription;
  @override
  RxString get formBarcode => _formBarcode;
  @override
  RxList<String> get formCategories => _formCategories;
  @override
  RxBool get isFormValid => _isFormValid;
  @override
  RxBool get isCreating => _isCreating;
  @override
  Rx<BarcodeResultModel?> get editingProduct => _editingProduct;
  @override
  RxString get previewTitle => _previewTitle;
  @override
  RxString get previewBrand => _previewBrand;
  @override
  RxString get previewDescription => _previewDescription;
  @override
  RxString get previewImage => _previewImage;
  @override
  RxString get previewBarcode => _previewBarcode;
  @override
  RxList<String> get previewCategories => _previewCategories;
  @override
  RxString get newItemTitle => _newItemTitle;
  @override
  RxString get newItemBarcode => _newItemBarcode;
  @override
  UserAuthModel? get user => _user.value;

  // Barcode controller for single barcode input
  @override
  TextEditingController get barcodeController => _barcodeController;

  // Controllers for new item inputs
  @override
  TextEditingController get newItemTitleController => _newItemTitleController;
  @override
  TextEditingController get newItemBarcodeController =>
      _newItemBarcodeController;

  // Edit item getters
  @override
  RxInt get editingItemIndex => _editingItemIndex;
  @override
  RxString get editItemTitle => _editItemTitle;
  @override
  RxString get editItemBarcode => _editItemBarcode;
  @override
  TextEditingController get editItemTitleController => _editItemTitleController;
  @override
  TextEditingController get editItemBarcodeController =>
      _editItemBarcodeController;

  @override
  RxString get viewMode => _viewMode;
  
  // CSV upload dialog getters
  @override
  RxString? get csvFileName => _csvFileName;
  @override
  RxString? get csvFilePath => _csvFilePath;
  @override
  Rx<Uint8List?> get csvFileBytes => _csvFileBytes;
  @override
  RxBool get isCsvUploading => _isCsvUploading;
  @override
  RxBool get isDownloadingTemplate => _isDownloadingTemplate;
  @override
  RxBool get hasDownloadedTemplate => _hasDownloadedTemplate;
  @override
  RxBool get hasSelectedCsvFile => _hasSelectedCsvFile;

  // Image conversion loading state getters
  @override
  RxBool get isConvertingHeaderImage => _isConvertingHeaderImage;
  @override
  RxBool get isConvertingCarouselImage => _isConvertingCarouselImage;
  @override
  RxBool get isConvertingRecyclingImage => _isConvertingRecyclingImage;
  
  // Computed getter for save button disable logic
  @override
  RxBool get canSaveProduct => _canSaveProduct;

  @override
  void onInit() {
    super.onInit();

    loadUser();

    scaffoldKey = dashboardShellController.scaffoldKey;
    dashboardShellController.currentRoute.value = currentRoute.value;

    // Initialize view mode based on screen size
    _initializeViewMode();

    // Initialize computed save button state
    _canSaveProduct = false.obs;
    _updateCanSaveProduct();

    // Initialize text controllers
    _barcodeController = TextEditingController();
    _newItemTitleController = TextEditingController();
    _newItemBarcodeController = TextEditingController();
    _editItemTitleController = TextEditingController();
    _editItemBarcodeController = TextEditingController();

    // Setup listeners for reactive updates
    _barcodeController.addListener(() {
      // Prevent infinite loops by checking if values are different
      if (_formBarcode.value != _barcodeController.text) {
        _formBarcode.value = _barcodeController.text;
        updatePreview();
        _validateForm();
        log('Barcode controller updated: ${_barcodeController.text}');
      }
    });

    _newItemTitleController.addListener(() {
      _newItemTitle.value = _newItemTitleController.text;
    });

    _newItemBarcodeController.addListener(() {
      _newItemBarcode.value = _newItemBarcodeController.text;
    });

    _editItemTitleController.addListener(() {
      _editItemTitle.value = _editItemTitleController.text;
    });

    _editItemBarcodeController.addListener(() {
      _editItemBarcode.value = _editItemBarcodeController.text;
    });

    loadProducts();
    _categories.addAll(controller.getAllCategories());

    // Setup form validation for fields that might be updated directly
    ever(_formTitle, (_) => _validateForm());
    ever(_formBrand, (_) => _validateForm());
    ever(_formDescription, (_) => _validateForm());
    ever(_formBarcode, (_) => _validateForm());
    ever(_formCategories, (_) => _validateForm());
    // Images are now optional, so no validation triggers needed for images
    // Legacy fields still monitored for compatibility
    ever(_formHeaderImage, (_) => _validateForm());
    ever(_formImage, (_) => _validateForm());
    ever(_formItems, (_) => _validateForm());
    ever(_formItems, (_) => updatePreview());

    // Setup reactive listeners for loading states to update canSaveProduct
    ever(_isConvertingHeaderImage, (_) => _updateCanSaveProduct());
    ever(_isConvertingCarouselImage, (_) => _updateCanSaveProduct());
    ever(_isConvertingRecyclingImage, (_) => _updateCanSaveProduct());
    ever(_isLoading, (_) => _updateCanSaveProduct());
    ever(_isFormValid, (_) => _updateCanSaveProduct());

    // Setup real-time preview updates for fields that might be updated directly
    ever(_formTitle, (_) => updatePreview());
    ever(_formBrand, (_) => updatePreview());
    ever(_formDescription, (_) => updatePreview());
    ever(_formHeaderImage, (_) => updatePreview());
    ever(_formCarouselImages, (_) => updatePreview());
    ever(_formRecyclingImage, (_) => updatePreview());
    ever(_formImage, (_) => updatePreview());
    ever(_formBarcode, (_) => updatePreview());
    ever(_formCategories, (_) => updatePreview());
  }

  @override
  void onClose() {
    _barcodeController.dispose();
    _newItemTitleController.dispose();
    _newItemBarcodeController.dispose();
    _editItemTitleController.dispose();
    _editItemBarcodeController.dispose();
    super.onClose();
  }

  Future<void> loadUser() async {
    try {
      final user = await AuthCacheDataSource.instance.getUserAuth();
      _user.value = user;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> fetchImageAsBase64(String imageUrl) async {
    try {
      // Use Corsfix CORS proxy - free for development with 60 requests/minute
      final corsProxyUrl = 'https://proxy.corsfix.com/?$imageUrl';  

      final response = await http.get(Uri.parse(corsProxyUrl));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final base64String = base64Encode(bytes);
        return 'data:image/jpeg;base64,$base64String';
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching image as base64: $e');
      // Return original URL as fallback
      return imageUrl;
    }
  }

  @override
  Future<void> loadProducts({bool forceRefresh = false}) async {
    _isLoading.value = true;
    try {
      final result = await controller.getProducts(
        perPage: _perPage.value,
        page: _currentPage.value,
        forceRefresh: forceRefresh,
      );
      
      // Update pagination state with safety checks
      if (result.pagination != null) {
        _totalCount.value = result.pagination!.count ?? 0;
        _hasNextPage.value = result.pagination!.hasNext ?? false;
        _perPage.value = result.pagination!.perPage ?? 10;
        
        // Calculate safe current page to prevent state inconsistency
        final apiPage = result.pagination!.page ?? 1;
        final calculatedTotalPages = _totalCount.value > 0 
          ? ((_totalCount.value / _perPage.value).ceil()) 
          : 1;
        
        // Ensure current page is within valid range
        _currentPage.value = apiPage.clamp(1, calculatedTotalPages);
        
        log('[ProductsPresenterImpl] Pagination updated - Page: ${_currentPage.value}/$calculatedTotalPages, Count: ${_totalCount.value}');
      }
      
      // Update products
      final productList = result.result ?? <BarcodeResultModel>[];
      _products.assignAll(productList);

      // Use regular for loop instead of forEach
      for (var product in _products) {
        if (product.files != null) {
          for (var file in product.files!) {
            if (file.url != null) {
              try {
                log('[before] fetching image as base64: ${file.url}');
                // file.url = await fetchImageAsBase64(file.url!);
                log('[after] fetching image as base64 success');
              } catch (e) {
                log('[error] fetching image as base64: $e');
              }
            }
          }
        }
      }

      _filteredProducts.assignAll(productList);
    } catch (e) {
      log('[ProductsPresenterImpl] Error loading products: $e');
      // Error handling is done by the controller
    } finally {
      _isLoading.value = false;
    }
  }
  
  @override
  Future<void> goToPage(int page) async {
    if (page != _currentPage.value && page > 0) {
      _currentPage.value = page;
      await loadProducts();
    }
  }
  
  
  @override
  Future<void> refreshProducts() async {
    try {
      log('[ProductsPresenter] Starting refresh - clearing cache');
      _isLoading.value = true;

      // Clear cache first
      await ProductLocalDataSource.instance.clearCache();
      log('[ProductsPresenter] Cache cleared');

      // Reset to first page
      _currentPage.value = 1;

      // Fetch fresh data with forceRefresh flag
      await loadProducts(forceRefresh: true);

      log('[ProductsPresenter] Refresh complete');
    } catch (e) {
      log('[ProductsPresenter] Refresh error: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void filterProducts(String category) {
    _selectedCategory.value = category;
    _applyFilters();
  }

  @override
  void searchProducts(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  void _initializeViewMode() {
    // Set default view mode based on screen size
    final screenWidth = Get.width;
    final isMobileOrTablet = screenWidth < 1200;
    _viewMode = (isMobileOrTablet ? 'list' : 'grid').obs;
  }

  void _applyFilters() {
    var filtered = _products.toList();

    // Filter by category
    if (_selectedCategory.value.isNotEmpty) {
      filtered = controller.filterProductsByCategory(_selectedCategory.value);
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (product) =>
                    (product.name?.toLowerCase().contains(
                          _searchQuery.value.toLowerCase(),
                        ) ??
                        false) ||
                    (product.instructions?.toLowerCase().contains(
                          _searchQuery.value.toLowerCase(),
                        ) ??
                        false) ||
                    (product.code?.contains(_searchQuery.value) ?? false),
              )
              .toList();
    }

    _filteredProducts.assignAll(filtered);
  }

  @override
  void startCreate() {
    _clearForm();
    _editingProduct.value = null;
    _isCreating.value = true;
    updatePreview();
    update();
  }

  @override
  void startEdit(BarcodeResultModel product) {
    _editingProduct.value = product;
    _isCreating.value = true;
    _formTitle.value = product.name ?? '';
    _formBrand.value = product.brand ?? '';
    _formDescription.value = product.instructions ?? '';
    _formHeaderImage.value = product.headerImage ?? '';
    _formCarouselImages.assignAll(product.carouselImages);
    _formRecyclingImage.value = product.productDetailsImage ?? '';

    // Store original files to preserve filenames from API
    _originalFiles.clear();
    if (product.files != null) {
      _originalFiles.addAll(product.files!);
      log(
        'Edit started: preserved ${_originalFiles.length} original files with filenames',
      );
    }

    // Sync both barcode state and controller for editing
    _formBarcode.value = product.code ?? '';
    _barcodeController.text = product.code ?? '';

    // Handle items - since new model doesn't have items, initialize empty
    _formItems.clear();

    // Handle categories - new model uses trashType as single string
    _formCategories.clear();
    if (product.trashType != null) {
      _formCategories.add(product.trashType!);
    }

    // Handle linked rewards - not in new model, initialize empty
    _formLinkedRewards.clear();

    log('Edit started: barcode set to ${product.code}');
    updatePreview();
  }

  @override
  void updateFormField(String field, dynamic value) {
    switch (field) {
      case 'title':
        _formTitle.value = value.toString();
        break;
      case 'brand':
        _formBrand.value = value.toString();
        break;
      case 'description':
        _formDescription.value = value.toString();
        break;
      case 'image':
        // Legacy image field - use as header image
        _formImage.value = value.toString();
        if (_formHeaderImage.value.isEmpty) {
          _formHeaderImage.value = value.toString();
        }
        break;
      case 'headerImage':
        _formHeaderImage.value = value.toString();
        break;
      case 'carouselImages':
        if (value is List<String>) {
          _formCarouselImages.assignAll(value);
        }
        break;
      case 'recyclingImage':
        _formRecyclingImage.value = value.toString();
        break;
      case 'barcode':
        _formBarcode.value = value.toString();
        // Sync controller if values are different to prevent conflicts
        if (_barcodeController.text != value.toString()) {
          _barcodeController.text = value.toString();
        }
        break;
      case 'categories':
        if (value is List<String>) {
          _formCategories.assignAll(value);
        }
        break;
      case 'category':
        // Handle single category selection for trashType
        _formCategories.clear();
        if (value != null && value.toString().isNotEmpty) {
          _formCategories.add(value.toString());
        }
        break;
      case 'linkedRewards':
        if (value is List<String>) {
          _formLinkedRewards.assignAll(value);
        }
        break;
    }
    // Ensure preview is updated whenever any field changes
    updatePreview();
    _validateForm();
  }

  @override
  Future<void> saveProduct() async {
    if (!_isFormValid.value) {
      // Show specific validation message to help user understand what's missing
      SnackbarServiceHelper.showWarning(
        validationMessage,
        position: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;
    
    // Show notification that conversion is starting (especially for multiple images)
    if (_formHeaderImage.value.isNotEmpty || 
        _formCarouselImages.isNotEmpty || 
        _formRecyclingImage.value.isNotEmpty) {
      SnackbarServiceHelper.showInfo(
        'Processing images and saving product, please wait...',
        position: SnackPosition.BOTTOM,
      );
    }
    
    try {
      // Create uploadFiles list following ImageDisplayHelper business rules
      List<BarcodeResultFileModel> uploadFiles = [];

      // Add header image first (if provided)
      if (_formHeaderImage.value.isNotEmpty) {
        uploadFiles.add(_createFileModel(_formHeaderImage.value));
      }

      // Add carousel images in the middle
      for (String carouselImage in _formCarouselImages) {
        if (carouselImage.isNotEmpty) {
          uploadFiles.add(_createFileModel(carouselImage));
        }
      }

      // Add recycling image last (if provided and different from existing images)
      if (_formRecyclingImage.value.isNotEmpty &&
          !uploadFiles.any((file) => file.url == _formRecyclingImage.value)) {
        uploadFiles.add(_createFileModel(_formRecyclingImage.value));
      }

      // Create product with new API-compatible structure
      final product = BarcodeResultModel(
        id: _editingProduct.value?.id,
        name: _formTitle.value.isNotEmpty ? _formTitle.value : null,
        code: _formBarcode.value.isNotEmpty ? _formBarcode.value : null,
        brand: _formBrand.value.isNotEmpty ? _formBrand.value : null,
        instructions:
            _formDescription.value.isNotEmpty ? _formDescription.value : null,
        trashType: _formCategories.isNotEmpty ? _formCategories.first : null,
        files: uploadFiles.isNotEmpty ? uploadFiles : null,
      );

      try {
        if (_editingProduct.value != null) {
          // Update existing product
          await controller.updateProduct(
            _editingProduct.value!.id.toString(),
            product,
          );
        } else {
          // Create new product
          await controller.createProduct(product);
        }

        // Success handling is done in controller
        await loadProducts();
        _isCreating.value = false;
        cancelEdit();
      } catch (e) {
        // Error handling is done in controller
        log('[ProductsPresenterImpl] Save product error: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      // Store current state for recovery if needed
      final currentPageBeforeDeletion = _currentPage.value;
      final totalCountBeforeDeletion = _totalCount.value;
      
      log('[ProductsPresenterImpl] Deleting product $id - Current page: $currentPageBeforeDeletion, Total: $totalCountBeforeDeletion');
      
      // Use the new API method
      await controller.deleteProduct(id.toString());
      
      // Check if we need to adjust current page after deletion
      // If we were on the last page and it might become empty, go to previous page
      final estimatedNewTotal = totalCountBeforeDeletion - 1;
      final estimatedNewTotalPages = estimatedNewTotal > 0 
        ? ((estimatedNewTotal / _perPage.value).ceil()) 
        : 1;
      
      if (currentPageBeforeDeletion > estimatedNewTotalPages && estimatedNewTotalPages > 0) {
        _currentPage.value = estimatedNewTotalPages;
        log('[ProductsPresenterImpl] Adjusted current page to $estimatedNewTotalPages after deletion');
      }
      
      await loadProducts();
    } catch (e) {
      // Error handling is now done in the controller
      log('[ProductsPresenterImpl] Delete product error: $e');
    } 
  }

  @override
  void cancelEdit() {
    _clearForm();
    _editingProduct.value = null;
    _isCreating.value = false;
  }

  @override
  Future<void> uploadImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null) {
        final file = result.files.single;
        String imageUrl;
        
        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            imageUrl = await controller.uploadImageWithBytes(
              file.bytes!,
              file.name,
            );
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            imageUrl = await controller.uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }
        
        _formHeaderImage.value = imageUrl;
        controller.showSuccess('Header image uploaded successfully');
      }
    } catch (e) {
      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') && !e.toString().contains('400') && 
          !e.toString().contains('404') && !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        controller.showError('Failed to process image file');
      }
    }
  }

  @override
  void updatePreview() {
    _previewTitle.value =
        _formTitle.value.isEmpty ? 'Product Name' : _formTitle.value;
    _previewBrand.value =
        _formBrand.value.isEmpty ? 'Brand Name' : _formBrand.value;
    _previewDescription.value =
        _formDescription.value.isEmpty
            ? 'Product description will appear here...'
            : _formDescription.value;
    // Update to use the new image field structure
    _previewImage.value = _formHeaderImage.value;
    // Use direct barcode field instead of items
    _previewBarcode.value =
        _formBarcode.value.isEmpty ? '0000000000000' : _formBarcode.value;
    _previewCategories.assignAll(_formCategories);

    log('Preview updated: barcode=${_previewBarcode.value}');
  }

  /// Creates a BarcodeResultFileModel with proper filename handling
  /// Preserves original filenames from API or generates new ones for uploads
  BarcodeResultFileModel _createFileModel(String url) {
    // Check if this URL matches an original file (preserves API filenames)
    final originalFile = _originalFiles.firstWhereOrNull(
      (file) => file.url == url,
    );

    if (originalFile != null) {
      log(
        '[ProductsPresenterImpl] Using original file with filename: ${originalFile.fileName}',
      );
      return originalFile;
    }

    // This is a new upload, generate filename
    final fileData = FilenameExtractor.createFileModelData(url: url);
    log(
      '[ProductsPresenterImpl] Created new file model with generated filename: ${fileData['fileName']}',
    );

    return BarcodeResultFileModel(
      url: fileData['url'],
      fileName: fileData['fileName'],
    );
  }

  void _clearForm() {
    _formTitle.value = '';
    _formBrand.value = '';
    _formDescription.value = '';
    _formImage.value = '';
    _formHeaderImage.value = '';
    _formCarouselImages.clear();
    _formRecyclingImage.value = '';
    _formBarcode.value = '';
    _formCategories.clear();
    _formLinkedRewards.clear();
    _formItems.clear();
    _isAddingItem.value = false;

    // Clear original files tracking
    _originalFiles.clear();

    // Clear all text controllers to prevent UI state persistence
    _barcodeController.clear();
    _newItemTitleController.clear();
    _newItemBarcodeController.clear();
    _editItemTitleController.clear();
    _editItemBarcodeController.clear();

    log('Form cleared: barcode controller and reactive variables reset');
  }

  void _validateForm() {
    // Enhanced validation: Check all required fields
    final isTitleValid = _formTitle.value.trim().isNotEmpty;
    final isBrandValid = _formBrand.value.trim().isNotEmpty;
    final isDescriptionValid = _formDescription.value.trim().isNotEmpty;
    final isBarcodeValid = _formBarcode.value.trim().isNotEmpty;
    final isCategoryValid = _formCategories.isNotEmpty;
    
    // Images are now optional - no image requirements
    
    _isFormValid.value = isTitleValid &&
                        isBrandValid &&
                        isDescriptionValid &&
                        isBarcodeValid &&
                        isCategoryValid;

    log(
      'Enhanced form validation: '
      'title=$isTitleValid, '
      'brand=$isBrandValid, '
      'description=$isDescriptionValid, '
      'barcode=$isBarcodeValid, '
      'category=$isCategoryValid (${_formCategories.isNotEmpty ? _formCategories.first : 'none'}), '
      'isValid=${_isFormValid.value}',
    );
  }

  void _updateCanSaveProduct() {
    final canSave = !_isConvertingHeaderImage.value && 
                    !_isConvertingCarouselImage.value && 
                    !_isConvertingRecyclingImage.value &&
                    !_isLoading.value &&
                    _isFormValid.value;
    _canSaveProduct.value = canSave;
    
    log('Can save product: $canSave (converting: ${_isConvertingHeaderImage.value || _isConvertingCarouselImage.value || _isConvertingRecyclingImage.value}, loading: ${_isLoading.value}, valid: ${_isFormValid.value})');
  }

  // Enhanced validation getters for individual field validation
  @override
  bool get isTitleValid => _formTitle.value.trim().isNotEmpty;

  @override
  bool get isBrandValid => _formBrand.value.trim().isNotEmpty;

  @override
  bool get isDescriptionValid => _formDescription.value.trim().isNotEmpty;

  @override
  bool get isBarcodeValid => _formBarcode.value.trim().isNotEmpty;

  @override
  bool get isCategoryValid => _formCategories.isNotEmpty;

  @override
  bool get hasRequiredImages {
    // Images are now optional, so this always returns true
    return true;
  }

  @override
  String get validationMessage {
    final missingFields = <String>[];
    
    if (!isTitleValid) missingFields.add('Product Title');
    if (!isBrandValid) missingFields.add('Brand');
    if (!isDescriptionValid) missingFields.add('Description');
    if (!isBarcodeValid) missingFields.add('Barcode');
    if (!isCategoryValid) missingFields.add('Category');
    // Removed image requirement from validation message
    
    if (missingFields.isEmpty) {
      return 'All required fields are filled';
    } else if (missingFields.length == 1) {
      return 'Missing: ${missingFields.first}';
    } else {
      return 'Missing: ${missingFields.join(', ')}';
    }
  }

  // Item management methods
  @override
  void startAddingItem() {
    // Cancel edit mode if active
    if (_editingItemIndex.value != -1) {
      cancelEditingItem();
    }

    _isAddingItem.value = true;
    _newItemTitle.value = '';
    _newItemBarcode.value = '';
    _newItemTitleController.clear();
    _newItemBarcodeController.clear();
  }

  @override
  void cancelAddingItem() {
    _isAddingItem.value = false;
    _newItemTitle.value = '';
    _newItemBarcode.value = '';
    _newItemTitleController.clear();
    _newItemBarcodeController.clear();
  }

  @override
  void addItem(String title, String barcode) {
    if (title.isNotEmpty && barcode.isNotEmpty) {
      _formItems.add({'title': title, 'barcode': barcode});
      _isAddingItem.value = false;
      _newItemTitle.value = '';
      _newItemBarcode.value = '';
      _newItemTitleController.clear();
      _newItemBarcodeController.clear();
    }
  }

  @override
  void addItemFromState() {
    addItem(_newItemTitle.value, _newItemBarcode.value);
  }

  @override
  void removeItem(int index) {
    if (index >= 0 && index < _formItems.length) {
      _formItems.removeAt(index);
    }
  }

  @override
  void updateNewItemTitle(String title) {
    _newItemTitle.value = title;
    // Update controller if it's not already synced
    if (_newItemTitleController.text != title) {
      _newItemTitleController.text = title;
    }
  }

  @override
  void updateNewItemBarcode(String barcode) {
    _newItemBarcode.value = barcode;
    // Update controller if it's not already synced
    if (_newItemBarcodeController.text != barcode) {
      _newItemBarcodeController.text = barcode;
    }
  }

  @override
  void handleBarcodeInput(String input) {
    // Filter out non-numeric characters
    var filtered = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 13 digits
    if (filtered.length > 13) {
      filtered = filtered.substring(0, 13);
    }

    // Update the barcode value
    updateNewItemBarcode(filtered);
  }

  @override
  bool isNewItemValid() {
    return _newItemTitle.value.isNotEmpty &&
        _newItemBarcode.value.isNotEmpty &&
        _newItemBarcode.value.length >= 8; // Minimum barcode length
  }

  // Edit item management methods
  @override
  void startEditingItem(int index) {
    if (index >= 0 && index < _formItems.length) {
      // Cancel adding mode if active
      if (_isAddingItem.value) {
        cancelAddingItem();
      }

      _editingItemIndex.value = index;
      final item = _formItems[index];
      _editItemTitle.value = item['title'] ?? '';
      _editItemBarcode.value = item['barcode'] ?? '';
      _editItemTitleController.text = _editItemTitle.value;
      _editItemBarcodeController.text = _editItemBarcode.value;
    }
  }

  @override
  void cancelEditingItem() {
    _editingItemIndex.value = -1;
    _editItemTitle.value = '';
    _editItemBarcode.value = '';
    _editItemTitleController.clear();
    _editItemBarcodeController.clear();
  }

  @override
  void updateEditItem(String title, String barcode) {
    if (_editingItemIndex.value >= 0 &&
        _editingItemIndex.value < _formItems.length &&
        title.isNotEmpty &&
        barcode.isNotEmpty) {
      _formItems[_editingItemIndex.value] = {
        'title': title,
        'barcode': barcode,
      };
      cancelEditingItem();
    }
  }

  @override
  void updateEditItemFromState() {
    updateEditItem(_editItemTitle.value, _editItemBarcode.value);
  }

  @override
  void updateEditItemTitle(String title) {
    _editItemTitle.value = title;
    // Update controller if it's not already synced
    if (_editItemTitleController.text != title) {
      _editItemTitleController.text = title;
    }
  }

  @override
  void updateEditItemBarcode(String barcode) {
    _editItemBarcode.value = barcode;
    // Update controller if it's not already synced
    if (_editItemBarcodeController.text != barcode) {
      _editItemBarcodeController.text = barcode;
    }
  }

  @override
  void handleEditBarcodeInput(String input) {
    // Filter out non-numeric characters
    var filtered = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 13 digits
    if (filtered.length > 13) {
      filtered = filtered.substring(0, 13);
    }

    // Update the barcode value
    updateEditItemBarcode(filtered);
  }

  @override
  bool isEditItemValid() {
    return _editItemTitle.value.isNotEmpty &&
        _editItemBarcode.value.isNotEmpty &&
        _editItemBarcode.value.length >= 8; // Minimum barcode length
  }

  // In ProductsPresenterImpl, add:
  @override
  Future uploadHeaderImage() async {
    try {
      log('🔄 Starting header image upload...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null) {
        log('📁 File selected: ${result.files.single.name}');
        final file = result.files.single;
        
        // Set loading state and show conversion notification
        _isConvertingHeaderImage.value = true;
        SnackbarServiceHelper.showInfo(
          'Converting image to base64, please wait...',
          position: SnackPosition.BOTTOM,
        );
        
        String imageUrl;
        
        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            log('🌐 Web platform: Using bytes for upload');
            imageUrl = await controller.uploadImageWithBytes(
              file.bytes!,
              file.name,
            );
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            log('📱 Mobile/Desktop platform: Using file path');
            imageUrl = await controller.uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }
        
        log('🌐 Image URL received: ${imageUrl.substring(0, 50)}...');

        _formHeaderImage.value = imageUrl;
        log('✅ _formHeaderImage updated');

        updatePreview();
        log('🔄 Preview updated');

        // Clear loading state and show success
        _isConvertingHeaderImage.value = false;
        SnackbarServiceHelper.showSuccess(
          'Header image uploaded successfully',
          position: SnackPosition.BOTTOM,
          actionLabel: 'OK',
        );
      } else {
        log('❌ No file selected');
        _isConvertingHeaderImage.value = false;
      }
    } catch (e) {
      log('💥 Upload error: $e');
      // Clear loading state on error
      _isConvertingHeaderImage.value = false;
      
      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') && !e.toString().contains('400') && 
          !e.toString().contains('404') && !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        SnackbarServiceHelper.showError(
          'Failed to process header image',
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Future uploadCarouselImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null) {
        final file = result.files.single;
        
        // Set loading state and show conversion notification
        _isConvertingCarouselImage.value = true;
        SnackbarServiceHelper.showInfo(
          'Converting carousel image to base64, please wait...',
          position: SnackPosition.BOTTOM,
        );
        
        String imageUrl;
        
        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            imageUrl = await controller.uploadImageWithBytes(
              file.bytes!,
              file.name,
            );
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            imageUrl = await controller.uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }
        
        final updatedList = _formCarouselImages.toList();
        updatedList.add(imageUrl);
        _formCarouselImages.assignAll(updatedList);
        updatePreview();
        
        // Clear loading state and show success
        _isConvertingCarouselImage.value = false;
        SnackbarServiceHelper.showSuccess(
          'Carousel image uploaded successfully',
          position: SnackPosition.BOTTOM,
          actionLabel: 'OK',
        );
      } else {
        _isConvertingCarouselImage.value = false;
      }
    } catch (e) {
      // Clear loading state on error
      _isConvertingCarouselImage.value = false;
      
      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') && !e.toString().contains('400') && 
          !e.toString().contains('404') && !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        SnackbarServiceHelper.showError(
          'Failed to process carousel image',
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Future uploadRecyclingImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null) {
        final file = result.files.single;
        
        // Set loading state and show conversion notification
        _isConvertingRecyclingImage.value = true;
        SnackbarServiceHelper.showInfo(
          'Converting recycling image to base64, please wait...',
          position: SnackPosition.BOTTOM,
        );
        
        String imageUrl;
        
        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            imageUrl = await controller.uploadImageWithBytes(
              file.bytes!,
              file.name,
            );
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            imageUrl = await controller.uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }
        
        _formRecyclingImage.value = imageUrl;
        updatePreview();
        
        // Clear loading state and show success
        _isConvertingRecyclingImage.value = false;
        SnackbarServiceHelper.showSuccess(
          'Recycling image uploaded successfully',
          position: SnackPosition.BOTTOM,
          actionLabel: 'OK',
        );
      } else {
        _isConvertingRecyclingImage.value = false;
      }
    } catch (e) {
      // Clear loading state on error
      _isConvertingRecyclingImage.value = false;
      
      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') && !e.toString().contains('400') && 
          !e.toString().contains('404') && !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        SnackbarServiceHelper.showError(
          'Failed to process recycling image',
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Rewards management methods
  @override
  void addLinkedReward(String rewardId) {
    if (!_formLinkedRewards.contains(rewardId)) {
      _formLinkedRewards.add(rewardId);
      // Visual feedback is provided by the dialog update, no need for snackbar
    }
  }

  @override
  void removeLinkedReward(String rewardId) {
    _formLinkedRewards.remove(rewardId);
    // Visual feedback is provided by the dialog update, no need for snackbar
  }

  @override
  void showRewardsSelectionDialog() {
    // Mock rewards data - this would come from a rewards service
    final List<Map<String, String>> mockRewards = [
      {
        'id': 'reward_1',
        'name': '10% Discount Coupon',
        'description': 'Save 10% on your next purchase',
      },
      {
        'id': 'reward_2',
        'name': 'Free Shipping Voucher',
        'description': 'Free shipping for orders over €25',
      },
      {
        'id': 'reward_3',
        'name': 'Eco Points (50)',
        'description': '50 points towards eco-friendly products',
      },
      {
        'id': 'reward_4',
        'name': 'Gift Card (€5)',
        'description': '€5 gift card for sustainable brands',
      },
      {
        'id': 'reward_5',
        'name': 'Green Badge',
        'description': 'Digital badge for environmental achievement',
      },
    ];

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.green),
                SizedBox(width: 8),
                Text('Link Rewards'),
                Spacer(),
                Text(
                  '(Coming Soon)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  Text(
                    'Select rewards to link with this recycling product. Users will earn these rewards when they recycle this product.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mockRewards.length,
                      itemBuilder: (context, index) {
                        final reward = mockRewards[index];
                        final isLinked = _formLinkedRewards.contains(
                          reward['id'],
                        );

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isLinked ? Colors.green : Colors.grey[300],
                              child: Icon(
                                isLinked ? Icons.check : Icons.card_giftcard,
                                color:
                                    isLinked ? Colors.white : Colors.grey[600],
                              ),
                            ),
                            title: Text(
                              reward['name'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(reward['description'] ?? ''),
                            trailing: Switch(
                              value: isLinked,
                              onChanged: (value) {
                                if (value) {
                                  addLinkedReward(reward['id'] ?? '');
                                } else {
                                  removeLinkedReward(reward['id'] ?? '');
                                }
                                setState(() {}); // Update the dialog UI
                              },
                              activeColor: Colors.green,
                            ),
                            onTap: () {
                              if (isLinked) {
                                removeLinkedReward(reward['id'] ?? '');
                              } else {
                                addLinkedReward(reward['id'] ?? '');
                              }
                              setState(() {}); // Update the dialog UI
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.showSuccess('Linked ${_formLinkedRewards.length} reward(s) to this product');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  // New methods for improvements
  @override
  void toggleViewMode(String mode) {
    _viewMode.value = mode;
  }

  @override
  Future<void> duplicateProduct(BarcodeResultModel product) async {
    try {
      // Create a copy of the product with new name and no ID
      final duplicatedProduct = BarcodeResultModel(
        name: '${product.name} (Copy)',
        code: product.code,
        brand: product.brand,
        instructions: product.instructions,
        trashType: product.trashType,
        ecoGrade: product.ecoGrade,
        co2Packaging: product.co2Packaging,
        mainMaterial: product.mainMaterial,
        files: product.files, // Keep the same files
        id: null, // No ID for new product
      );

      log(
        '[ProductsPresenterImpl] Duplicate product: ${duplicatedProduct.toJson()}',
      );

      await controller.createProduct(duplicatedProduct);
      await loadProducts();
    } catch (e) {
      // Error handling is done in controller
      log('[ProductsPresenterImpl] Duplicate product error: $e');
    }
  }

  @override
  Future<void> uploadCsvFile({Uint8List? fileBytes, String? fileName}) async {
    _isLoading.value = true;
    try {
      log('[ProductsPresenterImpl] Uploading CSV file: $fileBytes');

      // Call controller to upload CSV file
      final result = await controller.uploadCsvFile(
        fileBytes: fileBytes,
        fileName: fileName,
      );

      log('[ProductsPresenterImpl] CSV upload successful: $result');

      // Refresh products list to show newly uploaded products
      await loadProducts();

      controller.showSuccess('CSV file "$fileName" uploaded successfully');
    } catch (e) {
      log('[ProductsPresenterImpl] CSV upload error: $e');
      // HTTP errors are already handled by HttpService
      // Don't show duplicate error snackbar
    } finally {
      _isLoading.value = false;
    }
  }
  
  @override
  Future<void> downloadCsvTemplate() async {
    _isDownloadingTemplate.value = true;
    try {
      // Fetch active template from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('csv_template')
          .where('is_active', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('No active template found');
      }

      // Parse template model
      final templateModel = CsvTemplateModel.fromJson(snapshot.docs.first.data());
      
      if (templateModel.storagePath == null) {
        throw Exception('Template storage path not found');
      }

      log('[CSV Download] Storage path: ${templateModel.storagePath}');
      log('[CSV Download] File name: ${templateModel.fileName}');

      // Use Firebase Storage SDK to get proper download URL with token
      log('[CSV Download] Getting download URL via Firebase Storage SDK...');
      final storageRef = FirebaseStorage.instance.ref(templateModel.storagePath!);
      final downloadUrl = await storageRef.getDownloadURL();
      log('[CSV Download] Download URL with token: ${downloadUrl.substring(0, 80)}...');

      // Download the file
      log('[CSV Download] Making HTTP request...');
      final response = await http.get(Uri.parse(downloadUrl));
      log('[CSV Download] HTTP Status: ${response.statusCode}');
      log('[CSV Download] Response headers: ${response.headers}');
      if (response.statusCode != 200) {
        log('[CSV Download] Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create download link
        if (kIsWeb) {
          final blob = web.Blob([bytes.toJS].toJS);
          final url = web.URL.createObjectURL(blob);
          final anchor = web.HTMLAnchorElement()
            ..href = url
            ..download = templateModel.fileName ?? 'template.csv';
          anchor.click();
          
          web.URL.revokeObjectURL(url);
        }
        
        _hasDownloadedTemplate.value = true;
        
        controller.showSuccess('Template downloaded successfully');
      } else {
        throw Exception('Failed to download template');
      }
    } catch (e) {
      log('Error downloading template: $e');
      // HTTP errors are already handled by HttpService
      // Don't show duplicate error snackbar
    } finally {
      _isDownloadingTemplate.value = false;
    }
  }
  
  @override
  Future<void> pickCsvFile() async {
    _isCsvUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        _csvFileName.value = file.name;
        _csvFileBytes.value = file.bytes;
        _csvFilePath.value = file.path ?? '';
        _hasSelectedCsvFile.value = true;
        
        log('[ProductsPresenterImpl] File selected: ${file.name}');
        log('[ProductsPresenterImpl] File size: ${file.size} bytes');
      }
    } catch (e) {
      controller.showError('Error selecting file: $e');
    } finally {
      _isCsvUploading.value = false;
    }
  }
  
  @override
  void clearCsvSelection() {
    _csvFileName.value = '';
    _csvFilePath.value = '';
    _csvFileBytes.value = null;
    _hasSelectedCsvFile.value = false;
    _hasDownloadedTemplate.value = false;
  }
  
  // Pagination helper methods
  @override
  int getTotalPages() {
    return _totalCount.value > 0 
      ? (_totalCount.value / _perPage.value).ceil() 
      : 1;
  }
  
  @override
  bool getHasPrevious() {
    return _currentPage.value > 1;
  }
  
  @override
  int getSafeCurrentPage() {
    return _currentPage.value.clamp(1, getTotalPages());
  }
  
}

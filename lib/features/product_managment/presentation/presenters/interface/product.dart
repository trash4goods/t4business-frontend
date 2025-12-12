import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_auth_model.dart';
import '../../../data/models/barcode/index.dart';

abstract class ProductsPresenterInterface extends GetxController {
  // global from parent DashboardShell
  GlobalKey<ScaffoldState> get scaffoldKey;
  RxString get currentRoute;
  void onNavigate(String route);
  void onLogout();
  void onToggle();
  // Observable properties
  RxList<BarcodeResultModel> get products;
  RxList<BarcodeResultModel> get filteredProducts;
  RxList<String> get categories;
  RxString get selectedCategory;
  RxBool get isLoading;
  RxString get searchQuery;
  UserAuthModel? get user;

  // Form properties for create/edit
  RxString get formTitle;
  RxString get formBrand;
  RxString get formDescription;
  RxString get formBarcode;
  RxList<String> get formCategories;
  RxBool get isFormValid;
  RxBool get isCreating;
  Rx<BarcodeResultModel?> get editingProduct;

  // In ProductsPresenterInterface, add:
  RxString get formHeaderImage;
  RxList<String> get formCarouselImages;
  RxString get formRecyclingImage;
  RxList<String> get formLinkedRewards;

  // Mobile preview properties
  RxString get previewTitle;
  RxString get previewBrand;
  RxString get previewDescription;
  RxString get previewImage;
  RxString get previewBarcode;
  RxList<String> get previewCategories;

  // New: Items list
  RxList<Map<String, String>> get formItems;
  RxBool get isAddingItem;
  RxString get newItemTitle;
  RxString get newItemBarcode;
  TextEditingController get newItemTitleController;
  TextEditingController get newItemBarcodeController;

  // Barcode controller for single barcode input
  TextEditingController get barcodeController;

  // Edit item properties
  RxInt get editingItemIndex;
  RxString get editItemTitle;
  RxString get editItemBarcode;
  TextEditingController get editItemTitleController;
  TextEditingController get editItemBarcodeController;

  // Methods
  // New item management
  void startAddingItem();
  void cancelAddingItem();
  void addItem(String title, String barcode);
  void addItemFromState();
  void removeItem(int index);
  void updateNewItemTitle(String title);
  void updateNewItemBarcode(String barcode);
  void handleBarcodeInput(String input);
  bool isNewItemValid();

  // Edit item management
  void startEditingItem(int index);
  void cancelEditingItem();
  void updateEditItem(String title, String barcode);
  void updateEditItemFromState();
  void updateEditItemTitle(String title);
  void updateEditItemBarcode(String barcode);
  void handleEditBarcodeInput(String input);
  bool isEditItemValid();

  Future<void> loadProducts();
  void filterProducts(String category);
  void searchProducts(String query);
  void startCreate();
  void startEdit(BarcodeResultModel product);
  void updateFormField(String field, dynamic value);
  Future<void> saveProduct();
  Future<void> deleteProduct(int id);
  void cancelEdit();
  Future<void> uploadImage();
  void updatePreview();
  Future uploadHeaderImage();
  Future uploadCarouselImage();
  Future uploadRecyclingImage();

  // Rewards management methods
  void addLinkedReward(String rewardId);
  void removeLinkedReward(String rewardId);
  void showRewardsSelectionDialog();

  // New methods for improvements
  RxString get viewMode; // 'grid' or 'list'
  void toggleViewMode(String mode);
  Future<void> duplicateProduct(BarcodeResultModel product);
  Future<void> uploadCsvFile({Uint8List? fileBytes, String? fileName});
  
  // CSV upload dialog state
  RxString? get csvFileName;
  RxString? get csvFilePath;
  Rx<Uint8List?> get csvFileBytes;
  RxBool get isCsvUploading;
  RxBool get isDownloadingTemplate;
  RxBool get hasDownloadedTemplate;
  RxBool get hasSelectedCsvFile;
  
  // CSV upload methods
  Future<void> downloadCsvTemplate();
  Future<void> pickCsvFile();
  void clearCsvSelection();
  
  // Pagination methods
  RxInt get currentPage;
  RxInt get totalCount; 
  RxBool get hasNextPage;
  RxInt get perPage;
  Future<void> goToPage(int page);
  Future<void> refreshProducts();
  
  // Pagination helper methods
  int getTotalPages();
  bool getHasPrevious();
  int getSafeCurrentPage();
  
  // Image conversion loading states
  RxBool get isConvertingHeaderImage;
  RxBool get isConvertingCarouselImage;
  RxBool get isConvertingRecyclingImage;
  RxBool get canSaveProduct;
  
  // Enhanced validation methods
  bool get isTitleValid;
  bool get isBrandValid;
  bool get isDescriptionValid;
  bool get isBarcodeValid;
  bool get isCategoryValid;
  bool get hasRequiredImages;
  String get validationMessage;
}

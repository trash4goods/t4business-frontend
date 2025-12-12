import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product.dart';

abstract class ProductsPresenterInterface extends GetxController {
  // Observable properties
  RxList<ProductModel> get products;
  RxList<ProductModel> get filteredProducts;
  RxList<String> get categories;
  RxString get selectedCategory;
  RxBool get isLoading;
  RxString get searchQuery;

  // Form properties for create/edit
  RxString get formTitle;
  RxString get formBrand;
  RxString get formDescription;
  RxString get formBarcode;
  RxList<String> get formCategories;
  RxBool get isFormValid;
  RxBool get isCreating;
  Rx<ProductModel?> get editingProduct;

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
  void startEdit(ProductModel product);
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
}

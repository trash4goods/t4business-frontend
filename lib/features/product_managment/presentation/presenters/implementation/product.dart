import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product.dart';
import '../../controllers/interface/product.dart';
import '../interface/product.dart';

class ProductsPresenterImpl extends GetxController
    implements ProductsPresenterInterface {
  final ProductsControllerInterface _controller;

  ProductsPresenterImpl(this._controller);

  // Observable properties
  final RxList<ProductModel> _products = <ProductModel>[].obs;
  final RxList<ProductModel> _filteredProducts = <ProductModel>[].obs;
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
  final Rx<ProductModel?> _editingProduct = Rx<ProductModel?>(null);

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

  // Text controllers for new item inputs
  late final TextEditingController _newItemTitleController;
  late final TextEditingController _newItemBarcodeController;

  // Text controllers for edit item inputs
  late final TextEditingController _editItemTitleController;
  late final TextEditingController _editItemBarcodeController;

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
  RxList<ProductModel> get products => _products;
  @override
  RxList<ProductModel> get filteredProducts => _filteredProducts;
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
  Rx<ProductModel?> get editingProduct => _editingProduct;
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
  void onInit() {
    super.onInit();

    // Initialize text controllers
    _newItemTitleController = TextEditingController();
    _newItemBarcodeController = TextEditingController();
    _editItemTitleController = TextEditingController();
    _editItemBarcodeController = TextEditingController();

    // Setup listeners for reactive updates
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
    _categories.addAll(_controller.getAllCategories());

    // Setup form validation for fields that might be updated directly
    ever(_formTitle, (_) => _validateForm());
    ever(_formBrand, (_) => _validateForm());
    ever(_formDescription, (_) => _validateForm());
    ever(_formHeaderImage, (_) => _validateForm());
    ever(_formImage, (_) => _validateForm());
    ever(_formBarcode, (_) => _validateForm());
    ever(_formItems, (_) => _validateForm());
    ever(_formCategories, (_) => _validateForm());
    ever(_formItems, (_) => updatePreview());

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
    _newItemTitleController.dispose();
    _newItemBarcodeController.dispose();
    _editItemTitleController.dispose();
    _editItemBarcodeController.dispose();
    super.onClose();
  }

  @override
  Future<void> loadProducts() async {
    _isLoading.value = true;
    try {
      final productList = await _controller.getAllProducts();
      _products.assignAll(productList);
      _filteredProducts.assignAll(productList);
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

  void _applyFilters() {
    var filtered = _products.toList();

    // Filter by category
    if (_selectedCategory.value.isNotEmpty) {
      filtered = _controller.filterProductsByCategory(_selectedCategory.value);
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (product) =>
                    product.title.toLowerCase().contains(
                      _searchQuery.value.toLowerCase(),
                    ) ||
                    product.description.toLowerCase().contains(
                      _searchQuery.value.toLowerCase(),
                    ) ||
                    product.barcode.contains(_searchQuery.value),
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
  void startEdit(ProductModel product) {
    _editingProduct.value = product;
    _isCreating.value = true;
    _formTitle.value = product.title;
    _formBrand.value = product.brand;
    _formDescription.value = product.description;
    _formHeaderImage.value = product.headerImage;
    _formCarouselImages.assignAll(product.carouselImage);
    _formRecyclingImage.value = ''; // For now, no recycling image in the model
    _formBarcode.value = product.barcode;
    _formItems.assignAll(product.items);
    _formCategories.assignAll(product.category);
    _formLinkedRewards.assignAll(product.linkedRewards);
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
        break;
      case 'categories':
        if (value is List<String>) {
          _formCategories.assignAll(value);
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
    if (!_isFormValid.value) return;

    _isLoading.value = true;
    try {
      final product = ProductModel(
        id: _editingProduct.value?.id ?? 0,
        title: _formTitle.value,
        brand: _formBrand.value,
        description: _formDescription.value,
        headerImage: _formHeaderImage.value,
        carouselImage: _formCarouselImages.toList(),
        items: _formItems.toList(),
        barcode: _formBarcode.value,
        category: _formCategories.toList(),
        createdAt: _editingProduct.value?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        linkedRewards: _formLinkedRewards.toList(),
      );

      bool success;
      if (_editingProduct.value != null) {
        success = await _controller.updateProduct(product);
      } else {
        success = await _controller.createProduct(product);
      }

      if (success) {
        Get.snackbar(
          'Success',
          _editingProduct.value != null
              ? 'Product updated successfully'
              : 'Product created successfully',
          snackPosition: SnackPosition.TOP,
        );
        await loadProducts();
        _isCreating.value = false;
        cancelEdit();
      } else {
        Get.snackbar(
          'Error',
          'Failed to save product',
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    _isLoading.value = true;
    try {
      final success = await _controller.deleteProduct(id);
      if (success) {
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          snackPosition: SnackPosition.TOP,
        );
        await loadProducts();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete product',
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      _isLoading.value = false;
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
      );

      if (result != null) {
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        _formHeaderImage.value = imageUrl;
        Get.snackbar(
          'Success',
          'Header image uploaded successfully',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.TOP,
      );
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
    if (_formItems.isNotEmpty) {
      _previewBarcode.value = _formItems.first['barcode'] ?? '0000000000000';
    } else {
      _previewBarcode.value = '0000000000000';
    }
    _previewCategories.assignAll(_formCategories);
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
  }

  void _validateForm() {
    _isFormValid.value =
        _formTitle.value.isNotEmpty &&
        _formBrand.value.isNotEmpty &&
        _formDescription.value.isNotEmpty &&
        _formHeaderImage.value.isNotEmpty &&
        _formCategories.isNotEmpty &&
        _formItems.isNotEmpty;
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
      );

      if (result != null) {
        log('📁 File selected: ${result.files.single.name}');
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        log('🌐 Image URL received: $imageUrl');

        _formHeaderImage.value = imageUrl;
        log('✅ _formHeaderImage updated to: ${_formHeaderImage.value}');

        updatePreview();
        log('🔄 Preview updated');

        Get.snackbar(
          'Success',
          'Header image uploaded successfully\nURL: $imageUrl',
          duration: Duration(seconds: 3),
        );
      } else {
        log('❌ No file selected');
      }
    } catch (e) {
      log('💥 Upload error: $e');
      Get.snackbar('Error', 'Failed to upload header image: $e');
    }
  }

  @override
  Future uploadCarouselImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        final updatedList = _formCarouselImages.toList();
        updatedList.add(imageUrl);
        _formCarouselImages.assignAll(updatedList);
        updatePreview();
        Get.snackbar('Success', 'Carousel image uploaded successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload carousel image');
    }
  }

  @override
  Future uploadRecyclingImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        _formRecyclingImage.value = imageUrl;
        updatePreview();
        Get.snackbar('Success', 'Recycling image uploaded successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload recycling image');
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
                  Get.snackbar(
                    'Info',
                    'Linked ${_formLinkedRewards.length} reward(s) to this product',
                    snackPosition: SnackPosition.TOP,
                  );
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
}

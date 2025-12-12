import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../../utils/helpers/snackbar_service.dart';
import '../../../../rules_v2/presentation/view/widgets/selection/selection_bottom_sheet.dart';
import '../../../../rules_v2/presentation/controller/rules_v2_controller.interface.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../rules/data/models/rule.dart';
import '../../../../product_managment/utils/image_base64_converter.dart';
import '../../../data/models/reward_result.dart';
import '../../../data/models/reward_upload_file.dart';
import '../../../data/usecase/rewards_usecase.interface.dart';
import '../../presenters/interface/rewards_presenter.interface.dart';
import '../../widgets/validate_reward_dialog.dart';
import '../interface/rewards_controller.interface.dart';

class RewardsControllerImpl implements RewardsControllerInterface {
  final RewardsPresenterInterface presenter;
  final RewardsUseCaseInterface usecase;
  final DashboardShellControllerInterface dashboardShellController;

  RewardsControllerImpl({
    required this.presenter,
    required this.usecase,
    required this.dashboardShellController,
  });

  @override
  void onStatusFilterChanged(String value) {
    presenter.selectedStatusFilter = value;
    _applyFilters();
  }

  @override
  Future<void> createReward() async {
    try {
      presenter.isSaving = true;

      // get the token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if ((cachedUser?.accessToken ?? '').isEmpty) return;

      // Build files list combining header and carousel images
      final files = <RewardUploadFileModel>[];

      // Add header image first (if exists)
      if (presenter.formHeaderImage.isNotEmpty) {
        files.add(
          RewardUploadFileModel(
            name: DateTime.now().toIso8601String(),
            base64: presenter.formHeaderImage,
          ),
        );
      }

      // Add carousel images
      if (presenter.formCarouselImages.isNotEmpty) {
        files.addAll(
          presenter.formCarouselImages.map(
            (url) => RewardUploadFileModel(
              name: DateTime.now().toIso8601String(),
              base64: url,
            ),
          ),
        );
      }

      // create reward model
      final newReward = RewardResultModel(
        name: presenter.formTitle,
        description: presenter.formDescription,
        status: presenter.formCanCheckout ? 'active' : 'archived',
        categories: presenter.formCategories,
        uploadFiles: files.isEmpty ? null : files,
        quantity: presenter.formQuantity,
        expiryDate:
            (presenter.formExpiryDate ?? DateTime.now()).day ==
                    DateTime.now().day
                ? null
                : presenter.formExpiryDate, // if its today set as null
        addRuleIds:
            presenter.selectedRuleIds.isEmpty
                ? null
                : presenter.selectedRuleIds.toList(),
      );

      // call the usecase
      await usecase.createReward(newReward, token: cachedUser!.accessToken!);

      // display non-blocking UI message (success)
      showSuccess('Reward created successfully');

      // reset the form
      cancelEdit();

      // update the view
      await presenter.loadRewards();
      _applyFilters();
    } catch (e) {
      // display non-blocking UI message (error)
    } finally {
      presenter.isSaving = false;
    }
  }

  @override
  Future<void> deleteReward(int? rewardId) async {
    try {
      log('Deleting reward $rewardId');
      presenter.isLoading = true;

      // get the token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null || rewardId == null) return;

      // call the usecase
      await usecase.deleteReward(rewardId, token: cachedUser!.accessToken!);

      // update the view
      await presenter.loadRewards();
      _applyFilters();

      // display non-blocking UI message (success)
      showSuccess('Reward deleted successfully');
    } catch (e) {
      // display non-blocking UI message (error)
      showError('Failed to delete reward');
    } finally {
      presenter.isLoading = false;
    }
  }

  @override
  Future<void> updateReward() async {
    try {
      presenter.isSaving = true;

      // get the token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if ((cachedUser?.accessToken ?? '').isEmpty) return;

      // Build deletion and upload lists
      final deleteFileIds = presenter.filesToDelete;
      final uploadFiles = <RewardUploadFileModel>[];

      log('🔍 DEBUG: Files to delete: $deleteFileIds');
      log('🔍 DEBUG: Upload files count: ${uploadFiles.length}');

      // Add header image first (if exists)
      if (presenter.formHeaderImage.isNotEmpty) {
        if (presenter.formHeaderImage.startsWith('data:image/')) {
          uploadFiles.add(
            RewardUploadFileModel(
              name: DateTime.now().toIso8601String(),
              base64: presenter.formHeaderImage,
            ),
          );
        }
      }

      // Add carousel images
      if (presenter.formCarouselImages.isNotEmpty) {
        for (final image in presenter.formCarouselImages) {
          if (image.isNotEmpty) {
            if (image.startsWith('data:image/')) {
              uploadFiles.add(
                RewardUploadFileModel(
                  name: DateTime.now().toIso8601String(),
                  base64: image,
                ),
              );
            }
          }
        }
      }

      // Check if quantity decreased to set removeAll
      // for now this logic not implemented in the backend
      /*final currentQuantity = presenter.editingReward?.quantity ?? 0;
      final newQuantity = presenter.formQuantity;
      final shouldRemoveAll = newQuantity < currentQuantity;*/

      // Calculate rule delta for edit operations
      final ruleDelta = presenter.calculateRuleDelta();

      // create update model
      final updatedReward = RewardResultModel(
        name: presenter.formTitle,
        description: presenter.formDescription,
        status: presenter.formCanCheckout ? 'active' : 'archived',
        categories: presenter.formCategories,
        uploadFiles: uploadFiles.isNotEmpty ? uploadFiles : null,
        deleteFiles: deleteFileIds.isNotEmpty ? deleteFileIds : null,
        addQuantity: presenter.formQuantity,
        expiryDate:
            (presenter.formExpiryDate ?? DateTime.now()).day ==
                    DateTime.now().day
                ? null
                : presenter.formExpiryDate,
        addRuleIds: ruleDelta['add'],
        removeRuleIds: ruleDelta['remove'],
      );

      // call the usecase
      await usecase.updateReward(
        presenter.editingReward?.id ?? 0,
        updatedReward,
        token: cachedUser!.accessToken!,
      );

      // display non-blocking UI message (success)
      showSuccess('Reward updated successfully');

      // reset the form
      cancelEdit();

      // update the view
      await presenter.loadRewards();
      _applyFilters();
    } catch (e) {
      // display non-blocking UI message (error)
      showError('Failed to update reward');
    } finally {
      presenter.isSaving = false;
    }
  }

  @override
  void startCreate() {
    presenter.clearForm();
    presenter.editingReward = null;
    presenter.isCreating = true;
    presenter.updatePreview();
  }

  // ===== UI dialog helpers =====
  @override
  void showFilterDialog(
    BuildContext context, {
    required void Function(String) onFilterChanged,
  }) {
    showShadDialog(
      context: context,
      builder:
          (ctx) => ShadDialog(
            title: const Text('Advanced Filters'),
            description: const Text('Filter rewards by various criteria'),
            actions: [
              ShadButton.outline(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadSelect<String>(
                    placeholder: const Text('Filter by Status'),
                    selectedOptionBuilder: (context, value) => Text(value),
                    options: const [
                      ShadOption(value: 'all', child: Text('All Status')),
                      ShadOption(value: 'active', child: Text('Active')),
                      ShadOption(value: 'inactive', child: Text('Inactive')),
                    ],
                    onChanged: (value) {
                      onFilterChanged(value ?? 'all');
                    },
                  ),
                  const SizedBox(height: 16),
                  ShadSelect<String>(
                    placeholder: const Text('Filter by Category'),
                    selectedOptionBuilder: (context, value) => Text(value),
                    options: [
                      for (final c in presenter.categories)
                        ShadOption(value: c, child: Text(c)),
                    ],
                    onChanged: (value) {
                      // Forward raw string; view/presenter can handle mapping
                      onFilterChanged(value ?? 'all');
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void onNavigate(String value) =>
      dashboardShellController.handleMobileNavigation(value);
  @override
  void onLogout() => dashboardShellController.logout();
  @override
  void onToggle() => dashboardShellController.toggleSidebar();

  @override
  void toggleViewMode(String mode) => presenter.viewMode = mode;

  @override
  void filterRewards(String category) {
    presenter.selectedCategory = category;
    _applyFilters();
  }

  @override
  List<RewardResultModel> searchRewards(String query) {
    presenter.searchQuery = query;
    _applyFilters();
    return presenter.filteredRewards ?? [];
  }

  void _applyFilters() {
    // Always start from the original rewards list
    var filtered = (presenter.rewards ?? []).toList();

    if (filtered.isEmpty) return;

    // Status filter
    switch (presenter.selectedStatusFilter) {
      case 'active':
        filtered = filtered.where((r) => r.canCheckout).toList();
        break;
      case 'archived':
        filtered = filtered.where((r) => !r.canCheckout).toList();
        break;
      default:
        // all - no filtering
        break;
    }

    // Category filter
    if (presenter.selectedCategory.isNotEmpty &&
        presenter.selectedCategory != 'all') {
      filtered =
          filtered
              .where(
                (reward) =>
                    reward.categories?.any(
                      (cat) => cat.toLowerCase().contains(
                        presenter.selectedCategory.toLowerCase(),
                      ),
                    ) ??
                    false,
              )
              .toList();
    }

    // Search filter
    if (presenter.searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (reward) =>
                    (reward.name ?? '').toLowerCase().contains(
                      presenter.searchQuery.toLowerCase(),
                    ) ||
                    (reward.description ?? '').toLowerCase().contains(
                      presenter.searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    presenter.filteredRewards = filtered;
  }

  @override
  void onFilterChanged(String filter) {
    presenter.selectedFilter = filter;
    _applyFilters();
  }

  @override
  List<RewardResultModel> filterRewardsByCategory(String category) {
    if (category.isEmpty || category == 'all') {
      return presenter.rewards?.toList() ?? [];
    }
    return (presenter.rewards ?? [])
        .where(
          (reward) =>
              reward.categories?.any(
                (cat) => cat.toLowerCase().contains(category.toLowerCase()),
              ) ??
              false,
        )
        .toList();
  }

  @override
  List<RewardResultModel> filterRewardsByStatus(bool canCheckout) {
    return (presenter.rewards ?? [])
        .where((reward) => reward.canCheckout == canCheckout)
        .toList();
  }

  @override
  void cancelEdit() {
    presenter.clearForm();
    presenter.editingReward = null;
    presenter.isCreating = false;
    presenter.showRulesPanel = false;
  }

  @override
  void confirmDeleteReward(
    BuildContext context,
    RewardResultModel reward, {
    required Future<void> Function() onConfirm,
  }) {
    showShadDialog(
      context: context,
      builder:
          (ctx) => ShadDialog(
            title: const Text('Delete Reward'),
            description: Text(
              'Are you sure you want to delete "${reward.name ?? ''}"? This action cannot be undone.',
            ),
            actions: [
              ShadButton.outline(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ShadButton.destructive(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await onConfirm();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  int getGridCrossAxisCount(double width) {
    if (width >= 1800) return 6; // Ultra-wide screens
    if (width >= 1400) return 5; // Very large screens
    if (width >= 1100) return 4; // Large screens
    if (width >= 800) return 3; // Medium screens
    if (width >= 500) return 2; // Small screens
    return 1; // Mobile
  }

  @override
  double getGridSpacing(double width) {
    if (width >= 1200) return 20;
    if (width >= 768) return 16;
    return 12;
  }

  @override
  double getRewardChildAspectRatio(double width) {
    final crossAxisCount = getGridCrossAxisCount(width);
    if (width >= 1400) {
      return crossAxisCount >= 5 ? 0.7 : 0.75;
    } else if (width >= 1100) {
      return crossAxisCount >= 4 ? 0.75 : 0.8;
    } else if (width >= 800) {
      return 0.8;
    } else if (width >= 500) {
      return 0.9;
    } else {
      return 1.0;
    }
  }

  @override
  void startEdit(RewardResultModel reward) {
    // Set editing state and store original files for tracking deletions
    presenter.editingReward = reward;
    presenter.isCreating = true;

    // Initialize tracking variables (call before setting form fields)
    presenter.clearForm(); // This will clear tracking variables

    // Store original files for deletion tracking
    if (reward.files != null) {
      presenter.initializeEditingMode(reward.files!);
    }

    // Populate form fields using existing getters
    presenter.formTitle = reward.name ?? '';
    presenter.formDescription = reward.description ?? '';
    presenter.formHeaderImage = reward.headerImage;
    presenter.formCarouselImages.assignAll(reward.carouselImage);
    presenter.formLogo = reward.logo;
    presenter.formCategories.assignAll(reward.categories ?? []);
    presenter.formCanCheckout = reward.canCheckout;
    presenter.formQuantity = reward.quantity ?? 0;
    presenter.formExpiryDate = reward.expiryDate;
    log(
      'Edit mode started for reward ${reward.id} with ${reward.files?.length ?? 0} original files',
    );
    // Populate rule selections for edit mode
    presenter.populateSelectionsFromReward(reward);
    presenter.formCanCheckout = reward.canCheckout;
    presenter.updateSelectedRulesData();
    presenter.updatePreview();
  }

  // Pagination methods
  @override
  Future<void> goToPage(int page) async {
    if (page != presenter.currentPage && page > 0) {
      presenter.currentPage = page;
      await presenter.loadRewards();
      _applyFilters();
    }
  }

  @override
  Future<void> refreshRewards() async {
    presenter.currentPage = 1;
    await presenter.loadRewards();
    _applyFilters();
  }

  @override
  int getTotalPages() {
    return presenter.totalCount > 0
        ? (presenter.totalCount / presenter.perPage).ceil()
        : 1;
  }

  @override
  bool getHasPrevious() => presenter.currentPage > 1;

  @override
  int getSafeCurrentPage() => presenter.currentPage.clamp(1, getTotalPages());

  @override
  void updateFormField(String field, dynamic value) {
    switch (field) {
      case 'title':
        presenter.formTitle = value.toString();
        break;
      case 'description':
        presenter.formDescription = value.toString();
        break;
      case 'headerImage':
        presenter.formHeaderImage = value.toString();
        break;
      case 'carouselImages':
        if (value is List<String>) {
          presenter.formCarouselImages.assignAll(value);
        }
        break;
      case 'logo':
        presenter.formLogo = value.toString();
        break;
      case 'categories':
        if (value is List<String>) {
          presenter.formCategories.assignAll(value);
        }
        break;
      // linked rules not implemented yet
      /*case 'linkedRules':
        if (value is List<String>) {
          formLinkedRules.assignAll(value);
          updateSelectedRulesData();
        }
        break;*/
      case 'canCheckout':
        presenter.formCanCheckout = value as bool;
        break;
      case 'quantity':
        presenter.formQuantity = value;
        break;
      case 'expiryDate':
        presenter.formExpiryDate = value as DateTime?;
        break;
    }
    presenter.validateForm();
    presenter.updatePreview();
  }

  @override
  Future<void> uploadCarouselImage() async {
    try {
      // Check image limit first
      if (presenter.formCarouselImages.length >= 3) {
        SnackbarServiceHelper.showWarning(
          'Maximum 3 carousel images allowed',
          position: SnackPosition.BOTTOM,
        );
        return;
      }

      log('🔄 Starting carousel image upload...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null) {
        log('📁 File selected: ${result.files.single.name}');
        final file = result.files.single;

        // Set loading state and show conversion notification
        presenter.isConvertingCarouselImage = true;
        SnackbarServiceHelper.showInfo(
          'Converting carousel image to base64, please wait...',
          position: SnackPosition.BOTTOM,
        );

        String imageUrl;

        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            log('🌐 Web platform: Using bytes for upload');
            imageUrl = await uploadImageWithBytes(file.bytes!, file.name);
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            log('📱 Mobile/Desktop platform: Using file path');
            imageUrl = await uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }

        log('🌐 Image URL received: ${imageUrl.substring(0, 50)}...');

        // Add to carousel images list
        presenter.formCarouselImages.add(imageUrl);
        log(
          '✅ formCarouselImages updated (${presenter.formCarouselImages.length}/3)',
        );

        presenter.updatePreview();
        log('🔄 Preview updated');

        // Clear loading state and show success
        presenter.isConvertingCarouselImage = false;
        SnackbarServiceHelper.showSuccess(
          'Carousel image uploaded successfully (${presenter.formCarouselImages.length}/3)',
          position: SnackPosition.BOTTOM,
          actionLabel: 'OK',
        );
      } else {
        log('❌ No file selected');
        presenter.isConvertingCarouselImage = false;
      }
    } catch (e) {
      log('💥 Upload error: $e');
      // Clear loading state on error
      presenter.isConvertingCarouselImage = false;

      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') &&
          !e.toString().contains('400') &&
          !e.toString().contains('404') &&
          !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        SnackbarServiceHelper.showError(
          'Failed to process carousel image',
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Future<void> uploadHeaderImage() async {
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
        presenter.isConvertingHeaderImage = true;
        SnackbarServiceHelper.showInfo(
          'Converting image to base64, please wait...',
          position: SnackPosition.BOTTOM,
        );

        String imageUrl;

        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            log('🌐 Web platform: Using bytes for upload');
            imageUrl = await uploadImageWithBytes(file.bytes!, file.name);
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            log('📱 Mobile/Desktop platform: Using file path');
            imageUrl = await uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }

        log('🌐 Image URL received: ${imageUrl.substring(0, 50)}...');

        // Use replace logic to handle deletion of old header
        replaceHeaderImage(imageUrl);
        log('✅ formHeaderImage updated');

        // Clear loading state and show success
        presenter.isConvertingHeaderImage = false;
        SnackbarServiceHelper.showSuccess(
          'Header image uploaded successfully',
          position: SnackPosition.BOTTOM,
          actionLabel: 'OK',
        );
      } else {
        log('❌ No file selected');
        presenter.isConvertingHeaderImage = false;
      }
    } catch (e) {
      log('💥 Upload error: $e');
      // Clear loading state on error
      presenter.isConvertingHeaderImage = false;

      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') &&
          !e.toString().contains('400') &&
          !e.toString().contains('404') &&
          !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        SnackbarServiceHelper.showError(
          'Failed to process header image',
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Future<void> uploadLogo() async {
    try {
      log('🔄 Starting logo upload...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null) {
        log('📁 File selected: ${result.files.single.name}');
        final file = result.files.single;

        // Set loading state and show conversion notification
        presenter.isConvertingLogo = true;
        SnackbarServiceHelper.showInfo(
          'Converting logo to base64, please wait...',
          position: SnackPosition.BOTTOM,
        );

        String imageUrl;

        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes != null) {
            log('🌐 Web platform: Using bytes for upload');
            imageUrl = await uploadImageWithBytes(file.bytes!, file.name);
          } else {
            throw Exception('Failed to get file bytes on web');
          }
        } else {
          // On mobile/desktop, use file path
          if (file.path != null) {
            log('📱 Mobile/Desktop platform: Using file path');
            imageUrl = await uploadImage(file.path!);
          } else {
            throw Exception('Failed to get file path');
          }
        }

        log('🌐 Image URL received: ${imageUrl.substring(0, 50)}...');

        presenter.formLogo = imageUrl;
        log('✅ formLogo updated');

        presenter.updatePreview();
        log('🔄 Preview updated');

        // Clear loading state and show success
        presenter.isConvertingLogo = false;
        SnackbarServiceHelper.showSuccess(
          'Logo uploaded successfully',
          position: SnackPosition.BOTTOM,
          actionLabel: 'OK',
        );
      } else {
        log('❌ No file selected');
        presenter.isConvertingLogo = false;
      }
    } catch (e) {
      log('💥 Upload error: $e');
      // Clear loading state on error
      presenter.isConvertingLogo = false;

      // Only show error if it's a client-side error
      // HTTP errors are already handled by HttpService
      if (!e.toString().contains('401') &&
          !e.toString().contains('400') &&
          !e.toString().contains('404') &&
          !e.toString().contains('500') &&
          !e.toString().contains('UnsupportedError')) {
        SnackbarServiceHelper.showError(
          'Failed to process logo',
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Future<String> uploadImage(String imagePath) async {
    log('🔄 Controller: Processing image from path: $imagePath');

    try {
      if (kIsWeb) {
        // On web, FilePicker provides a blob URL, but we need to get the actual bytes
        // The presenter should pass the bytes directly for web
        log(
          '🌐 Web platform: Converting to base64 (path-based approach not supported)',
        );
        // For web, the presenter should use uploadImageWithBytes method instead
        throw UnsupportedError(
          'Web platform requires bytes-based upload. Use uploadImageWithBytes instead.',
        );
      } else {
        // For mobile/desktop platforms, read the file and convert to base64
        log('📱 Mobile/Desktop platform: Reading file from path');

        final file = File(imagePath);

        // Check if file exists
        if (!await file.exists()) {
          throw Exception('File not found at path: $imagePath');
        }

        // Read file bytes
        final fileBytes = await file.readAsBytes();
        final fileName = imagePath.split('/').last;

        log('📊 File size: ${fileBytes.length} bytes');
        log('📁 File name: $fileName');

        // Convert to base64 using our utility (async to prevent UI blocking)
        final base64String = await ImageBase64Converter.bytesToBase64(
          fileBytes,
          fileName,
        );

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
  Future<String> uploadImageWithBytes(
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      log('🔄 Starting image upload with bytes...');
      log('📁 File name: $fileName');
      log('📊 File size: ${fileBytes.length} bytes');

      // Convert to base64 using our utility (async to prevent UI blocking)
      final base64String = await ImageBase64Converter.bytesToBase64(
        fileBytes,
        fileName,
      );

      log('✅ Successfully converted to base64');
      log('🌐 Base64 string length: ${base64String.length}');

      return base64String;
    } catch (e) {
      log('💥 Image upload error: $e');
      _handleError(e, 'uploading image');
      rethrow;
    }
  }

  void _handleError(dynamic error, String operation) {
    final errorMessage = error.toString();
    log('❌ Error during $operation: $errorMessage');

    // Only show error message if it's not an HTTP error (those are handled by HttpService)
    if (!errorMessage.contains('401') &&
        !errorMessage.contains('400') &&
        !errorMessage.contains('404') &&
        !errorMessage.contains('500') &&
        !errorMessage.contains('UnsupportedError')) {
      showError('Failed $operation: ${error.toString()}');
    }
  }

  @override
  void showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.BOTTOM,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );

  @override
  void showSuccess(String message) => SnackbarServiceHelper.showSuccess(
    message,
    position: SnackPosition.BOTTOM,
    actionLabel: 'OK',
  );

  @override
  void removeHeaderImage() {
    if (presenter.isCreating) {
      // Use efficient tracking method
      presenter.markCurrentHeaderForDeletion();
    }
    presenter.formHeaderImage = '';
    presenter.updatePreview();
    log('Header image removed');
  }

  @override
  void removeCarouselImage(String imageUrl) {
    log('🔍 DEBUG: removeCarouselImage called with URL: $imageUrl');
    log('🔍 DEBUG: presenter.isCreating: ${presenter.isCreating}');
    log(
      '🔍 DEBUG: Current form carousel images: ${presenter.formCarouselImages}',
    );

    if (presenter.isCreating) {
      // Use efficient tracking method
      presenter.markCarouselFileForDeletion(imageUrl);
    }
    presenter.formCarouselImages.remove(imageUrl);
    presenter.updatePreview();
    log('Carousel image removed: $imageUrl');
  }

  @override
  void replaceHeaderImage(String newImageUrl) {
    // Remove old header first (which handles deletion tracking)
    removeHeaderImage();
    // Set new header
    presenter.formHeaderImage = newImageUrl;
    presenter.updatePreview();
    log('Header image replaced with: ${newImageUrl.substring(0, 50)}...');
  }

  @override
  void onRuleSelection() async {
    // Store current selections for cancel functionality
    presenter.storeOriginalRuleSelections();

    // Reset pagination and items state but preserve selections
    presenter.resetRuleSelectionState();

    await _loadInitialRules();

    Get.bottomSheet(
      Obx(
        () => SelectionBottomSheet(
          title: 'Select Rules',
          items: presenter.ruleSelectionItems,
          selectedIds: presenter.selectedRuleIds,
          isLoading: presenter.isRuleSelectionLoading,
          searchQuery: presenter.ruleSelectionSearchQuery,
          currentPage: presenter.ruleSelectionCurrentPage,
          totalCount: presenter.ruleSelectionTotalCount,
          perPage: presenter.ruleSelectionPerPage,
          hasNext: presenter.ruleSelectionHasNext,
          getDisplayName: (rule) => rule.title,
          getId: (rule) => int.tryParse(rule.id) ?? 0,
          getSubtitle:
              (rule) => 'Status: ${rule.isActive ? "Active" : "Inactive"}',
          getImageUrl: (rule) => null,
          onSearchChanged: _onRuleSearchChanged,
          onItemToggled: _onRuleToggled,
          onPageChanged: _onRulePageChanged,
          onConfirm: _onRuleSelectionConfirmed,
          onCancel: _onRuleSelectionCancelled,
          createButtonText: 'Create Rule',
          onCreateNew: _onCreateNewRule,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Rule selection helper methods
  Future<void> _loadInitialRules() async {
    presenter.isRuleSelectionLoading = true;
    presenter.ruleSelectionCurrentPage = 1;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken != null) {
        final result = await usecase.fetchRules(
          page: 1,
          pageSize: presenter.ruleSelectionPerPage,
          search: presenter.ruleSelectionSearchQuery,
          token: cachedUser!.accessToken!,
        );

        presenter.ruleSelectionItems =
            result.items
                .map(
                  (ruleResult) => RuleModel(
                    id: ruleResult.id?.toString() ?? '',
                    title: ruleResult.name ?? '',
                    description: 'Rule created from API',
                    recycleCount: ruleResult.quantity ?? 0,
                    categories: ['General'],
                    createdAt: ruleResult.expiryDate ?? DateTime.now(),
                    createdBy: 'System',
                  ),
                )
                .toList();
        presenter.ruleSelectionTotalCount = result.totalCount;
        presenter.ruleSelectionHasNext = result.hasMore;
      }
    } catch (e) {
      showError('Failed to load rules: $e');
    } finally {
      presenter.isRuleSelectionLoading = false;
    }
  }

  Future<void> _loadRulesPage(int page) async {
    presenter.isRuleSelectionLoading = true;
    presenter.ruleSelectionCurrentPage = page;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken != null) {
        final result = await usecase.fetchRules(
          page: page,
          pageSize: presenter.ruleSelectionPerPage,
          search: presenter.ruleSelectionSearchQuery,
          token: cachedUser!.accessToken!,
        );

        presenter.ruleSelectionItems =
            result.items
                .map(
                  (ruleResult) => RuleModel(
                    id: ruleResult.id?.toString() ?? '',
                    title: ruleResult.name ?? '',
                    description: 'Rule created from API',
                    recycleCount: ruleResult.quantity ?? 0,
                    categories: ['General'],
                    createdAt: ruleResult.expiryDate ?? DateTime.now(),
                    createdBy: 'System',
                  ),
                )
                .toList();
        presenter.ruleSelectionTotalCount = result.totalCount;
        presenter.ruleSelectionHasNext = result.hasMore;
      }
    } catch (e) {
      showError('Failed to load rules: $e');
    } finally {
      presenter.isRuleSelectionLoading = false;
    }
  }

  void _onRulePageChanged(int page) {
    _loadRulesPage(page);
  }

  void _onRuleSearchChanged(String query) {
    presenter.ruleSelectionSearchQuery = query;
    _loadRulesPage(1);
  }

  void _onRuleToggled(int id) {
    log(
      '[RewardsController] Before rule toggle - count: ${presenter.selectedRuleCount}',
    );

    // Toggle in integer-based selection list
    if (presenter.selectedRuleIds.contains(id)) {
      presenter.selectedRuleIds.remove(id);
      log('[RewardsController] Removed rule $id');
    } else {
      presenter.selectedRuleIds.add(id);
      log('[RewardsController] Added rule $id');
    }

    // Also update the string-based formLinkedRules for backward compatibility
    final stringId = id.toString();
    if (presenter.formLinkedRules.contains(stringId)) {
      presenter.formLinkedRules.remove(stringId);
    } else {
      presenter.formLinkedRules.add(stringId);
    }

    // Force UI update for immediate reactivity
    presenter.refreshRuleSelections();
    log(
      '[RewardsController] After rule toggle - count: ${presenter.selectedRuleCount}',
    );
  }

  void _onRuleSelectionConfirmed() {
    // Selections are already in presenter.selectedRuleIds
    // No additional action needed - they persist until form is saved
    presenter.updateSelectedRulesData();
    presenter.validateForm();
    Get.back();
    showSuccess('Rule selection updated');
  }

  void _onRuleSelectionCancelled() {
    presenter.restoreOriginalRuleSelections();
    Get.back();
  }

  // Validation functionality implementation

  @override
  void openValidationDialog() {
    presenter.resetValidationState();

    showShadDialog(
      context: Get.context!,
      builder:
          (context) => Obx(
            () => ValidateRewardDialog(
              redeemCode: presenter.validationRedeemCode,
              isValidating: presenter.isValidatingReward,
              errorMessage: presenter.validationErrorMessage,
              successMessage: presenter.validationSuccessMessage,
              validatedReward: presenter.validatedReward,
              onCodeChanged: onValidationCodeChanged,
              onValidate: validateRedeemCode,
              onCancel: closeValidationDialog,
              onInvalidate: invalidateReward,
            ),
          ),
    );
  }

  @override
  void onValidationCodeChanged(String code) {
    presenter.validationRedeemCode = code;
    // Clear any existing messages when user types
    presenter.validationErrorMessage = null;
    presenter.validationSuccessMessage = null;
  }

  @override
  void validateRedeemCode() async {
    final code = presenter.validationRedeemCode.trim();
    if (code.isEmpty) return;

    presenter.isValidatingReward = true;
    presenter.validationErrorMessage = null;
    presenter.validationSuccessMessage = null;
    presenter.validatedReward = null;

    try {
      // get the token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null) {
        presenter.validationErrorMessage = 'Authentication required';
        return;
      }

      final result = await usecase.validateReward(
        code,
        token: cachedUser!.accessToken!,
      );

      if (result != null && result.product != null) {
        presenter.validatedReward = result;
        presenter.validationSuccessMessage =
            result.message ?? 'Reward validated successfully';
      } else {
        presenter.validationErrorMessage =
            result?.message ?? 'Invalid redeem code';
      }
    } catch (e) {
      presenter.validationErrorMessage = 'Failed to validate reward: $e';
    } finally {
      presenter.isValidatingReward = false;
    }
  }

  void invalidateReward() async {
    final validatedReward = presenter.validatedReward;
    if (validatedReward == null) return;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null) {
        showError('Authentication required');
        return;
      }

      final result = await usecase.invalidateReward(
        presenter.validationRedeemCode.trim(),
        token: cachedUser!.accessToken!,
      );

      // Show success message from API response
      final message = result?.message ?? 'Reward invalidated successfully';
      if (message.contains('already')) {
        showError(message);
      } else {
        showSuccess(message);
      }

      // Reset validation state to show form again
      _resetToValidationForm();
    } catch (e) {
      // Extract error message from API response
      String errorMessage = 'Failed to invalidate reward';

      // Try to extract message from error string
      final errorStr = e.toString();
      if (errorStr.contains('message:')) {
        final messageMatch = RegExp(r'message:\s*([^}]+)').firstMatch(errorStr);
        if (messageMatch != null) {
          errorMessage = messageMatch.group(1)?.trim() ?? errorMessage;
        }
      }

      showError(errorMessage);

      // Reset validation state to show form again
      _resetToValidationForm();
    }
  }

  void _resetToValidationForm() {
    // Reset validation state but keep the dialog open
    presenter.validatedReward = null;
    presenter.validationRedeemCode = '';
    presenter.validationErrorMessage = null;
    presenter.validationSuccessMessage = null;
    presenter.isValidatingReward = false;
  }

  @override
  void closeValidationDialog() {
    Get.back();
    presenter.resetValidationState();
  }

  // Create new rule navigation
  void _onCreateNewRule() {
    // Close the rule selection bottom sheet
    Get.back();

    // Navigate to rules page
    dashboardShellController.navigateToPage(AppRoutes.rulesV2);

    // Open create rule dialog after navigation
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        // Get the rules controller and call startCreate
        final rulesController = Get.find<RulesV2ControllerInterface>();
        rulesController.startCreate();
      } catch (e) {
        // Fallback if controller not found
        log('Could not automatically open create rule dialog: $e');
        showSuccess(
          'Navigated to rules page. Click the Create Rule button to add a new rule.',
        );
      }
    });
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/rules/data/models/rule.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../../../utils/helpers/translate_api_text.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../data/models/reward_result.dart';
import '../../../data/models/reward_result_file.dart';
import '../../../data/models/validate_reward.dart';
import '../../../data/usecase/rewards_usecase.interface.dart';
import '../interface/rewards_presenter.interface.dart';

class RewardsPresenterImpl extends RewardsPresenterInterface
    with GetSingleTickerProviderStateMixin {
  final RewardsUseCaseInterface usecase;
  final DashboardShellControllerInterface dashboardShellController;
  RewardsPresenterImpl(this.usecase, this.dashboardShellController);

  // OBX registered variables
  final _rewards = Rxn<List<RewardResultModel>>();
  final _filteredRewards = Rxn<List<RewardResultModel>>();
  final _isLoading = RxBool(false);
  final _isSaving = RxBool(false);
  final _isCreating = RxBool(false);
  final _editingReward = Rxn<RewardResultModel>();
  // mock categories
  final List<String> _categories = <String>[
    'all',
    'food',
    'beverage',
    'clothing',
    'electronics',
    'health',
    'other',
  ];
  final _selectedCategory = RxString('all');
  final _selectedFilter = RxString('all');
  final _viewMode = RxString('grid');
  final _searchQuery = RxString('');

  final _selectedStatusFilter = RxString('active');
  final _statusFilters = RxList<String>(['active', 'archived']);

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  final _formTitle = RxString('');
  final _formDescription = RxString('');
  final _formHeaderImage = RxString('');
  final _formCarouselImages = RxList<String>();
  final _formLogo = RxString('');
  final _formCategories = RxList<String>();
  final _formLinkedRules = RxList<String>();
  final _formCanCheckout = RxBool(false);
  final _formQuantity = RxInt(0);
  final _formExpiryDate = Rxn<DateTime>();
  final _isFormValid = RxBool(false);

  final _previewTitle = RxString('');
  final _previewDescription = RxString('');
  final _previewHeaderImage = RxString('');
  final _previewCarouselImages = RxList<String>();
  final _previewLogo = RxString('');
  final _previewCategories = RxList<String>();

  final _availableRules = RxList<RuleModel>();
  final _selectedRulesData = RxList<RuleModel>();

  // Rule selection state
  final _isRuleSelectionLoading = RxBool(false);
  final _ruleSelectionSearchQuery = RxString('');
  final _ruleSelectionCurrentPage = RxInt(1);
  final _ruleSelectionTotalCount = RxInt(0);
  final _ruleSelectionPerPage = 10;
  final _ruleSelectionHasNext = RxBool(false);
  final _ruleSelectionItems = RxList<RuleModel>();
  
  // Rule selection with integer IDs (following rules_v2 pattern)
  final _selectedRuleIds = RxList<int>([]);
  
  // For cancel functionality
  List<String> _originalRuleSelections = [];
  List<int> _originalSelectedRuleIds = [];
  
  // For edit mode delta calculation
  List<int> _originalRewardRuleIds = [];

  final _showRulesPanel = RxBool(false);
  final _rulesPanelHeight = RxDouble(0);

  final _currentPage = RxInt(1);
  final _perPage = RxInt(10);
  final _totalCount = RxInt(0);
  final _hasNextPage = RxBool(false);

  final _isConvertingHeaderImage = RxBool(false);
  final _isConvertingCarouselImage = RxBool(false);
  final _isConvertingLogo = RxBool(false);

  final _canSaveReward = RxBool(false);

  final _originalFiles = RxList<RewardResultFileModel>();
  final _filesToDelete = RxList<int>();
  
  // Direct file mapping for efficient tracking
  RewardResultFileModel? _currentHeaderFile;
  final _currentCarouselFiles = <RewardResultFileModel>[];

  // Validation state observables
  final _validationRedeemCode = RxString('');
  final _isValidatingReward = RxBool(false);
  final _validationErrorMessage = RxnString();
  final _validationSuccessMessage = RxnString();
  final _validatedReward = Rxn<ValidateRewardModel>();

  // Getters and Setters implementations

  @override
  String get selectedStatusFilter => _selectedStatusFilter.value;
  @override
  set selectedStatusFilter(String value) => _selectedStatusFilter.value = value;

  @override
  List<String> get statusFilters => _statusFilters;
  @override
  set statusFilters(List<String> value) => _statusFilters.value = value;

  @override
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  late String currentRoute;
  @override
  List<String> get categories => _categories;
  @override
  String get selectedCategory => _selectedCategory.value;
  @override
  set selectedCategory(String value) => _selectedCategory.value = value;
  @override
  String get selectedFilter => _selectedFilter.value;
  @override
  set selectedFilter(String value) => _selectedFilter.value = value;
  @override
  String get viewMode => _viewMode.value;
  @override
  set viewMode(String value) => _viewMode.value = value;
  @override
  String get searchQuery => _searchQuery.value;
  @override
  set searchQuery(String value) => _searchQuery.value = value;

  @override
  List<RewardResultModel>? get rewards => _rewards.value;
  @override
  List<RewardResultModel>? get filteredRewards => _filteredRewards.value;
  @override
  set filteredRewards(List<RewardResultModel>? value) =>
      _filteredRewards.value = value;

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => _isLoading.value = value;

  @override
  bool get isSaving => _isSaving.value;
  @override
  set isSaving(bool value) => _isSaving.value = value;

  @override
  bool get isCreating => _isCreating.value;
  @override
  set isCreating(bool value) => _isCreating.value = value;

  @override
  RewardResultModel? get editingReward => _editingReward.value;
  @override
  set editingReward(RewardResultModel? value) => _editingReward.value = value;

  @override
  List<RuleModel> get availableRules => _availableRules;

  @override
  int get currentPage => _currentPage.value;
  @override
  set currentPage(int value) => _currentPage.value = value;

  @override
  bool get formCanCheckout => _formCanCheckout.value;
  @override
  set formCanCheckout(bool value) => _formCanCheckout.value = value;

  @override
  int get formQuantity => _formQuantity.value;
  @override
  set formQuantity(int value) => _formQuantity.value = value;

  @override
  DateTime? get formExpiryDate => _formExpiryDate.value;
  @override
  set formExpiryDate(DateTime? value) => _formExpiryDate.value = value;

  @override
  List<String> get formCarouselImages => _formCarouselImages;
  @override
  set formCarouselImages(List<String> value) =>
      _formCarouselImages.value = value;

  @override
  List<String> get formCategories => _formCategories;
  @override
  set formCategories(List<String> value) => _formCategories.value = value;

  @override
  String get formDescription => _formDescription.value;
  @override
  set formDescription(String value) => _formDescription.value = value;

  @override
  String get formHeaderImage => _formHeaderImage.value;
  @override
  set formHeaderImage(String value) => _formHeaderImage.value = value;

  @override
  List<String> get formLinkedRules => _formLinkedRules;
  @override
  set formLinkedRules(List<String> value) => _formLinkedRules.value = value;

  @override
  String get formLogo => _formLogo.value;
  @override
  set formLogo(String value) => _formLogo.value = value;

  @override
  String get formTitle => _formTitle.value;
  @override
  set formTitle(String value) => _formTitle.value = value;

  @override
  bool get hasNextPage => _hasNextPage.value;
  @override
  set hasNextPage(bool value) => _hasNextPage.value = value;

  @override
  bool get isFormValid => _isFormValid.value;
  @override
  set isFormValid(bool value) => _isFormValid.value = value;

  @override
  int get perPage => _perPage.value;
  @override
  set perPage(int value) => _perPage.value = value;

  @override
  List<String> get previewCarouselImages => _previewCarouselImages;
  @override
  set previewCarouselImages(List<String> value) =>
      _previewCarouselImages.value = value;

  @override
  List<String> get previewCategories => _previewCategories;
  @override
  set previewCategories(List<String> value) => _previewCategories.value = value;

  @override
  String get previewDescription => _previewDescription.value;
  @override
  set previewDescription(String value) => _previewDescription.value = value;

  @override
  String get previewHeaderImage => _previewHeaderImage.value;
  @override
  set previewHeaderImage(String value) => _previewHeaderImage.value = value;

  @override
  String get previewLogo => _previewLogo.value;
  @override
  set previewLogo(String value) => _previewLogo.value = value;

  @override
  String get previewTitle => _previewTitle.value;
  @override
  set previewTitle(String value) => _previewTitle.value = value;

  @override
  double get rulesPanelHeight => _rulesPanelHeight.value;

  @override
  List<RuleModel> get selectedRulesData => _selectedRulesData;

  @override
  bool get isRuleSelectionLoading => _isRuleSelectionLoading.value;
  @override
  set isRuleSelectionLoading(bool value) => _isRuleSelectionLoading.value = value;

  @override
  String get ruleSelectionSearchQuery => _ruleSelectionSearchQuery.value;
  @override
  set ruleSelectionSearchQuery(String value) => _ruleSelectionSearchQuery.value = value;

  @override
  int get ruleSelectionCurrentPage => _ruleSelectionCurrentPage.value;
  @override
  set ruleSelectionCurrentPage(int value) => _ruleSelectionCurrentPage.value = value;

  @override
  int get ruleSelectionTotalCount => _ruleSelectionTotalCount.value;
  @override
  set ruleSelectionTotalCount(int value) => _ruleSelectionTotalCount.value = value;

  @override
  int get ruleSelectionPerPage => _ruleSelectionPerPage;

  @override
  bool get ruleSelectionHasNext => _ruleSelectionHasNext.value;
  @override
  set ruleSelectionHasNext(bool value) => _ruleSelectionHasNext.value = value;

  @override
  List<RuleModel> get ruleSelectionItems => _ruleSelectionItems;
  @override
  set ruleSelectionItems(List<RuleModel> value) => _ruleSelectionItems.value = value;

  @override
  bool get showRulesPanel => _showRulesPanel.value;
  @override
  set showRulesPanel(bool value) => _showRulesPanel.value = value;

  @override
  int get totalCount => _totalCount.value;
  @override
  set totalCount(int value) => _totalCount.value = value;

  @override
  bool get isConvertingHeaderImage => _isConvertingHeaderImage.value;
  @override
  set isConvertingHeaderImage(bool value) => _isConvertingHeaderImage.value = value;

  @override
  bool get isConvertingCarouselImage => _isConvertingCarouselImage.value;
  @override
  set isConvertingCarouselImage(bool value) => _isConvertingCarouselImage.value = value;

  @override
  bool get isConvertingLogo => _isConvertingLogo.value;
  @override
  set isConvertingLogo(bool value) => _isConvertingLogo.value = value;

  @override
  bool get canSaveReward => _canSaveReward.value;

  @override
  List<int> get filesToDelete => _filesToDelete.toList();

  // Validation state getters and setters
  @override
  String get validationRedeemCode => _validationRedeemCode.value;
  @override
  set validationRedeemCode(String value) => _validationRedeemCode.value = value;

  @override
  bool get isValidatingReward => _isValidatingReward.value;
  @override
  set isValidatingReward(bool value) => _isValidatingReward.value = value;

  @override
  String? get validationErrorMessage => _validationErrorMessage.value;
  @override
  set validationErrorMessage(String? value) => _validationErrorMessage.value = value;

  @override
  String? get validationSuccessMessage => _validationSuccessMessage.value;
  @override
  set validationSuccessMessage(String? value) => _validationSuccessMessage.value = value;

  @override
  ValidateRewardModel? get validatedReward => _validatedReward.value;
  @override
  set validatedReward(ValidateRewardModel? value) => _validatedReward.value = value;


  // General

  @override
  void onInit() {
    super.onInit();
    scaffoldKey = dashboardShellController.scaffoldKey;
    currentRoute = AppRoutes.rewards;
    dashboardShellController.currentRoute.value = currentRoute;

    _initializeViewMode();
    _setupFormValidation();
    _setupAnimations();
    _setupPreviewUpdates();
    _setupLoadingStateListeners();
    loadRewards();
  }

  void _initializeViewMode() {
    // Set default view mode based on screen size
    final screenWidth = Get.width;
    final isMobileOrTablet = screenWidth < 1200;
    _viewMode.value = (isMobileOrTablet ? 'list' : 'grid');
  }

  @override
  Future<void> loadRewards() async {
    try {
      _isLoading.value = true;

      // Get user token if not provided
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null) {
        log('[RewardsControllerImpl] No access token available');
        return;
      }

      final result = await usecase.getRewards(
        token: cachedUser!.accessToken!,
        page: _currentPage.value,
        perPage: _perPage.value,
        search: _searchQuery.value,
      );

      if (result != null) {
        // Update pagination state
        if (result.pagination != null) {
          _totalCount.value = result.pagination!.count ?? 0;
          _hasNextPage.value = result.pagination!.hasNext ?? false;
          _perPage.value = result.pagination!.perPage ?? 10;

          // Calculate safe current page
          final apiPage = result.pagination!.page ?? 1;
          final calculatedTotalPages =
              _totalCount.value > 0
                  ? ((_totalCount.value / _perPage.value).ceil())
                  : 1;

          _currentPage.value = apiPage.clamp(1, calculatedTotalPages);
        }

        _filteredRewards.value =
            result.result?.map((e) {
              return RewardResultModel(
                categories: e.categories,
                departmentId: e.departmentId,
                description: TranslateApiTextHelper.translate(
                  e.description ?? '',
                  locale: 'en_US',
                ),
                expiryDate: e.expiryDate,
                files: e.files,
                id: e.id,
                name: TranslateApiTextHelper.translate(
                  e.name ?? '',
                  locale: 'en_US',
                ),
                quantity: e.quantity,
                specifications: e.specifications,
                status: e.status,
                rules: e.rules,
              );
            }).toList();
        _rewards.value = _filteredRewards.value;
        
        // Apply initial filtering based on default status filter
        _applyInitialFilters();
      }
    } catch (e) {
      _filteredRewards.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  void _applyInitialFilters() {
    // Apply status filter based on default selectedStatusFilter ('active')
    if (_selectedStatusFilter.value == 'active') {
      _filteredRewards.value = _rewards.value?.where((reward) =>
        reward.canCheckout
      ).toList();
    } else if (_selectedStatusFilter.value == 'archived') {
      _filteredRewards.value = _rewards.value?.where((reward) =>
        !reward.canCheckout
      ).toList();
    }
    // For 'all' or other values, keep all rewards (no filtering)
  }

  // Functions

  void _setupFormValidation() {
    ever(_formTitle, (_) => validateForm());
    ever(_formDescription, (_) => validateForm());
    ever(_formHeaderImage, (_) => validateForm());
    ever(_formCategories, (_) => validateForm());
    ever(_formQuantity, (_) => validateForm());
    // for now ignore LinkedRules
    // ever(_formLinkedRules, (_) => validateForm());
  }

  void _setupPreviewUpdates() {
    ever(_formTitle, (_) => updatePreview());
    ever(_formDescription, (_) => updatePreview());
    ever(_formHeaderImage, (_) => updatePreview());
    ever(_formCarouselImages, (_) => updatePreview());
    ever(_formLogo, (_) => updatePreview());
    ever(_formCategories, (_) => updatePreview());
  }

  void _setupLoadingStateListeners() {
    ever(_isConvertingHeaderImage, (_) => _updateCanSaveReward());
    ever(_isConvertingCarouselImage, (_) => _updateCanSaveReward());
    ever(_isConvertingLogo, (_) => _updateCanSaveReward());
    ever(_isLoading, (_) => _updateCanSaveReward());
    ever(_isSaving, (_) => _updateCanSaveReward());
    ever(_isFormValid, (_) => _updateCanSaveReward());
  }

  void _updateCanSaveReward() {
    // Disable save during image conversions or other loading states
    final canSave = !_isConvertingHeaderImage.value && 
                    !_isConvertingCarouselImage.value && 
                    !_isConvertingLogo.value &&
                    !_isLoading.value &&
                    !_isSaving.value &&
                    _isFormValid.value;
    
    _canSaveReward.value = canSave;
    
    log('Can save reward: $canSave (converting: ${_isConvertingHeaderImage.value || _isConvertingCarouselImage.value || _isConvertingLogo.value}, loading: ${_isLoading.value}, saving: ${_isSaving.value}, valid: ${_isFormValid.value})');
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    ever(_showRulesPanel, (bool show) {
      if (show) {
        _animationController.forward();
        _rulesPanelHeight.value = 300.0;
      } else {
        _animationController.reverse();
        _rulesPanelHeight.value = 0.0;
      }
    });
  }

  @override
  void validateForm() {
    log('Form validation check:');
    log('  - Title: "${_formTitle.value}" (empty: ${_formTitle.value.isEmpty})');
    log('  - Description: "${_formDescription.value}" (empty: ${_formDescription.value.isEmpty})');
    log('  - Header Image: "${_formHeaderImage.value}" (empty: ${_formHeaderImage.value.isEmpty})');
    log('  - Categories: ${_formCategories.length} items');
    log('  - Linked Rules: ${_formLinkedRules.length} items');
    log('  - CanCheckout $_formCanCheckout');


    _isFormValid.value =
        _formTitle.value.isNotEmpty &&
        _formDescription.value.isNotEmpty &&
        _formHeaderImage.value.isNotEmpty &&
        _formCategories.isNotEmpty && 
        _formQuantity.value >= 0;
  }

  @override
  void updatePreview() {
    _previewTitle.value =
        _formTitle.value.isEmpty ? 'Reward Name' : _formTitle.value;
    _previewDescription.value =
        _formDescription.value.isEmpty
            ? 'Reward description will appear here...'
            : _formDescription.value;
    _previewHeaderImage.value = _formHeaderImage.value;
    _previewCarouselImages.assignAll(formCarouselImages);
    _previewLogo.value = _formLogo.value;
    _previewCategories.assignAll(formCategories);
  }

  @override
  void clearForm() {
    clearEditingState();
    _formTitle.value = '';
    _formDescription.value = '';
    _formHeaderImage.value = '';
    _formCarouselImages.clear();
    _formLogo.value = '';
    _formCategories.clear();
    _formLinkedRules.clear();
    _formCanCheckout.value = false;
    _formQuantity.value = 0;
    _formExpiryDate.value = null;
    _selectedRulesData.clear();
    
    // Clear new rule selection state
    _selectedRuleIds.clear();
    _originalSelectedRuleIds.clear();
    _originalRewardRuleIds.clear();
    _originalRuleSelections.clear();
  }

  @override
  void initializeEditingMode(List<RewardResultFileModel> originalFiles) {
    _isCreating.value = true;
    _originalFiles.clear();
    _originalFiles.assignAll(originalFiles);
    _filesToDelete.clear();
    
    // Map current files directly
    _currentHeaderFile = originalFiles.isNotEmpty ? originalFiles.first : null;
    _currentCarouselFiles.clear();
    if (originalFiles.length > 1) {
      _currentCarouselFiles.addAll(originalFiles.skip(1));
    }
    
    log('Editing mode initialized with ${originalFiles.length} original files');
  }

  @override
  void markFileForDeletion(int fileId) {
    if (!_filesToDelete.contains(fileId)) {
      _filesToDelete.add(fileId);
      log('Marked file for deletion: ID $fileId');
    }
  }

  @override
  void clearEditingState() {
    _isCreating.value = false;
    _originalFiles.clear();
    _filesToDelete.clear();
    _currentHeaderFile = null;
    _currentCarouselFiles.clear();
  }

  @override
  RewardResultFileModel? findOriginalFileByUrl(String url) {
    for (final file in _originalFiles) {
      if (file.url == url) {
        return file;
      }
    }
    return null;
  }

  @override
  void setOriginalHeaderFile(RewardResultFileModel? file) {
    _currentHeaderFile = file;
  }

  @override
  void setOriginalCarouselFiles(List<RewardResultFileModel> files) {
    _currentCarouselFiles.clear();
    _currentCarouselFiles.addAll(files);
  }

  // Efficient methods for tracking deletions
  @override
  void markCurrentHeaderForDeletion() {
    log('🔍 DEBUG: Marking header for deletion - current file: ${_currentHeaderFile?.id}');
    if (_currentHeaderFile?.id != null) {
      markFileForDeletion(_currentHeaderFile!.id!);
      log('🔍 DEBUG: Header file ${_currentHeaderFile!.id} marked for deletion');
      _currentHeaderFile = null;
    } else {
      log('🔍 DEBUG: No current header file to delete');
    }
  }

  @override
  void markCarouselFileForDeletion(String url) {
    log('🔍 DEBUG: Attempting to delete carousel image with URL: $url');
    log('🔍 DEBUG: Current carousel files count: ${_currentCarouselFiles.length}');
    log('🔍 DEBUG: Current carousel file URLs: ${_currentCarouselFiles.map((f) => f.url).toList()}');
    
    final fileToRemove = _currentCarouselFiles.where((f) => f.url == url).isNotEmpty 
        ? _currentCarouselFiles.where((f) => f.url == url).first
        : null;
        
    if (fileToRemove != null) {
      log('🔍 DEBUG: Found matching file with ID: ${fileToRemove.id}');
      if (fileToRemove.id != null) {
        markFileForDeletion(fileToRemove.id!);
        _currentCarouselFiles.remove(fileToRemove);
        log('🔍 DEBUG: Carousel file ${fileToRemove.id} marked for deletion');
      } else {
        log('🔍 DEBUG: File found but ID is null');
      }
    } else {
      log('🔍 DEBUG: No matching carousel file found for URL: $url');
    }
  }


  @override
  void updateSelectedRulesData() {
    selectedRulesData.clear();
    for (String ruleId in formLinkedRules) {
      final rule = availableRules.firstWhereOrNull((r) => r.id == ruleId);
      if (rule != null) {
        selectedRulesData.add(rule);
      }
    }
  }

  @override
  Future<void> loadAvailableRules() async {
    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      
      if (cachedUser?.accessToken == null) {
        log('[RewardsPresenterImpl] No access token available for loading rules');
        return;
      }

      final result = await usecase.fetchRules(
        token: cachedUser!.accessToken!,
      );

      _availableRules.assignAll(result.items.map((ruleResult) => RuleModel(
        id: ruleResult.id?.toString() ?? '',
        title: ruleResult.name ?? '',
        description: 'Rule created from API',
        recycleCount: ruleResult.quantity ?? 0,
        categories: ['General'],
        createdAt: ruleResult.expiryDate ?? DateTime.now(),
        createdBy: 'System',
      )));
      
      log('[RewardsPresenterImpl] Loaded ${_availableRules.length} rules');
    } catch (e) {
      log('[RewardsPresenterImpl] Failed to load rules: $e');
      _availableRules.clear();
    }
  }

  @override
  void resetRuleSelectionState() {
    _ruleSelectionCurrentPage.value = 1;
    _ruleSelectionSearchQuery.value = '';
    _ruleSelectionItems.clear();
    _isRuleSelectionLoading.value = false;
  }

  @override
  void storeOriginalRuleSelections() {
    _originalRuleSelections = List<String>.from(_formLinkedRules);
    _originalSelectedRuleIds = List<int>.from(_selectedRuleIds);
  }

  @override
  void restoreOriginalRuleSelections() {
    _formLinkedRules.assignAll(_originalRuleSelections);
    _selectedRuleIds.assignAll(_originalSelectedRuleIds);
    updateSelectedRulesData();
  }

  @override
  void resetValidationState() {
    _validationRedeemCode.value = '';
    _isValidatingReward.value = false;
    _validationErrorMessage.value = null;
    _validationSuccessMessage.value = null;
    _validatedReward.value = null;
  }

  // New methods following rules_v2 pattern
  
  /// Getter for selected rule IDs (integer-based)
  @override
  RxList<int> get selectedRuleIds => _selectedRuleIds;
  
  /// Setter for selected rule IDs
  @override
  set selectedRuleIds(List<int> value) => _selectedRuleIds.assignAll(value);
  
  /// Get count of selected rules
  @override
  int get selectedRuleCount => _selectedRuleIds.length;
  
  /// Populate rule selections from existing reward data (edit mode)
  @override
  void populateSelectionsFromReward(RewardResultModel reward) {
    log('[RewardsPresenter] populateSelectionsFromReward - RAW reward.rules: ${reward.rules}');
    
    // Extract rule IDs from the reward's linked rules
    final ruleIds = reward.rules?.map((rule) {
      log('[RewardsPresenter] Processing rule: id=${rule.id}, name=${rule.name}');
      return rule.id;
    }).whereType<int>().toList() ?? [];
    
    log('[RewardsPresenter] populateSelectionsFromReward - extracted IDs: $ruleIds');
    
    // Store original rule selections for delta calculation
    _originalRewardRuleIds = List<int>.from(ruleIds);
    
    // Set current selections
    _selectedRuleIds.assignAll(ruleIds);
    
    // Also update the string-based formLinkedRules for backward compatibility
    _formLinkedRules.assignAll(ruleIds.map((id) => id.toString()).toList());
    
    log('[RewardsPresenter] selectedRuleIds after assignAll: $_selectedRuleIds');
    log('[RewardsPresenter] formLinkedRules after assignAll: $_formLinkedRules');
  }
  
  /// Trigger GetX reactivity for rule selections
  @override
  void refreshRuleSelections() {
    _selectedRuleIds.refresh();
    _formLinkedRules.refresh();
  }
  
  /// Get original rule IDs for delta calculation
  @override
  List<int> get originalRewardRuleIds => _originalRewardRuleIds;
  
  /// Calculate which rules to add vs remove for edit operations
  @override
  Map<String, List<int>?> calculateRuleDelta() {
    final currentRuleIds = Set<int>.from(_selectedRuleIds);
    final originalRuleIds = Set<int>.from(_originalRewardRuleIds);
    
    // Items to add = current - original
    final rulesToAdd = currentRuleIds.difference(originalRuleIds).toList();
    
    // Items to remove = original - current
    final rulesToRemove = originalRuleIds.difference(currentRuleIds).toList();
    
    return {
      'add': rulesToAdd.isEmpty ? null : rulesToAdd,
      'remove': rulesToRemove.isEmpty ? null : rulesToRemove,
    };
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}

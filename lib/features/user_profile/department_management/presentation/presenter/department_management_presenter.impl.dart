import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../../data/models/manage_team.dart';
import '../../data/usecase/department_managment_usecase.interface.dart';
import 'department_management_presenter.interface.dart';

/// Implementation of the Department Management Presenter
/// Manages reactive state for team member data and UI interactions using GetX
class DepartmentManagementPresenterImpl extends GetxController
    implements DepartmentManagementPresenterInterface {
  final DepartmentManagmentUseCaseInterface _useCase;
  DepartmentManagementPresenterImpl(this._useCase);

  // Reactive state properties using GetX
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final _teamMembers = RxList<ManageTeamModel>([]);
  final RxList<ManageTeamModel> _filteredMembers = <ManageTeamModel>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedRole = 'member'.obs;
  final RxBool _isDialogLoading = false.obs;
  final RxString _dialogError = ''.obs;
  final RxString _nameError = ''.obs;
  final RxString _emailError = ''.obs;
  final RxBool _isFormValid = false.obs;
  final _user = Rx<UserAuthModel?>(null);

  // Form controllers for member dialog
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  bool get isLoading => _isLoading.value;

  @override
  set isLoading(bool value) => _isLoading.value = value;

  @override
  String get error => _error.value;

  @override
  set error(String value) => _error.value = value;

  @override
  List<ManageTeamModel> get teamMembers => _teamMembers.toList();

  @override
  set teamMembers(List<ManageTeamModel> value) {
    _teamMembers.assignAll(value);
    filterMembers(); // Update filtered list when members change
  }

  @override
  List<ManageTeamModel> get filteredMembers => _filteredMembers.toList();

  @override
  String get searchQuery => _searchQuery.value;

  @override
  set searchQuery(String value) {
    _searchQuery.value = value;
    filterMembers(); // Update filtered list when search query changes
  }

  @override
  TextEditingController get nameController => _nameController;

  @override
  TextEditingController get emailController => _emailController;

  @override
  String get selectedRole => _selectedRole.value;

  @override
  set selectedRole(String value) => _selectedRole.value = value;

  @override
  bool get isDialogLoading => _isDialogLoading.value;

  @override
  set isDialogLoading(bool value) => _isDialogLoading.value = value;

  @override
  String get dialogError => _dialogError.value;

  @override
  set dialogError(String value) => _dialogError.value = value;

  @override
  String get nameError => _nameError.value;

  @override
  set nameError(String value) => _nameError.value = value;

  @override
  String get emailError => _emailError.value;

  @override
  set emailError(String value) => _emailError.value = value;

  @override
  bool get isFormValid => _isFormValid.value;

  @override
  set isFormValid(bool value) => _isFormValid.value = value;

  @override
  UserAuthModel? get user => _user.value;

  @override
  set user(UserAuthModel? value) => _user.value = value;

  @override
  void onInit() {
    super.onInit();
    // init API load department
    loadDepartment();
  }

  @override
  void onClose() {
    // Dispose of controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    super.onClose();
  }

  @override
  void filterMembers() {
    if (_searchQuery.value.isEmpty) {
      _filteredMembers.assignAll(_teamMembers);
    } else {
      final query = _searchQuery.value.toLowerCase();
      final filtered =
          _teamMembers.where((member) {
            final name = member.name?.toLowerCase() ?? '';
            final email = member.displayEmail.toLowerCase() ?? '';
            return name.contains(query) || email.contains(query);
          }).toList();
      _filteredMembers.assignAll(filtered);
    }
  }

  @override
  void clearForm() {
    _nameController.clear();
    _emailController.clear();
    _selectedRole.value = 'member';
    _dialogError.value = '';
    _nameError.value = '';
    _emailError.value = '';
    _isFormValid.value = false;
  }

  @override
  void populateForm(ManageTeamModel member) {
    _nameController.text = member.name ?? '';
    _emailController.text = member.displayEmail;
    _selectedRole.value = member.roleName ?? 'member';
    _dialogError.value = '';
    _nameError.value = '';
    _emailError.value = '';
    validateForm();
  }

  /// Add a new member to the list
  @override
  void addMemberToList(ManageTeamModel member) {
    final updatedMembers = List<ManageTeamModel>.from(_teamMembers);
    updatedMembers.add(member);
    teamMembers = updatedMembers;
  }

  /// Update an existing member in the list
  @override
  void updateMemberInList(ManageTeamModel updatedMember) {
    final updatedMembers =
        _teamMembers.map((member) {
          return member.userId == updatedMember.userId ? updatedMember : member;
        }).toList();
    teamMembers = updatedMembers;
  }

  /// Remove a member from the list
  @override
  void removeMemberFromList(int memberId) {
    final updatedMembers =
        _teamMembers.where((member) => member.userId != memberId).toList();
    teamMembers = updatedMembers;
  }

  /// Get member by ID
  @override
  ManageTeamModel? getMemberById(int memberId) {
    try {
      return _teamMembers.firstWhere((member) => member.userId == memberId);
    } catch (e) {
      return null;
    }
  }

  /// Check if email already exists in the team
  @override
  bool isEmailAlreadyExists(String email, {int? excludeMemberId}) {
    return _teamMembers.any(
      (member) =>
          (member.displayEmail.toLowerCase()) == email.toLowerCase() &&
          member.userId != excludeMemberId,
    );
  }

  /// Get available roles for selection
  List<String> get availableRoles => ['member', 'admin'];

  /// Get member count by role
  int getMemberCountByRole(String role) {
    return _teamMembers.where((member) => member.roleName == role).length;
  }

  @override
  void validateName(String value) {
    if (value.trim().isEmpty) {
      nameError = 'Name is required';
    } else if (value.trim().length < 2) {
      nameError = 'Name must be at least 2 characters';
    } else {
      nameError = '';
    }
    validateForm();
  }

  @override
  void validateEmail(String value, {int? excludeMemberId}) {
    if (value.trim().isEmpty) {
      emailError = 'Email is required';
    } else {
      // Basic email validation
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!emailRegex.hasMatch(value.trim())) {
        emailError = 'Please enter a valid email address';
      } else if (isEmailAlreadyExists(
        value.trim(),
        excludeMemberId: excludeMemberId,
      )) {
        emailError = 'This email is already associated with a team member';
      } else {
        emailError = '';
      }
    }
    validateForm();
  }

  @override
  void validateForm() {
    // For add mode, only email needs to be valid
    // For edit mode, both name and email need to be valid
    final isEmailValid =
        emailError.isEmpty && emailController.text.trim().isNotEmpty;
    final isNameValid =
        nameError.isEmpty && nameController.text.trim().isNotEmpty;

    // Form is valid if email is valid (for add mode) or both name and email are valid (for edit mode)
    isFormValid = isEmailValid && (nameController.text.isEmpty || isNameValid);
  }

  // API
  @override
  Future<void> loadDepartment() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Get user token
      _user.value = await AuthCacheDataSource.instance.getUserAuth();
      if (_user.value?.accessToken == null) return;

      // API Call
      final teamMembers = await _useCase.getDepartmentTeam(
        _user.value!.accessToken!,
      );
      this.teamMembers = teamMembers;

      // If teamMembers is empty, show mock data for development
      if (teamMembers.isEmpty) {
        this.teamMembers = ManageTeamModel.generateMockData();
      }

      _teamMembers.value = this.teamMembers;

      for (var member in _teamMembers) {
        member.isMyAccount = member.userId == _user.value?.profile?.id;
        log(
          '[loadDepartment] member.userId: ${member.userId}, _user.value?.profile?.id: ${_user.value?.profile?.id}, isMyAccount: ${member.isMyAccount}',
        );
      }

      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      _error.value = 'Failed to load department data. Please try again.';
    }
  }
}

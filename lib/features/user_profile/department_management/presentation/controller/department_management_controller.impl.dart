import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/user_profile/department_management/data/models/team.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../data/models/manage_team.dart';
import '../../data/usecase/department_managment_usecase.interface.dart';
import '../presenter/department_management_presenter.interface.dart';
import '../widgets/team_member_dialog.dart';
import '../widgets/delete_member_dialog.dart';
import '../widgets/transfer_ownership_dialog.dart';
import 'department_management_controller.interface.dart';

/// Implementation of the Department Management Controller
/// Handles user interactions and coordinates with the presenter using mock business logic
class DepartmentManagementControllerImpl
    implements DepartmentManagementControllerInterface {
  final DepartmentManagmentUseCaseInterface _usecase;
  final DepartmentManagementPresenterInterface _presenter;

  DepartmentManagementControllerImpl(this._presenter, this._usecase);

  @override
  Future<void> addMember() async {
    try {
      _presenter.isDialogLoading = true;
      _presenter.dialogError = '';

      // Validate email field
      final email = _presenter.emailController.text.trim();
      if (email.isEmpty) {
        _presenter.dialogError = 'Email is required';
        _presenter.isDialogLoading = false;
        return;
      }

      if (!_isValidEmail(email)) {
        _presenter.dialogError = 'Please enter a valid email address';
        _presenter.isDialogLoading = false;
        return;
      }

      // Check if email already exists
      if (_presenter.isEmailAlreadyExists(email)) {
        _presenter.dialogError = 'A team member with this email already exists';
        _presenter.isDialogLoading = false;
        return;
      }

      // API (for now multiple invite email not implement only one)
      // Get user token
      final user = await AuthCacheDataSource.instance.getUserAuth();
      if (user?.accessToken == null) return;
      await _usecase.inviteToDepartment([email], user!.accessToken!);

      // Create new member with mock data
      final newMember = ManageTeamModel.generateSingleMockMember(
        name: _extractNameFromEmail(email),
        roleName: 'pending', // New members start as pending
        userId: 142, // Default role
      );

      // Add to presenter's member list
      _presenter.addMemberToList(newMember);

      // Clear form and close dialog
      _presenter.clearForm();
      _presenter.isDialogLoading = false;

      // Close dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Team member invited successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      _presenter.isDialogLoading = false;
      _presenter.dialogError = 'Failed to add team member. Please try again.';
    }
  }

  @override
  Future<void> updateMember(int memberId) async {
    try {
      _presenter.isDialogLoading = true;
      _presenter.dialogError = '';

      // Validate form fields
      final name = _presenter.nameController.text.trim();
      final email = _presenter.emailController.text.trim();
      final role = _presenter.selectedRole;

      if (name.isEmpty) {
        _presenter.dialogError = 'Name is required';
        _presenter.isDialogLoading = false;
        return;
      }

      if (email.isEmpty) {
        _presenter.dialogError = 'Email is required';
        _presenter.isDialogLoading = false;
        return;
      }

      if (!_isValidEmail(email)) {
        _presenter.dialogError = 'Please enter a valid email address';
        _presenter.isDialogLoading = false;
        return;
      }

      // Check if email already exists (excluding current member)
      if (_presenter.isEmailAlreadyExists(email, excludeMemberId: memberId)) {
        _presenter.dialogError = 'A team member with this email already exists';
        _presenter.isDialogLoading = false;
        return;
      }

      // Get current member
      final currentMember = _presenter.getMemberById(memberId);
      if (currentMember == null) {
        _presenter.dialogError = 'Team member not found';
        _presenter.isDialogLoading = false;
        return;
      }

      // Mock API delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Create updated member
      final updatedMember = ManageTeamModel.fromJson(currentMember.toJson());

      // Update in presenter's member list
      _presenter.updateMemberInList(updatedMember);

      // Clear form and close dialog
      _presenter.clearForm();
      _presenter.isDialogLoading = false;

      // Close dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Team member updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      _presenter.isDialogLoading = false;
      _presenter.dialogError =
          'Failed to update team member. Please try again.';
    }
  }

  @override
  Future<void> deleteMember(int memberId) async {
    try {
      // Get member details for confirmation
      final member = _presenter.getMemberById(memberId);
      if (member == null) {
        Get.snackbar(
          'Error',
          'Team member not found',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return;
      }

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        DeleteMemberDialog(
          member: member,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        ),
      );

      if (confirmed != true) return;

      // Mock API delay
      final user = await AuthCacheDataSource.instance.getUserAuth();
      if (user?.accessToken == null) return;
      final manageTeamMember = ManageTeamModel(
        userId: memberId,
        roleName: member.roleName,
        remove: 'True',
      );
      await _usecase.manageTeam(
        user!.accessToken!,
        TeamModel(team: [manageTeamMember]),
      );

      // Remove from presenter's member list
      _presenter.removeMemberFromList(memberId);

      // Show success message
      Get.snackbar(
        'Success',
        'Team member removed successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete team member. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Future<void> transferOwnership(int memberId) async {
    try {
      // Get member details for confirmation
      final member = _presenter.getMemberById(memberId);
      if (member == null) {
        Get.snackbar(
          'Error',
          'Team member not found',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return;
      }

      // get cached user role to transfer
      final updatedMember = ManageTeamModel.fromJson(member.toJson());
      updatedMember.roleName =
          (_presenter.user?.profile?.roles?.first ?? '') == 't4b'
              ? 'owner'
              : (_presenter.user?.profile?.roles?.first ?? '');

      // Show transfer confirmation dialog
      final confirmed = await Get.dialog<bool>(
        TransferOwnershipDialog(
          member: member,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
          roleNameToTransfer: updatedMember.roleName!,
        ),
      );

      if (confirmed != true) return;

      // Mock API delay
      await _usecase.transferOwnership(
        _presenter.user!.accessToken!,
        updatedMember.userId!,
      );

      _presenter.updateMemberInList(updatedMember);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to transfer ownership. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onSearchChanged(String query) {
    _presenter.searchQuery = query;
  }

  @override
  void showAddMemberDialog() {
    _presenter.clearForm();
    // Dialog will be shown by the view layer
  }

  @override
  void showEditMemberDialog(ManageTeamModel member) {
    _presenter.populateForm(member);
    // Dialog will be shown by the view layer
  }

  @override
  void showDeleteConfirmation(ManageTeamModel member) async {
    final confirmed = await Get.dialog<bool>(
      DeleteMemberDialog(
        member: member,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
    );

    if (confirmed == true) {
      if (member.isMyAccount ?? false) {
        await leaveDepartment();
      } else {
        await deleteMember(member.userId!);
      }
    }

    _presenter.loadDepartment();
  }

  @override
  void showTransferConfirmation(
    ManageTeamModel member,
    String roleNameToTransfer,
  ) async {
    final confirmed = await Get.dialog<bool>(
      TransferOwnershipDialog(
        member: member,
        roleNameToTransfer: roleNameToTransfer,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
    );

    if (confirmed == true) {
      transferOwnership(member.userId!);
    }
  }

  @override
  void showAddMemberDialogUI() {
    showAddMemberDialog();
    Get.dialog(
      TeamMemberDialog(
        presenter: _presenter,
        isAddingMember: true,
        onSave: () async => await addMember(),
        onCancel: () => Get.back(),
      ),
    );
  }

  @override
  void showEditMemberDialogUI(ManageTeamModel member) {
    showEditMemberDialog(member);
    Get.dialog(
      TeamMemberDialog(
        presenter: _presenter,
        isAddingMember: false,
        member: member,
        onSave: () async => await saveMember(member),
        onCancel: () => Get.back(),
      ),
    );
  }

  Future<void> saveMember(ManageTeamModel member) async {
    final user = await AuthCacheDataSource.instance.getUserAuth();
    if (user?.accessToken == null) return;

    if (member.roleName == 'admin') {
      member.roleName = 't4b_admin';
    } 
   
    final manageTeamMember = ManageTeamModel(
      userId: member.userId,
      roleName: member.roleName,
    );

    await _usecase.manageTeam(
      user!.accessToken!,
      TeamModel(team: [manageTeamMember]),
    );
  }

  @override
  void onBack() {
    Get.back();
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Extract name from email for mock data
  String _extractNameFromEmail(String email) {
    final username = email.split('@').first;
    final parts = username.split('.');
    if (parts.length >= 2) {
      return parts.map((part) => _capitalize(part)).join(' ');
    }
    return _capitalize(username);
  }

  /// Capitalize first letter of a string
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Future<void> leaveDepartment() async {
    try {
      await _usecase.leaveDepartment(_presenter.user!.accessToken!);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to leave department. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../../data/models/manage_team.dart';

/// Interface for the Department Management Presenter
/// Defines reactive state properties and methods for managing team member data and UI state
abstract class DepartmentManagementPresenterInterface extends GetxController {
  // State properties for loading and error handling
  bool get isLoading;
  set isLoading(bool value);

  String get error;
  set error(String value);

  // Team member data properties
  List<ManageTeamModel> get teamMembers;
  set teamMembers(List<ManageTeamModel> value);

  List<ManageTeamModel> get filteredMembers;

  // Search functionality
  String get searchQuery;
  set searchQuery(String value);

  // Form controllers for member dialog
  TextEditingController get nameController;
  TextEditingController get emailController;
  String get selectedRole;
  set selectedRole(String value);

  // Dialog state properties
  bool get isDialogLoading;
  set isDialogLoading(bool value);

  String get dialogError;
  set dialogError(String value);

  // Form validation state
  String get nameError;
  set nameError(String value);

  String get emailError;
  set emailError(String value);

  bool get isFormValid;
  set isFormValid(bool value);

  UserAuthModel? get user;
  set user(UserAuthModel? value);

  // Methods for managing state and form data
  void filterMembers();
  void clearForm();
  void populateForm(ManageTeamModel member);
  void validateName(String value);
  void validateEmail(String value, {int? excludeMemberId});
  void validateForm();

  // Methods for member management
  void addMemberToList(ManageTeamModel member);
  void updateMemberInList(ManageTeamModel updatedMember);
  void removeMemberFromList(int memberId);
  ManageTeamModel? getMemberById(int memberId);
  bool isEmailAlreadyExists(String email, {int? excludeMemberId});


  // API methods
  Future<void> loadDepartment();
}

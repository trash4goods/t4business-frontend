import '../../data/models/manage_team.dart';

/// Interface for the Department Management Controller
/// Defines methods for handling user interactions and business logic coordination
abstract class DepartmentManagementControllerInterface {
  /// Add a new team member
  Future<void> addMember();

  /// Update an existing team member's role
  Future<void> updateMember(int userId);

  /// Delete a team member
  Future<void> deleteMember(int userId);

  /// Transfer ownership to another team member
  Future<void> transferOwnership(int userId);

  /// Leave Department 
  Future<void> leaveDepartment();

  /// Handle search query changes
  void onSearchChanged(String query);

  /// Show add member dialog
  void showAddMemberDialog();

  /// Show edit member dialog
  void showEditMemberDialog(ManageTeamModel member);

  /// Show add member dialog with UI
  void showAddMemberDialogUI();

  /// Show edit member dialog with UI
  void showEditMemberDialogUI(ManageTeamModel member);

  /// Show delete confirmation dialog
  void showDeleteConfirmation(ManageTeamModel member);

  /// Show transfer ownership confirmation dialog
  void showTransferConfirmation(ManageTeamModel member, String roleNameToTransfer);

  /// Handle back navigation
  void onBack();
}

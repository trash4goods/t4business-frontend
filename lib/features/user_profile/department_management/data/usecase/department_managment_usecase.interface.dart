import '../models/manage_team.dart';
import '../models/team.dart';

/// Use case interface for department management operations
/// Handles business logic for team member operations using ManageTeamModel
abstract class DepartmentManagmentUseCaseInterface {
  /// Invite users to the department by email
  /// Validates email format and handles invitation business logic
  Future<void> inviteToDepartment(List<String> emails, String token);

  /// Get the list of team members for the department
  /// Returns ManageTeamModel objects with userId, roleName, and name properties
  Future<List<ManageTeamModel>> getDepartmentTeam(String token);

  /// Leave the current department
  /// Handles business logic for user leaving their current department
  Future<void> leaveDepartment(String token);

  /// Transfer ownership to another team member using String userId
  /// Validates the new owner exists and has appropriate permissions
  Future<void> transferOwnership(String token, int newOwnerUserId);

  /// Manage team operations (add, update, remove members)
  /// Uses ManageTeamModel with String userId, String roleName, and String name
  /// Handles business logic validation for team member operations
  Future<void> manageTeam(String token, TeamModel? team);
}

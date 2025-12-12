import '../models/manage_team.dart';
import '../models/team.dart';

/// Repository interface for department management operations
/// Handles team member data using the simplified ManageTeamModel
abstract class DepartmentManagmentRepositoryInterface {
  /// Invite users to the department by email
  Future<void> inviteToDepartment(List<String> emails, String token);

  /// Get the list of team members for the department
  Future<List<ManageTeamModel>> getDepartmentTeam(String token);

  /// Leave the current department
  Future<void> leaveDepartment(String token);

  /// Transfer ownership to another team member using String userId
  Future<void> transferOwnership(String token, int newOwnerUserId);

  /// Manage team operations (add, update, remove members)
  /// Uses ManageTeamModel with String userId, String roleName, and String name
  Future<void> manageTeam(String token, TeamModel? team);
}
